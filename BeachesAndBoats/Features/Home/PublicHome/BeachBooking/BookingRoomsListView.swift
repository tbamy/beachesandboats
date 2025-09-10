//
//  BookingRoomsListView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 28/12/2024.
//


import UIKit

class BookingRoomsListView: BaseViewControllerPlain {
    
    var coordinator: ExploreCoordinator?
    
    @IBOutlet weak var roomsCollectionView: UICollectionView!
    @IBOutlet weak var reserveBtn: PrimaryButton!
    @IBOutlet weak var reserveBtnView: UIView!
    
    var rooms: [BeachRoom] = []
    var roomId: String?
    var listing: GetBeachData?
    var booking: CreateBeachHouseBookingRequest?
    var selectedIndex: Int? = nil
    var selectedQuantity: Int = 1 // Track selected quantity
    var isDayBooking: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
//        title = "Select Stay \(listing?.name ?? "")"
        
        let titleLabel = UILabel()
        titleLabel.text = "Select Stay"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.textAlignment = .center

        let subtitleLabel = UILabel()
        subtitleLabel.text = "\(listing?.name ?? "")"
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.textColor = .gray
        subtitleLabel.textAlignment = .center

        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.alignment = .center

        navigationItem.titleView = stackView

        setup()
        print(listing)
        
    }

    func setup(){
        roomsCollectionView.delegate = self
        roomsCollectionView.dataSource = self
        roomsCollectionView.backgroundColor = .clear
        roomsCollectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        isDayBooking = booking?.bookingType == "DAY"
        rooms = listing?.rooms ?? []
        reserveBtnView.isHidden = true
    }

    func calculateNights(from startDateString: String, to endDateString: String, format: String = "MM/dd/yyyy") -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        print("From: \(startDateString) - To: \(endDateString)")
        guard let startDate = dateFormatter.date(from: startDateString),
              let endDate = dateFormatter.date(from: endDateString) else {
            return nil
        }
        
        guard endDate > startDate else { return nil }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        
        return components.day
    }
    
    @IBAction func reserveBtnTapped(_ sender: Any){
        print("Listing: \(listing)")
        print("Booking: \(booking)")
        print("Room ID: \(roomId)")
        print("Selected Quantity: \(selectedQuantity)")
        
        if let listing = listing, let booking = booking, let roomId = roomId{
            coordinator?.gotoConfirmBookingView(units: selectedQuantity, listing: listing, booking: booking, roomId: roomId)
        }
    }

    func showQuantityPicker(for roomIndex: Int) {
        let room = rooms[roomIndex]
        let maxQuantity = room.quantity ?? 1 // Use room's quantity as max
        
        let alert = UIAlertController(title: "Select Quantity", message: "\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.tag = maxQuantity // Store max quantity in tag
        
        alert.view.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            picker.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            picker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 40),
            picker.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -40)
        ])
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let selectedRow = picker.selectedRow(inComponent: 0)
            self.selectedQuantity = selectedRow + 1
            self.selectedIndex = roomIndex
            self.roomsCollectionView.reloadData()
            self.roomId = room.id
            self.reserveBtnView.isHidden = false
            
            if let price = self.isDayBooking ? room.pricePerDay : room.pricePerNight {
                let totalPrice = price * (Float(self.selectedQuantity))
                self.reserveBtn.setTitle("Reserve for ₦ \(totalPrice.toAmount() ?? "0")", for: .normal)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension BookingRoomsListView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = roomsCollectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
        let room = rooms[indexPath.item]
        
        let view = BookingRoomCell(frame: cell.bounds)
        view.identifier = "Rooms " + indexPath.description
        view.model.title = room.name ?? ""
        view.layer.cornerRadius = 8
        
        let descriptions = room.bedTypes?.compactMap { bedType -> String? in
            guard let name = bedType.name, let quantity = bedType.quantity, Int(quantity) ?? 0 > 0 else { return nil }
            return "\(quantity): \(name)"
        }
        view.model.bedType = descriptions?.joined(separator: ", ") ?? ""
        
        let startDateString = booking?.checkingDate ?? ""
        let endDateString = booking?.checkoutDate ?? ""
        let nights = calculateNights(from: startDateString, to: endDateString)
//        let isDayBooking = booking?.bookingType == "DAY"
        view.model.date = isDayBooking ? "\(startDateString.convertToShorterDateFormat() ?? "") (Day booking)"  : "\(startDateString.convertToShorterDateFormat() ?? "") - \(endDateString.convertToShorterDateFormat() ?? "") (\(nights ?? 0) Nights)"
        view.model.guests = "\(room.noOfOccupant ?? "") Guests"
        view.model.img = room.images?.first?.url ?? ""
        view.model.amenities = listing?.amenities ?? []
        
        if let price = isDayBooking ? room.pricePerDay : room.pricePerNight {
            view.model.price = "₦ \(price.toAmount() ?? "0")"
        }
        
        view.model.roomIndex = indexPath.item
        view.model.maxQuantity = room.quantity ?? 1
        view.model.selectedQuantity = (indexPath.item == selectedIndex) ? selectedQuantity : 1
        view.model.tapped = { [weak self] in
            guard let self = self else { return }
            self.showQuantityPicker(for: indexPath.item)
        }
        
        view.model.state = (indexPath.item == selectedIndex)
        
        cell.applyView(view: view)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 20, height: 455) // Adjust height as needed based on content
    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = roomsCollectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
//        let cellAt = rooms[indexPath.item]
//        
//        let view = BookingRoomCell(frame: cell.bounds)
//        view.identifier = "Rooms " + indexPath.description
//        view.model.title = cellAt.name ?? ""
//        view.layer.cornerRadius = 8
//        
//        let descriptions = cellAt.bedTypes?.compactMap { bedType -> String? in
//            guard let name = bedType.name, let quantity = bedType.quantity, Int(quantity) ?? 0 > 0 else { return nil }
//            return "\(quantity): \(name)"
//        }
//        view.model.bedType = descriptions?.joined(separator: ", ") ?? ""
//        
//        let startDateString = booking?.checkingDate ?? ""
//        let endDateString = booking?.checkoutDate ?? ""
//        
//        let nights = calculateNights(from: startDateString, to: endDateString)
//        let isDayBooking = booking?.bookingType == "DAY"
//        view.model.date = "\(startDateString.convertToShorterDateFormat() ?? "") - \(endDateString.convertToShorterDateFormat() ?? "") (\(nights ?? 0) \(isDayBooking ? "Days" : "Nights"))"
//        view.model.guests = "\(cellAt.noOfOccupant ?? "") Guests"
//        view.model.img = cellAt.images?.first?.url ?? ""
//        view.model.amenities = listing?.amenities ?? []
//        
//        if let price = isDayBooking ? cellAt.pricePerDay : cellAt.pricePerNight {
//            view.model.price = "₦ \(price.toAmount() ?? "0")"
//        }
//        
//        // Pass the room index and quantity to the cell
//        view.model.roomIndex = indexPath.item
//        view.model.maxQuantity = cellAt.quantity ?? 1
//        view.model.selectedQuantity = (indexPath.item == selectedIndex) ? selectedQuantity : 1
//        
//        view.model.tapped = { [weak self] in
//            guard let self = self else { return }
//            self.showQuantityPicker(for: indexPath.item)
//        }
//
//        // Update the state based on selection
//        view.model.state = (indexPath.item == selectedIndex)
//        
//        cell.applyView(view: view)
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.bounds.width - 10, height: 480)
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let listing = listing, let booking = booking{
            roomId = rooms[indexPath.item].id
            coordinator?.gotoRoomDetailsView(units: selectedQuantity, listing: listing, booking: booking, room: rooms[indexPath.item])
        }
    }
}

extension BookingRoomsListView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView.tag // Use the tag which stores max quantity
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1) Unit"
    }
}

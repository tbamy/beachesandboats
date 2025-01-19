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
    
    var rooms: [BookingRoom] = []
    var roomId: String?
    var listing: Listing?
    var booking: CreateBeachHouseBookingRequest?
    var selectedIndex: Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select Stay \(listing?.name ?? "")"
        setup()
    }

    func setup(){
        roomsCollectionView.delegate = self
        roomsCollectionView.dataSource = self
        roomsCollectionView.backgroundColor = .clear
        roomsCollectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        
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
        if let listing = listing, let booking = booking, let roomId = roomId{
            
            coordinator?.gotoConfirmBookingView(listing: listing, booking: booking, roomId: roomId)
        }
    }

}


extension BookingRoomsListView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = roomsCollectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
        let cellAt = rooms[indexPath.item]
        
        let view = BookingRoomCell(frame: cell.bounds)
        view.identifier = "Rooms " + indexPath.description
        view.model.title = cellAt.name ?? ""
        view.layer.cornerRadius = 8
        
        let descriptions = cellAt.bedTypes?.compactMap { bedType -> String? in
            guard let name = bedType.name, let quantity = bedType.quantity else { return nil }
            return "\(quantity): \(name)"
        }
        view.model.bedType = descriptions?.joined(separator: ", ") ?? ""
        
        let startDateString = booking?.checkingDate ?? ""
        let endDateString = booking?.checkoutDate ?? ""
        
        let nights = calculateNights(from: startDateString, to: endDateString)
        view.model.date = "\(startDateString.convertToShorterDateFormat() ?? "") - \(endDateString.convertToShorterDateFormat() ?? "") (\(nights ?? 0) Nights)"
        view.model.guests = "\(cellAt.noOfOccupant ?? 0) Guests"
        view.model.img = cellAt.images?.first?.url ?? ""
        view.model.amenities = listing?.amenities ?? []
        if let price = cellAt.pricePerNight {
            view.model.price = "₦ \(price ?? 0)"
        }
        
        view.model.tapped = { [weak self] in
            guard let self = self else { return }
            self.selectedIndex = indexPath.item
            view.model.state = true
            self.roomsCollectionView.reloadData() // Update UI to reflect selection
            self.reserveBtnView.isHidden = false
            if let price = cellAt.pricePerNight {
                self.reserveBtn.setTitle("Reserve for ₦ \(price ?? 0)", for: .normal)
            }
        }

        // Update the state based on selection
        view.model.state = (indexPath.item == selectedIndex)
        
        cell.applyView(view: view)
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 10, height: 480)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let listing = listing, let booking = booking{
            roomId = rooms[indexPath.item].id
            coordinator?.gotoRoomDetailsView(listing: listing, booking: booking, room: rooms[indexPath.item])
        }
    }
    
    
}

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
    var listing: Listing?
    var booking: CreateBeachHouseBookingRequest?

    override func viewDidLoad() {
        super.viewDidLoad()

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

    func calculateNights(from startDateString: String, to endDateString: String, format: String = "dd/MM/yyyy") -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        guard let startDate = dateFormatter.date(from: startDateString),
              let endDate = dateFormatter.date(from: endDateString) else {
            return nil
        }
        
        guard endDate > startDate else { return nil }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        
        return components.day
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
//        view.model.amenities =
        
        let descriptions = cellAt.bedTypes?.compactMap { bedType -> String? in
            guard let name = bedType.name, let quantity = bedType.quantity else { return nil }
            return "\(quantity): \(name)"
        }
        view.model.bedType = descriptions?.joined(separator: ", ") ?? ""

        
        let startDateString = booking?.checkingDate ?? ""
        let endDateString = booking?.checkoutDate ?? ""

        let nights = calculateNights(from: startDateString, to: endDateString)
        view.model.date = "\(startDateString.convertToShortDateFormat() ?? "") - \(endDateString.convertToShortDateFormat() ?? "") \(nights ?? 0) Nights"
        view.model.guests = "\(cellAt.noOfOccupant ?? 0) Guests"
        view.model.img = cellAt.images?.first?.url ?? ""
        if let price = cellAt.pricePerNight{
            view.model.price = "₦ \(price ?? 0)"
        }
        
        
        cell.applyView(view: view)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 10, height: 400)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected")
    }
    
    
}

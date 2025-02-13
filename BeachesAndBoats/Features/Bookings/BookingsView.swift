//
//  BookingsView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 03/10/2024.
//

import UIKit

class BookingsView: BaseViewControllerPlain {

    var coordinator: BookingsCoordinator?
    
    @IBOutlet weak var upcomingBookingSegment: SegmentOptionView!
    @IBOutlet weak var pastBookingSegment: SegmentOptionView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var upcomingBeachBookings: [BeachHouseBookings]?
    var pastBeachBookings: [BeachHouseBookings]?
    var upcomingBoatBookings: [BoatBookings]?
    var pastBoatBookings: [BoatBookings]?
    
    var bookingItems: [BookingItem] = []
    
    var isDisplayingUpcoming: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Booking"
        setupCustomNavigationButton()
        setup()
    }
    
    func setup(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")

    }
    
//    func updateBookings(forUpcoming upcoming: Bool, response: YourResponseType) {
//        if upcoming {
//            let boatUpcoming = response.data.boatBookings.upcoming.map { BookingItem.boat($0) }
//            let beachUpcoming = response.data.beachHouseBookings.upcoming.map { BookingItem.beachHouse($0) }
//            bookingItems = boatUpcoming + beachUpcoming
//        } else {
//            let boatPast = response.data.boatBookings.past.map { BookingItem.boat($0) }
//            let beachPast = response.data.beachHouseBookings.past.map { BookingItem.beachHouse($0) }
//            bookingItems = boatPast + beachPast
//        }
//        collectionView.reloadData()
//    }


}

extension BookingsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch isDisplayingUpcoming {
        case true:
            let totalCount = (upcomingBoatBookings?.count ?? 0) + (upcomingBeachBookings?.count ?? 0)
            return totalCount
        case false:
            let totalCount = (pastBoatBookings?.count ?? 0) + (pastBeachBookings?.count ?? 0)
            return totalCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
        
        
        let view = BookingCell(frame: cell.bounds)

        
        cell.applyView(view: view)
        
        return cell
    }
    
    
}

extension BookingsView{
    func setupCustomNavigationButton() {
        let customButtonRight = UIButton(type: .custom)
        customButtonRight.setImage(Assets.sortIcon.image, for: .normal)
//        customButtonRight.addTarget(self, action: #selector(addNewBtnTapped), for: .touchUpInside)
        let customRightBarButtonItem = UIBarButtonItem(customView: customButtonRight)
        navigationItem.rightBarButtonItem = customRightBarButtonItem
        
        let customButtonLeft = UIButton(type: .custom)
        customButtonLeft.setImage(Assets.filterIcon2.image, for: .normal)
//        customButtonLeft.addTarget(self, action: #selector(addNewBtnTapped), for: .touchUpInside)
        let customLeftBarButtonItem = UIBarButtonItem(customView: customButtonLeft)
        navigationItem.leftBarButtonItem = customLeftBarButtonItem
    }
}


enum BookingItem{
    case boat(BoatBookingsPast)
    case beachHouse(BeachHouseBookingsPast)
    
    var id: String{
        switch self {
        case .boat(let booking):
            return booking.boat.id ?? ""
        case .beachHouse(let booking):
            return booking.id
        }
    }
    
    var name: String{
        switch self {
        case .boat(let booking):
            return booking.boat.name ?? ""
        case .beachHouse(let booking):
            return booking.beachHouse?.name ?? ""
        }
    }
    
    var date: String{
        switch self {
        case .boat(let booking):
            return booking.bookingDate
        case .beachHouse(let booking):
            return "\(booking.checkingDate?.convertToShorterDateFormat() ?? "") - \(booking.checkoutDate?.convertToShorterDateFormat() ?? "")"
        }
    }
    
    var location: String{
        switch self {
        case .boat(let booking):
            return "\(booking.boat.locations?.city ?? ""), \(booking.boat.locations?.state ?? "") \(booking.boat.locations?.country ?? "")"
        case .beachHouse(let booking):
            return "\(booking.beachHouse?.locations.city ?? ""), \(booking.beachHouse?.locations.state ?? "") \(booking.beachHouse?.locations.country ?? "")"
        }
    }
}

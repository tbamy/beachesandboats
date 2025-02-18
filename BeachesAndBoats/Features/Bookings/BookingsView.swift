//
//  BookingsView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 03/10/2024.
//

import UIKit
import RxSwift

class BookingsView: BaseViewControllerPlain {

    var coordinator: BookingsCoordinator?
    
    @IBOutlet weak var upcomingBookingSegment: SegmentOptionView!
    @IBOutlet weak var pastBookingSegment: SegmentOptionView!
    @IBOutlet weak var upcomingCollectionView: UICollectionView!
    @IBOutlet weak var pastCollectionView: UICollectionView!
    
    let vm = BookingsVM()
    let disposeBag = DisposeBag()
    let input = PublishSubject<BookingsVM.Input>()
    
    var bookingItems: [BookingItem] = []
    var responseData: GetUserBookingsResponse?
    
    var isDisplayingUpcoming: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Booking"
        setupCustomNavigationButton()
        setup()
    }
    
    func setup(){
        upcomingBookingSegment.isSelected = true
        upcomingCollectionView.delegate = self
        upcomingCollectionView.dataSource = self
        upcomingCollectionView.backgroundColor = .clear
        upcomingCollectionView.tag = 0
        upcomingCollectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        
        pastCollectionView.delegate = self
        pastCollectionView.dataSource = self
        pastCollectionView.backgroundColor = .clear
        pastCollectionView.tag = 1
        pastCollectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")

    }
    
    func setupSegmentControl(){
//        upcomingBookingSegment.isSelected =
    }
    
    func updateBookings(forUpcoming upcoming: Bool, response: GetUserBookingsResponse) {
        if upcoming {
            if let upcomingBoatBookings = response.data?.boatBookings?.upcoming, let upcomingBeachBookings = response.data?.beachHouseBookings?.upcoming{
                let boatUpcoming = upcomingBoatBookings.map{ BookingItem.boat($0)}
                let beachUpcoming = upcomingBeachBookings.map { BookingItem.beachHouse($0) }
                
                bookingItems = boatUpcoming + beachUpcoming
            }
        } else {
            if let pastBoatBookings = response.data?.boatBookings?.past, let pastBeachBookings = response.data?.beachHouseBookings?.past{
                let boatPast = pastBoatBookings.map{ BookingItem.boat($0)}
                let beachPast = pastBeachBookings.map { BookingItem.beachHouse($0) }
                
                bookingItems = boatPast + beachPast
            }
        }
        upcomingCollectionView.reloadData()
    }
    
    
    func bind(){
        vm.transform(input: input)

        vm.output.subscribe(onNext: {[weak self] event in
            guard let self = self else { return }
            LoadingModal.dismiss()
            switch event {
            case .getUserBookingsSuccess(let response):
                self.responseData = response
            case .getUserBookingsFailed(let error):
                <#code#>
            }
        }).disposed(by: disposeBag)
    }

}

extension BookingsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookingItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = upcomingCollectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
        
        let item = bookingItems[indexPath.item]
        let view = BookingCell(frame: cell.bounds)
        
        view.model.image = item.image
        view.model.location = item.location
        view.model.title = item.name
        view.model.date = item.date
        
        cell.applyView(view: view)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = bookingItems[indexPath.item]
        switch item {
        case .boat(let boatBooking):
            // Navigate to boat booking details
            coordinator?.gotoBoatBookingDetails(booking: boatBooking)
        case .beachHouse(let beachBooking):
            // Navigate to beach house booking details
            coordinator?.gotoBeachHouseBookingDetails(booking: beachBooking)
        }
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
    
    var image: String{
        switch self {
        case .boat(let booking):
            return booking.boat.images?.first?.url ?? ""
        case .beachHouse(let booking):
            return booking.beachHouse?.image ?? ""
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

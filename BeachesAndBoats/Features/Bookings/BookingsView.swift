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
    @IBOutlet weak var emptyBooking: UIView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    let vm = BookingsVM()
    let disposeBag = DisposeBag()
    let input = PublishSubject<BookingsVM.Input>()
    
    var bookingItems: [BookingItem] = []
    var responseData: UserBookingsData?
    
    var isDisplayingUpcoming: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Booking"
        setupCustomNavigationButton()
        setup()
        
        bind()
//        input.onNext(.getUserBookings)
        LoadingModal.show()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        input.onNext(.getUserBookings)
//        LoadingModal.show()
    }
    
    func setup(){
        emptyBooking.isHidden = true
        upcomingCollectionView.delegate = self
        upcomingCollectionView.dataSource = self
        upcomingCollectionView.backgroundColor = .clear
        upcomingCollectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        

        setupSegmentControl()
    }
    
    func updateInitialUpcoming(){
        upcomingBookingSegment.isSelected = true
        isDisplayingUpcoming = true
        upcomingBookingSegment.isSelected = true
        pastBookingSegment.isSelected = false
        
        if let responseData = responseData{
            emptyBooking.isHidden = true
            updateBookings(forUpcoming: true, response: responseData)
        }
    }
    
    func setupSegmentControl(){
        upcomingBookingSegment.onSelect = { [weak self] in
            self?.isDisplayingUpcoming = true
            self?.upcomingBookingSegment.isSelected = true
            self?.pastBookingSegment.isSelected = false
            
            if let responseData = self?.responseData{
                self?.emptyBooking.isHidden = true
                self?.updateBookings(forUpcoming: true, response: responseData)
            }
        }
        
        pastBookingSegment.onSelect = { [weak self] in
            self?.isDisplayingUpcoming = false
            self?.upcomingBookingSegment.isSelected = false
            self?.pastBookingSegment.isSelected = true
            
            if let responseData = self?.responseData{
                self?.emptyBooking.isHidden = true
                self?.updateBookings(forUpcoming: false, response: responseData)
            }
        }
    }
    
    func updateBookings(forUpcoming upcoming: Bool, response: UserBookingsData) {
        if upcoming {
            let hasUpcomingBoatBookings = response.boatBookings?.upcoming != nil && !(response.boatBookings?.upcoming?.isEmpty ?? true)
            let hasUpcomingBeachBookings = response.beachHouseBookings?.upcoming != nil && !(response.beachHouseBookings?.upcoming?.isEmpty ?? true)
            
            if hasUpcomingBoatBookings || hasUpcomingBeachBookings {
                var bookingsArray = [BookingItem]()
                
                if hasUpcomingBoatBookings, let upcomingBoatBookings = response.boatBookings?.upcoming {
                    let boatUpcoming = upcomingBoatBookings.map{ BookingItem.boat($0) }
                    bookingsArray.append(contentsOf: boatUpcoming)
                }
                
                if hasUpcomingBeachBookings, let upcomingBeachBookings = response.beachHouseBookings?.upcoming {
                    let beachUpcoming = upcomingBeachBookings.map{ BookingItem.beachHouse($0) }
                    bookingsArray.append(contentsOf: beachUpcoming)
                }
                
                bookingItems = bookingsArray
                emptyBooking.isHidden = true
                upcomingCollectionView.isHidden = false
            } else {
                emptyBooking.isHidden = false
                upcomingCollectionView.isHidden = true
            }
        } else {
            let hasPastBoatBookings = response.boatBookings?.past != nil && !(response.boatBookings?.past?.isEmpty ?? true)
            let hasPastBeachBookings = response.beachHouseBookings?.past != nil && !(response.beachHouseBookings?.past?.isEmpty ?? true)
            
            if hasPastBoatBookings || hasPastBeachBookings {
                var bookingsArray = [BookingItem]()
                
                if hasPastBoatBookings, let pastBoatBookings = response.boatBookings?.past {
                    let boatPast = pastBoatBookings.map{ BookingItem.boat($0) }
                    bookingsArray.append(contentsOf: boatPast)
                }
                
                if hasPastBeachBookings, let pastBeachBookings = response.beachHouseBookings?.past {
                    let beachPast = pastBeachBookings.map{ BookingItem.beachHouse($0) }
                    bookingsArray.append(contentsOf: beachPast)
                }
                
                bookingItems = bookingsArray
                emptyBooking.isHidden = true
                upcomingCollectionView.isHidden = false
            } else {
                emptyBooking.isHidden = false
                upcomingCollectionView.isHidden = true
            }
        }
        
        upcomingCollectionView.reloadData()
        updateCollectionViewHeight(upcomingCollectionView, collectionViewHeightConstraint)
    }
    
//    func updateBookings(forUpcoming upcoming: Bool, response: UserBookingsData) {
//        if upcoming {
//            if let upcomingBoatBookings = response.boatBookings?.upcoming, !upcomingBoatBookings.isEmpty, let upcomingBeachBookings = response.beachHouseBookings?.upcoming, !upcomingBeachBookings.isEmpty{
//                let boatUpcoming = upcomingBoatBookings.map{ BookingItem.boat($0)}
//                let beachUpcoming = upcomingBeachBookings.map { BookingItem.beachHouse($0) }
//                
//                bookingItems = boatUpcoming + beachUpcoming
//            }else{
//                emptyBooking.isHidden = false
//                upcomingCollectionView.isHidden = true
//            }
//        } else {
//            if let pastBoatBookings = response.boatBookings?.past, !pastBoatBookings.isEmpty, let pastBeachBookings = response.beachHouseBookings?.past, !pastBeachBookings.isEmpty{
//                let boatPast = pastBoatBookings.map{ BookingItem.boat($0)}
//                let beachPast = pastBeachBookings.map { BookingItem.beachHouse($0) }
//                
//                bookingItems = boatPast + beachPast
//            }else{
//                emptyBooking.isHidden = false
//                upcomingCollectionView.isHidden = true
//            }
//        }
//        upcomingCollectionView.reloadData()
//        updateCollectionViewHeight(upcomingCollectionView, collectionViewHeightConstraint)
//    }
    
    func updateCollectionViewHeight(_ collectionView: UICollectionView, _ collectionViewHeightConstraint: NSLayoutConstraint) {
        collectionView.layoutIfNeeded()
        let contentHeight = collectionView.contentSize.height
        collectionViewHeightConstraint.constant = contentHeight
        
        self.view.layoutIfNeeded()
    }
    
    
    func bind(){
        vm.transform(input: input)

        vm.output.subscribe(onNext: {[weak self] event in
            guard let self = self else { return }
            LoadingModal.dismiss()
            switch event {
            case .getUserBookingsSuccess(let response):
                self.responseData = response.data
                self.updateInitialUpcoming()
                
            case .getUserBookingsFailed(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width - 10, height: 94)
       
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
            return "\(booking.beachHouse?.locations?.city ?? ""), \(booking.beachHouse?.locations?.state ?? "") \(booking.beachHouse?.locations?.country ?? "")"
        }
    }
}

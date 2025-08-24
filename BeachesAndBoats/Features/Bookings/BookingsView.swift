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
    var filteredBookingItems: [BookingItem] = []
    var sortedBookingItems: [BookingItem] = []
    
    var responseData: UserBookingsData?
    
    var isDisplayingUpcoming: Bool = true
    private var currentModalHeight: CGFloat = UIScreen.main.bounds.height * 0.5

    
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
        upcomingBookingSegment.isNotSelected = true
        isDisplayingUpcoming = true
        upcomingBookingSegment.isNotSelected = true
        pastBookingSegment.isNotSelected = false
        
        if let responseData = responseData{
            emptyBooking.isHidden = true
            updateBookings(forUpcoming: true, response: responseData)
        }
    }
    
    func setupSegmentControl(){
        upcomingBookingSegment.onSelect = { [weak self] in
            self?.isDisplayingUpcoming = true
            self?.upcomingBookingSegment.isNotSelected = true
            self?.pastBookingSegment.isNotSelected = false
            
            if let responseData = self?.responseData{
                self?.emptyBooking.isHidden = true
                self?.updateBookings(forUpcoming: true, response: responseData)
            }
        }
        
        pastBookingSegment.onSelect = { [weak self] in
            self?.isDisplayingUpcoming = false
            self?.upcomingBookingSegment.isNotSelected = false
            self?.pastBookingSegment.isNotSelected = true
            
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
    
    @objc func sortIconTapped() {
        let sortModal = HostListingSortView()
        sortModal.modalPresentationStyle = .custom
        sortModal.transitioningDelegate = self
        sortModal.isFromBooking = true
        sortModal.sortDelegate = self
        currentModalHeight = UIScreen.main.bounds.height * 0.90
        present(sortModal, animated: true)
    }
    
    @objc func filterIconTapped() {
        let filterModal = FilterView()
        filterModal.modalPresentationStyle = .custom
        filterModal.transitioningDelegate = self
        filterModal.filterDelegate = self
        currentModalHeight = UIScreen.main.bounds.height * 0.50
        present(filterModal, animated: true, completion: nil)
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
        //        return bookingItems.count
        let count = filteredBookingItems.isEmpty ? bookingItems.count : filteredBookingItems.count
        print("Collection view showing \(count) items")
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = upcomingCollectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
        
        //        let item = bookingItems[indexPath.item]
        let item = filteredBookingItems.isEmpty ? bookingItems[indexPath.item] : filteredBookingItems[indexPath.item]
        let view = BookingCell(frame: cell.bounds)
        
        view.model.image = item.image
        view.model.location = item.location
        view.model.title = item.name
        view.model.date = item.date
        
        cell.applyView(view: view)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let item = bookingItems[indexPath.item]
        let item = filteredBookingItems.isEmpty ? bookingItems[indexPath.item] : filteredBookingItems[indexPath.item]
        switch item {
        case .boat(let boatBooking):
            // Navigate to boat booking details
            coordinator?.gotoBoatBookingDetails(booking: boatBooking, upcomingBookings: isDisplayingUpcoming)
        case .beachHouse(let beachBooking):
            // Navigate to beach house booking details
            coordinator?.gotoBeachHouseBookingDetails(booking: beachBooking, upcomingBookings: isDisplayingUpcoming)
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
        customButtonRight.addTarget(self, action: #selector(sortIconTapped), for: .touchUpInside)
        let customRightBarButtonItem = UIBarButtonItem(customView: customButtonRight)
        navigationItem.rightBarButtonItem = customRightBarButtonItem
        
        let customButtonLeft = UIButton(type: .custom)
        customButtonLeft.setImage(Assets.filterIcon2.image, for: .normal)
        customButtonLeft.addTarget(self, action: #selector(filterIconTapped), for: .touchUpInside)
        let customLeftBarButtonItem = UIBarButtonItem(customView: customButtonLeft)
        navigationItem.leftBarButtonItem = customLeftBarButtonItem
    }
}

extension BookingsView: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController,
                              presenting: UIViewController?,
                              source: UIViewController) -> UIPresentationController? {
        return CustomBottomSheetPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            height: currentModalHeight)
    }
}

extension BookingsView: FilterDelegate, SortDelegate {
    func getSelectedOption(selectedOption: String) {
        //This takes care of the sorting
    }
    
    func getSelectedItem(selectedItem: String) {
        
        print("Filter selected: \(selectedItem)")
        print("Before filtering: \(bookingItems.count) items")
        switch selectedItem {
        case "BeachHouse":
            filteredBookingItems = bookingItems.filter { bookingType in
                if case .beachHouse = bookingType {
                    return true
                }
                return false
            }
        case "Boat":
            filteredBookingItems = bookingItems.filter {bookingType in
                if case .boat = bookingType {
                    return true
                }
                return false
            }
        case "All":
            // Reset filter
            filteredBookingItems = []
        default:
            filteredBookingItems = []
        }
        print("After filtering: \(filteredBookingItems.count) items")
        
        if filteredBookingItems.isEmpty && selectedItem != "All" {
                // If we filtered and got no results
                emptyBooking.isHidden = false
                upcomingCollectionView.isHidden = true
            } else if bookingItems.isEmpty {
                // If there are no items at all
                emptyBooking.isHidden = false
                upcomingCollectionView.isHidden = true
            } else {
                // We have items to show
                emptyBooking.isHidden = true
                upcomingCollectionView.isHidden = false
            }
        
        // Ensure UI updates on main thread
        DispatchQueue.main.async {
            self.upcomingCollectionView.reloadData()
            self.updateCollectionViewHeight(self.upcomingCollectionView, self.collectionViewHeightConstraint)
        }
    }
    
    
}

enum BookingItem{
    case boat(BoatBookingsPast)
    case beachHouse(BeachHouseBookingsPast)
    
    var id: String{
        switch self {
        case .boat(let booking):
            return booking.bookingId
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

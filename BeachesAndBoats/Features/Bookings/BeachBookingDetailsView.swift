//
//  BeachBookingDetailsView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 13/02/2025.
//

import UIKit
import MapKit
import Kingfisher
import RxSwift

class BeachBookingDetailsView: BaseViewControllerPlain {
    
    var coordinator: BookingsCoordinator?
    var booking: BeachHouseBookingsPast?
    
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var roomAndGuestsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var checkinDateLabel: HorizonDateField!
    @IBOutlet weak var checkoutDateLabel: HorizonDateField!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var guestCommentsCollectionView: UICollectionView!
    @IBOutlet weak var locationView: MKMapView!
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var aboutHostLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var continueBookingView: UIView!
    @IBOutlet weak var selectedRoomImage: UIImageView!
    @IBOutlet weak var selectedRoomTitleLabel: UILabel!
    @IBOutlet weak var selectedRoomLocationLabel: UILabel!
    @IBOutlet weak var selectedRoomDateLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var costAmountLabel: UILabel!
    @IBOutlet weak var cleaningFeeLabel: UILabel!
    @IBOutlet weak var serviceFeeLabel: UILabel!
    @IBOutlet weak var CostTotalAmountLabel: UILabel!
    @IBOutlet weak var dayBookingBtn: CheckboxButton!
    @IBOutlet weak var nightBookingBtn: CheckboxButton!
    @IBOutlet weak var upcomingStack: UIStackView!
    @IBOutlet weak var pastBookingView: UIView!
    
    var vm = BeachBookingDetailsVM()
    var disposeBag = DisposeBag()
    
    var isDayBooking: Bool = false
    
    var beachDetails: Listing?
    var amenities: [Amenity] = []
    var roomImages: [String] = []
    var comments: [Review] = []
    var userComment: String?
    var userRating: Int?
    
    var from_when: Date?
    var to_when: Date?
    
    var backendFrom_when: Date?
    var backendTo_when: Date?
    
    var isupcomingBooking: Bool = false
    
    private var currentModalHeight: CGFloat = UIScreen.main.bounds.height * 0.5


    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        configureAllCollectionViews()
        setupCustomNavigationButtons()
        checkinDateLabel.isUserInteractionEnabled = false
        checkoutDateLabel.isUserInteractionEnabled = false
        itemToShow()
        bindNetwork()
    }
    
    func itemToShow() {
        if isupcomingBooking {
            continueBookingView.isHidden = true
            upcomingStack.isHidden = false
        } else {
            upcomingStack.isHidden = true
            continueBookingView.isHidden = false
        }
    }
    
    func setup(){
        checkinDateLabel.placeholder = "Select Date"
        checkoutDateLabel.placeholder = "Select Date"
        
//        topImage.image = UIImage(named: booking?.beachHouse?.image ?? "")
        
        if let url = URL(string: booking?.beachHouse?.image?.replacingOccurrences(of: "http://", with: "https://") ?? "") {
            topImage.kf.setImage(with: url)
        }
        
        
        backendFrom_when = beachDetails?.availabilities?.availableFrom?.convertFromBackendDateString()
        backendTo_when = beachDetails?.availabilities?.availableTo?.convertFromBackendDateString()
        
        nightBookingBtn.isChecked = true
        dayBookingBtn.stateChanged = { [weak self] isSelected in
            guard let self = self else { return }
            self.isDayBooking = isSelected
            self.nightBookingBtn.isChecked = false
        }
        
        nightBookingBtn.stateChanged = { [weak self] isSelected in
            guard let self = self else { return }
            self.isDayBooking = isSelected
            self.dayBookingBtn.isChecked = false
        }
        
//        print("Available From: \(backendFrom_when) - Available To: \(backendTo_when)")
        
        checkinDateLabel.onDateSelected = { (date) in
//            checkinDateLabel.onDateSelected = { (startDateString, endDateString) in
//            let startDate = startDateString.toBackendDate()
//            let endDate = endDateString?.toBackendDate()
            
            self.from_when = date
            
            if let backendFrom = self.backendFrom_when, let backendTo = self.backendTo_when {
                guard date >= backendFrom && date <= backendTo else {
                    MiddleModal.show(title: "Invalid Date", subtitle: "Please pick between (\(backendFrom.toFormattedDate()) and \(backendTo.toFormattedDate()))", type: .error, dismissable: true, dismissOnConfirm: true)
                    return
                }
                self.checkinDateLabel.text = "\(date.toFormattedDate())"

            } else {
                print("Backend dates are not set.")
                self.checkinDateLabel.text = "\(date.toFormattedDate())"
            }
        }

        
        checkoutDateLabel.onDateSelected = { (date) in
            
            self.to_when = date
            if let backendFrom = self.backendFrom_when, let backendTo = self.backendTo_when {
                guard date >= backendFrom && date <= backendTo else {
                    MiddleModal.show(title: "Invalid Date", subtitle: "Please pick between (\(backendFrom.toFormattedDate()) and \(backendTo.toFormattedDate()))", type: .error, dismissable: true, dismissOnConfirm: true)
                    return
                }
                
                
                self.checkoutDateLabel.text = "\(date.toFormattedDate())"
            
            } else {
                print("Backend dates are not set.")
                self.checkoutDateLabel.text = "\(date.toFormattedDate())"
            }
        }
        
        titleLabel.text = booking?.beachHouse?.name
        locationLabel.text = "\(booking?.beachHouse?.locations?.city ?? ""), \(booking?.beachHouse?.locations?.state ?? "") \(booking?.beachHouse?.locations?.country ?? "")"
        locationView.layer.cornerRadius = 8
        descriptionLabel.text = booking?.beachHouse?.description
        aboutHostLabel.text = booking?.beachHouse?.aboutOwner
//        hostNameLabel.text = "\(booking?.beachHouse?.owner?.firstName ?? "") \(booking?.beachHouse?.owner?.lastName ?? "")"
        ratingLabel.text = "\(booking?.beachHouse?.rating ?? 0)"
        totalAmountLabel.text = "₦ \(booking?.beachHouseRoom?.pricePerNight ?? 0)"
//        let totalGuests = (booking?.beachHouse?.noOfAdults ?? 0) + (booking?.beachHouse?.noOfChildren ?? 0)
        roomAndGuestsLabel.text = "\(booking?.noOfPeople ?? "0" /*0*/) guests · \(booking?.beachHouseRoom?.bedTypes.count ?? 0) bedrooms · \(booking?.beachHouseRoom?.bedTypes.first?.quantity ?? "") beds · \(booking?.beachHouseRoom?.hasPrivateBathroom ?? "0" /*0*/) private baths"    //"\(totalGuests) guests, \(booking?.beachHouse?.rooms?.count ?? 0) rooms"
        checkinDateLabel.text = booking?.checkingDate ?? ""
        checkoutDateLabel.text = booking?.checkoutDate ?? ""
        
        
        if let latitude = Double(booking?.beachHouse?.locations?.latitude ?? ""),
           let longitude = Double(booking?.beachHouse?.locations?.longitude ?? "") {
           
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let span = MKCoordinateSpan(latitudeDelta: latitude, longitudeDelta: longitude)
            let region = MKCoordinateRegion(center: center, span: span)
            
            locationView.region = region
        }
        
        
        amenities = beachDetails?.amenities ?? []
        comments = beachDetails?.reviews ?? []
        
//        topImage.isUserInteractionEnabled = true
//        topImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewImages)))
        
    }
    
//    @objc func viewImages(){
//        
//        if let rooms = beachDetails?.rooms{
//            roomImages = rooms.compactMap { $0.images }
//                .flatMap { $0 }
//                .compactMap { $0.url }
//            coordinator?.gotoAllPhotos(images: roomImages)
//        }
//        
//    }
    
    func configureAllCollectionViews() {
        configureCollectionView(categoriesCollectionView, tag: 1)
        configureCollectionView(guestCommentsCollectionView, tag: 2)
    }

    
    func configureCollectionView(_ collectionView: UICollectionView, tag: Int) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.tag = tag
        collectionView.backgroundColor = .clear
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
    }
    
    @IBAction func writeReviewTapped(_ sender: Any) {
        
        RatingModal.show(userComment: "", delegate: self)
    }
    
    @IBAction func messageHostTapped(_ sender: Any) {
    }
    
    
    
    @IBAction func cancelBookingTapped(_ sender: Any) {
        let cancelBookingView = CancelBookingView()
        cancelBookingView.modalPresentationStyle = .custom
        cancelBookingView.transitioningDelegate = self
        currentModalHeight = UIScreen.main.bounds.height * 0.75
        cancelBookingView.transitioningDelegate = self

        present(cancelBookingView, animated: true, completion: nil)
    }
    

    @IBAction func continueBookingTapped(_ sender: Any) {
        print("Continue Tapped")
        
        let houseRules = HouseAndGroundRulesView()
        houseRules.modalPresentationStyle = .custom
        houseRules.transitioningDelegate = self
        currentModalHeight = UIScreen.main.bounds.height * 0.35

        present(houseRules, animated: true, completion: nil)
//        let bookingType = isDayBooking ? "DAY" : "NIGHT"
//
//        if let fromWhen = from_when, let toWhen = to_when{
//            if let beachDetails = beachDetails{
//                let beachBookingRequest = CreateBeachHouseBookingRequest(userId: "", beachHouseRoomId: "", checkingDate: from_when?.toBackendDate() ?? "", checkoutDate: to_when?.toBackendDate() ?? "", checkingTime: "", checkoutTime: "", numberOfPeople: 0, amount: 0, units: 0, bookingType: bookingType)
//                print(beachBookingRequest)
//                
//                coordinator?.gotoBookingRoomsListView(listing: beachDetails, booking: beachBookingRequest)
//            }
//        }else{
//            MiddleModal.show(title: "Invalid Date", subtitle: "Please pick checkout and checkin dates", type: .error, dismissable: true, dismissOnConfirm: true)
//        }
        
    }
    
}

extension BeachBookingDetailsView: SumbitBtnDelegate {
    
    func submitTapped(rating: Int, comment: String?) {
        print("The rating is \(rating)")
        print("The comment is \(comment ?? "")")
        
        userComment = comment
        userRating = rating

        LoadingModal.show(title: "Submitting review...")
        let request = AddReviewRequest(itemId: booking?.beachHouse?.id ?? "", type: "BeachHouse", note: comment ?? "", rating: rating)
        vm.saveReview(request)
       
    }
    
    
}

extension BeachBookingDetailsView {
    func bindNetwork(){
        vm.output.subscribe(onNext: { [weak self] response in
            LoadingModal.dismiss()
            
            switch response {
            case .addReviewSuccess(let response):
                MiddleModal.show(title: "Success", subtitle: response.message ?? "Review submitted", type: .success, primaryText: "Okay", dismissable: false, dismissOnConfirm: true, onConfirm: {
                    self?.dismiss(animated: true)
                })
            case .addReviewFailure(let error):
                MiddleModal.show(title: "Error", subtitle: error.message ?? "Something went wrong",  type: .error, primaryText: "Okay", dismissable: false, dismissOnConfirm: true, onConfirm: {
                    self?.dismiss(animated: true)
                })
            }
            
            
        }).disposed(by: disposeBag)
    }
}

extension BeachBookingDetailsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            return amenities.count
        case 1:
            return comments.count
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView.tag {
        case 0:
            let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
            let cellAt = amenities[indexPath.item]
            
            let view = CategoriesCell(frame: cell.bounds)
            view.identifier = "Amenitiess " + indexPath.description
            view.model.image = cellAt.icon ?? ""
            view.model.title = cellAt.name ?? ""
            view.isSubcategory = true
            
            cell.applyView(view: view)
            return cell
            
        case 1:
            let cell = guestCommentsCollectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
            let cellAt = comments[indexPath.item]
            
            let view = CommentsViewCell(frame: cell.bounds)
            view.identifier = "GuestComments " + indexPath.description
            view.model.name = cellAt.user?.firstName ?? ""
            view.model.rating = cellAt.rating ?? ""
            view.model.comment = cellAt.note ?? ""
            
            cell.applyView(view: view)
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
        case 0:
            return CGSize(width: (collectionView.bounds.width / 6), height: 50)
        case 1:
            return CGSize(width: (collectionView.bounds.width) - 20, height: 150)
        default:
            return CGSize()
        }
    }
    
    
}

extension BeachBookingDetailsView: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController,
                              presenting: UIViewController?,
                              source: UIViewController) -> UIPresentationController? {
        return CustomBottomSheetPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            height: currentModalHeight)
    }
}


extension BeachBookingDetailsView {
    func setupCustomNavigationButtons() {
        
        let addButton = UIButton(type: .custom)
        addButton.setImage(Assets.favoriteTwo.image, for: .normal)
        addButton.addTarget(self, action: #selector(addNewBtnTapped), for: .touchUpInside)
        let addBarButtonItem = UIBarButtonItem(customView: addButton)

        let settingsButton = UIButton(type: .custom)
        settingsButton.setImage(Assets.shareTwo.image, for: .normal)
        settingsButton.addTarget(self, action: #selector(settingsBtnTapped), for: .touchUpInside)
        let settingsBarButtonItem = UIBarButtonItem(customView: settingsButton)

        navigationItem.rightBarButtonItems = [addBarButtonItem, settingsBarButtonItem]
    }

    // Actions for the buttons
    @objc func addNewBtnTapped() {
        print("Add button tapped")
    }

    @objc func settingsBtnTapped() {
        print("Settings button tapped")
    }


}


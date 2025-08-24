//
//  BeachBookingDetailsView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 13/02/2025.
//

import UIKit
import MapKit
import SDWebImage
import SDWebImageSVGCoder
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
    @IBOutlet weak var selectedRoomGuestLabel: UILabel!
    @IBOutlet weak var selectedRoomBedLabel: UILabel!
    @IBOutlet weak var selectedRoomCostLabel: UILabel!
    @IBOutlet weak var selectedRoomDateLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var costAmountLabel: UILabel!
    @IBOutlet weak var cleaningFeeLabel: UILabel!
    @IBOutlet weak var serviceFeeLabel: UILabel!
    @IBOutlet weak var CostTotalAmountLabel: UILabel!
//    @IBOutlet weak var dayBookingBtn: CheckboxButton!
//    @IBOutlet weak var nightBookingBtn: CheckboxButton!
    @IBOutlet weak var upcomingStack: UIStackView!
    
    
    @IBOutlet weak var reviewBtn: PlainOutlineButton!
    @IBOutlet weak var tripStack: UIStackView!
    @IBOutlet weak var commentsStack: UIStackView!
    @IBOutlet weak var roomStack: UIStackView!
    
    var vm = BeachBookingDetailsVM()
    let chatVm = StartConversationVM()
    let chatInput = PublishSubject<StartConversationVM.Input>()
    var disposeBag = DisposeBag()
    
    var isDayBooking: Bool = false
    
//    var beachDetails: GetBeachData?
    var amenities: [Amenity] = []
    var roomImages: [String] = []
    var comments: [Review] = []
    var userComment: String?
    var userRating: Int?
    
    var from_when: Date?
    var to_when: Date?
    
//    var backendFrom_when: Date?
//    var backendTo_when: Date?
    
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
//        tripStack.isHidden = true
    }
    
    func itemToShow() {
        if isupcomingBooking {
            continueBookingView.isHidden = true
            upcomingStack.isHidden = false
            reviewBtn.isHidden = true
        } else {
            upcomingStack.isHidden = true
            continueBookingView.isHidden = false
            reviewBtn.isHidden = false
        }
    }
    
    func setup(){
        
        if let url = URL(string: booking?.beachHouse?.image?.replacingOccurrences(of: "http://", with: "https://") ?? "") {
//            topImage.kf.setImage(with: url)
            topImage.sd_setImage(with: url, placeholderImage: UIImage(named: "dummy"))
        }
        
        let roomDetails = booking?.beachHouseRoom
        
        if let roomImage = URL(string: roomDetails?.images.first?.url?.replacingOccurrences(of: "http://", with: "https://") ?? "") {
//            selectedRoomImage.kf.setImage(with: roomImage)
            selectedRoomImage.sd_setImage(with: roomImage, placeholderImage: UIImage(named: "dummy"))
        }
        selectedRoomTitleLabel.text = roomDetails?.name
        selectedRoomGuestLabel.text = roomDetails?.noOfOccupant
        selectedRoomDateLabel.text = formatDateRange(from: booking?.checkingDate,
                                                     to: booking?.checkoutDate)

        selectedRoomBedLabel.text = "\(roomDetails?.bedTypes.first?.quantity ?? "") \(roomDetails?.bedTypes.first?.name ?? "")"
        selectedRoomCostLabel.text = "₦ \(roomDetails?.pricePerNight ?? 0)"

        
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
        
        costAmountLabel.text = "\(booking?.checkingDate ?? "") - \(booking?.checkoutDate ?? "")"
        CostTotalAmountLabel.text = "₦ \(booking?.total ?? 0)"
        
        
        if let latitude = Double(booking?.beachHouse?.locations?.latitude ?? ""),
           let longitude = Double(booking?.beachHouse?.locations?.longitude ?? "") {
            
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            // Use a fixed zoom level (span) — tweak for desired zoom
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            
            let region = MKCoordinateRegion(center: center, span: span)
            locationView.setRegion(region, animated: true)
        }
        
//        amenities = booking?.beachHouse.amenities ?? []
//        comments = booking?.reviews ?? []
        
//        topImage.isUserInteractionEnabled = true
//        topImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewImages)))
        
    }
    
    @objc func viewImages(){
        
        if let roomImages = booking?.beachHouseRoom?.images{
            let images = roomImages.compactMap { $0.url }
            coordinator?.gotoAllPhotos(images: images)
        }
        
    }
    
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
        
        RatingModal.show(on: self.view, userComment: "", delegate: self)
    }
    
    @IBAction func messageHostTapped(_ sender: Any) {
        let personId = booking?.hostID ?? ""
        let conversationRequest = StartConversationRequest(personId: personId, bookingId: booking?.id, propertyType: "BeachHouse")
        print(conversationRequest)
            chatInput.onNext(.startConversation(conversationRequest))
            LoadingModal.show()
    }
    
    
    
    @IBAction func cancelBookingTapped(_ sender: Any) {
        let cancelBookingView = CancelBookingView()
        cancelBookingView.bookingId = booking?.id ?? ""
        cancelBookingView.bookingType = "Boat"
        cancelBookingView.modalPresentationStyle = .custom
        cancelBookingView.transitioningDelegate = self
        currentModalHeight = UIScreen.main.bounds.height * 0.75
        cancelBookingView.transitioningDelegate = self

        present(cancelBookingView, animated: true, completion: nil)
    }
    

    @IBAction func continueBookingTapped(_ sender: Any) {
        print("Continue Tapped")
        
        coordinator?.gotoBeachDetails(id: booking?.beachHouse?.id ?? "")
        
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
        chatVm.transform(input: chatInput)
        
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
        
        chatVm.output.subscribe(onNext: { [weak self] data in
            LoadingModal.dismiss()
            switch data {
            case .startConversationSuccess(let response):
                if let res = response.data{
                    self?.coordinator?.gotoChat(bookingId: "", otherUser: "", conversationId: res.id, propertyType: "BeachHouse")
//                    self?.coordinator?.gotoChat(otherUser: "", conversationId: res.id)
                }
            case .startConversationFailed(let error) :
                MiddleModal.show(title: error.message ?? "", type: .error)
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
            view.model.title = cellAt.name
            view.isSubcategory = true
            
            cell.applyView(view: view)
            return cell
            
        case 1:
            let cell = guestCommentsCollectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
            let cellAt = comments[indexPath.item]
            
            let view = CommentsViewCell(frame: cell.bounds)
            view.identifier = "GuestComments " + indexPath.description
            view.model.name = cellAt.user?.firstName ?? ""
            view.model.rating = "\(cellAt.rating)"
            view.model.comment = cellAt.note
            
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
    func formatDateRange(from: String?, to: String?) -> String {
        let fromDate = from?.convertToShorterDateFormat() ?? ""
        let toDate = to?.convertToShorterDateFormat() ?? ""
        return "\(fromDate) - \(toDate)"
    }
    
    func setupCustomNavigationButtons() {
        
        let addButton = UIButton(type: .custom)
        addButton.setImage(Assets.favoriteTwo.image, for: .normal)
        addButton.addTarget(self, action: #selector(viewImages), for: .touchUpInside)
        let addBarButtonItem = UIBarButtonItem(customView: addButton)

        let settingsButton = UIButton(type: .custom)
        settingsButton.setImage(Assets.shareTwo.image, for: .normal)
        settingsButton.addTarget(self, action: #selector(viewImages), for: .touchUpInside)
        let settingsBarButtonItem = UIBarButtonItem(customView: settingsButton)

        navigationItem.rightBarButtonItems = [settingsBarButtonItem]
    }

    // Actions for the buttons
    @objc func addNewBtnTapped() {
        print("Add button tapped")
    }

    @objc func settingsBtnTapped() {
        print("Settings button tapped")
    }


}


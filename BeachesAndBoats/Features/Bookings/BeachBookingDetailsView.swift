//
//  BeachBookingDetailsView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 13/02/2025.
//

import UIKit
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
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var aboutHostLabel: UILabel!
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
    @IBOutlet weak var upcomingStack: UIStackView!
    @IBOutlet weak var reviewBtn: SecondaryButton!
    @IBOutlet weak var tripStack: UIStackView!
    @IBOutlet weak var commentsStack: UIStackView!
    @IBOutlet weak var roomStack: UIStackView!
    
    @IBOutlet weak var selectedRoomView: UIView!
    @IBOutlet weak var bookingTypeLabel: UILabel!
    
    var vm = BeachBookingDetailsVM()
    let chatVm = StartConversationVM()
    let chatInput = PublishSubject<StartConversationVM.Input>()
    var disposeBag = DisposeBag()
    
    private let beachVM = BeachHouseVM()
    private let beachInput = PublishSubject<BeachHouseVM.Input>()
    
    var beachDetails: GetBeachData?
    var amenities: [Amenity] = []
    var roomImages: [String] = []
    var comments: [Review] = []
    var userComment: String?
    var userRating: Int?
    var from_when: Date?
    var to_when: Date?
    var isupcomingBooking: Bool = false
    private var currentModalHeight: CGFloat = UIScreen.main.bounds.height * 0.5
    var isDayBooking: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupCustomNavigationButtons()
        checkinDateLabel.isUserInteractionEnabled = false
        checkoutDateLabel.isUserInteractionEnabled = false
        itemToShow()
        bindNetwork()
        configureAllCollectionViews()
        LoadingModal.show()
        beachInput.onNext(.getBeachHouse(id: booking?.beachHouse?.id ?? ""))
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
    
    func setup() {
        isDayBooking = booking?.bookingType == "DAY"
        if let url = URL(string: booking?.beachHouse?.image?.replacingOccurrences(of: "http://", with: "https://") ?? "") {
            topImage.sd_setImage(with: url, placeholderImage: UIImage(named: "dummy"))
        }
        let roomDetails = booking?.beachHouseRoom
        selectedRoomView.isHidden = roomDetails == nil
        let price = isDayBooking ? booking?.beachHouseRoom?.pricePerDay ?? 0 : booking?.beachHouseRoom?.pricePerNight ?? 0
        let priceAndUnit = price * (Float(booking?.units ?? "1") ?? 1)
        let totalPrice = priceAndUnit * (Float(booking?.noOfNights ?? 1))
        
        if let roomImage = URL(string: roomDetails?.images.first?.url?.replacingOccurrences(of: "http://", with: "https://") ?? "") {
            selectedRoomImage.sd_setImage(with: roomImage, placeholderImage: UIImage(named: "dummy"))
        }
        
        switch booking?.bookingType {
        case "ANY":
            bookingTypeLabel.text = "Entire house or a private room"
        case "SINGLE":
            bookingTypeLabel.text = "Private room in a beach house"
        case "FULL":
            bookingTypeLabel.text = "Entire beach house"
        default:
            bookingTypeLabel.text = "Entire house or a private room"
        }
        
        selectedRoomTitleLabel.text = roomDetails?.name
        selectedRoomGuestLabel.text = "\(roomDetails?.noOfOccupant ?? "1") Guest(s)"
        selectedRoomDateLabel.text = formatDateRange(from: booking?.checkingDate, to: booking?.checkoutDate)
        selectedRoomBedLabel.text = "\(roomDetails?.bedTypes.first?.quantity ?? "") \(roomDetails?.bedTypes.first?.name ?? "")"
        selectedRoomCostLabel.text = isDayBooking ? "₦ \(roomDetails?.pricePerDay ?? 0)" : "₦ \(roomDetails?.pricePerNight ?? 0)"
        
        titleLabel.text = booking?.beachHouse?.name
        locationLabel.text = "\(booking?.beachHouse?.locations?.jettyLocation ?? ""), \(booking?.beachHouse?.locations?.name ?? "")"
        descriptionLabel.text = booking?.beachHouse?.description
        aboutHostLabel.text = booking?.beachHouse?.aboutOwner
        hostNameLabel.text = "\(booking?.hostFirstName ?? "") \(booking?.hostLastName ?? "")"
        ratingLabel.text = "\(booking?.beachHouse?.rating ?? 0)"
        roomAndGuestsLabel.text = "\(booking?.noOfPeople ?? "0") guest(s) · \(booking?.beachHouseRoom?.bedTypes.count ?? 0) bedroom(s) · \(booking?.beachHouseRoom?.bedTypes.first?.quantity ?? "") bed(s) · \(booking?.beachHouseRoom?.hasPrivateBathroom ?? "0") private bath(s)"
        checkinDateLabel.text = booking?.checkingDate ?? ""
        checkoutDateLabel.text = booking?.checkoutDate ?? ""
        costLabel.text = isDayBooking ? "₦ \(priceAndUnit) (Day booking)" : "₦ \(priceAndUnit) X \(booking?.noOfNights ?? 1) night(s)"
        costAmountLabel.text = isDayBooking ? "₦ \(priceAndUnit)" : "₦ \(totalPrice)"
        serviceFeeLabel.text = "₦ \(booking?.adminCharge ?? 0)"
        CostTotalAmountLabel.text = "₦ \(booking?.total ?? 0)"
        
        // Initial setup with empty data (will be updated in bindNetwork)
        amenities = beachDetails?.amenities ?? []
        comments = beachDetails?.reviews ?? []
        commentsStack.isHidden = comments.count < 1
        
        topImage.isUserInteractionEnabled = true
        topImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewImages)))
    }
    
    @objc func viewImages() {
        if let rooms = beachDetails?.rooms {
            roomImages = rooms.compactMap { $0.images }
                .flatMap { $0 }
                .compactMap { $0.url }
            coordinator?.gotoAllPhotos(images: roomImages)
        }
    }
    
    func configureAllCollectionViews() {
        configureCollectionView(categoriesCollectionView, tag: 0) // Tag 0 for amenities
        configureCollectionView(guestCommentsCollectionView, tag: 1) // Tag 1 for comments
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
        present(cancelBookingView, animated: true, completion: nil)
    }
    
    @IBAction func continueBookingTapped(_ sender: Any) {
        coordinator?.gotoBeachDetails(id: booking?.beachHouse?.id ?? "")
    }
}

extension BeachBookingDetailsView: SumbitBtnDelegate {
    func submitTapped(rating: Int, comment: String?) {
        userComment = comment
        userRating = rating
        LoadingModal.show(title: "Submitting review...")
        let request = AddReviewRequest(itemId: booking?.beachHouse?.id ?? "", type: "BeachHouse", note: comment ?? "", rating: rating)
        vm.saveReview(request)
    }
}

extension BeachBookingDetailsView {
    func bindNetwork() {
        chatVm.transform(input: chatInput)
        beachVM.transform(input: beachInput)
        
        vm.output.subscribe(onNext: { [weak self] response in
            LoadingModal.dismiss()
            switch response {
            case .addReviewSuccess(let response):
                MiddleModal.show(title: "Success", subtitle: response.message ?? "Review submitted", type: .success, primaryText: "Okay", dismissable: false, dismissOnConfirm: true, onConfirm: {
                    self?.dismiss(animated: true)
                })
            case .addReviewFailure(let error):
                MiddleModal.show(title: "Error", subtitle: error.message ?? "Something went wrong", type: .error, primaryText: "Okay", dismissable: false, dismissOnConfirm: true, onConfirm: {
                    self?.dismiss(animated: true)
                })
            }
        }).disposed(by: disposeBag)
        
        chatVm.output.subscribe(onNext: { [weak self] data in
            LoadingModal.dismiss()
            switch data {
            case .startConversationSuccess(let response):
                if let res = response.data {
                    self?.coordinator?.gotoChat(bookingId: "", otherUser: "", conversationId: res.id, propertyType: "BeachHouse")
                }
            case .startConversationFailed(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
        }).disposed(by: disposeBag)
        
        beachVM.output.subscribe(onNext: { [weak self] data in
            LoadingModal.dismiss()
            switch data {
            case .getBeachHouseSuccess(let response):
                self?.beachDetails = response.data
                self?.amenities = self?.beachDetails?.amenities ?? []
                self?.comments = self?.beachDetails?.reviews ?? []
                self?.setup() // Update UI with new data
                self?.categoriesCollectionView.reloadData() // Reload amenities
                self?.guestCommentsCollectionView.reloadData() // Reload comments
            case .getBeachHouseFailed(let error):
                MiddleModal.show(title: error.message ?? "", type: .error, dismissable: false, onConfirm: { self?.coordinator?.pop() })
            }
        }).disposed(by: disposeBag)
    }
}

extension BeachBookingDetailsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
            view.identifier = "Amenities " + indexPath.description
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

    @objc func addNewBtnTapped() {
        print("Add button tapped")
    }

    @objc func settingsBtnTapped() {
        print("Settings button tapped")
    }
}

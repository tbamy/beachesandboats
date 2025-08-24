//
//  BoatBookingDetailsView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 13/02/2025.
//

import UIKit
import MapKit
import RxSwift
import SDWebImage
import SDWebImageSVGCoder

class BoatBookingDetailsView: BaseViewControllerPlain {
    
    var coordinator: BookingsCoordinator?
    
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var peopleCapacityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
//    @IBOutlet weak var startingLocationLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var guestCommentsCollectionView: UICollectionView!
    @IBOutlet weak var locationView: MKMapView!
//    @IBOutlet weak var hostNameLabel: UILabel!
//    @IBOutlet weak var aboutHostLabel: UILabel!
    @IBOutlet weak var proceedView: UIView!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var myDestinationStack: UIStackView!
    
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var costAmountLabel: UILabel!
    @IBOutlet weak var cleaningFeeLabel: UILabel!
    @IBOutlet weak var serviceFeeLabel: UILabel!
    @IBOutlet weak var CostTotalAmountLabel: UILabel!
    @IBOutlet weak var reviewBtn: PlainOutlineButton!
    
    var booking: BoatBookingsPast?
    var isupcomingBooking: Bool = false
    
//    var boatDetails: GetBoatData?
    
    var amenities: [Amenity] = []
    var roomImages: [String] = []
    var destinations: [Destination] = []
    var pickerItems: [PickerItem] = []
    
    var comments: [Review] = []
    var userComment: String?
    var userRating: Int?
    
    var numberOfPeoplePickerItems: [PickerItem] = []
    var cruiseLengthPickerItems: [PickerItem] = []
    
    var isCruising: Bool = false
    let user = UserSession.shared.userDetails?.id
    
    var vm = BeachBookingDetailsVM()
    let chatVm = StartConversationVM()
    let chatInput = PublishSubject<StartConversationVM.Input>()
    var disposeBag = DisposeBag()
    
    var destinationMapping: [String: Destination] = [:]
    var selectedDestination: Destination?

    private var currentModalHeight: CGFloat = UIScreen.main.bounds.height * 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        configureAllCollectionViews()
//        setupCustomNavigationButtons()
        bind()
    }
    
    func setup(){
        
        if let url = URL(string: booking?.boat.images?.first?.url?.replacingOccurrences(of: "http://", with: "https://") ?? ""){
            topImage.sd_setImage(with: url, placeholderImage: UIImage(named: "dummy"))

        } else {
            topImage.image = UIImage(named: "dummy")
        }
        
        titleLabel.text = booking?.boat.name
        locationLabel.text = "\(booking?.boat.locations?.city ?? ""), \(booking?.boat.locations?.state ?? "") \(booking?.boat.locations?.country ?? "")"
        locationView.layer.cornerRadius = 8
        descriptionLabel.text = booking?.boat.description
//        aboutHostLabel.text = booking?.boat.aboutOwner
//        hostNameLabel.text = "\(booking?.boat.owner?.firstName ?? "") \(booking?.boat?.owner?.lastName ?? "")"
        ratingLabel.text = "\(booking?.boat.rating ?? 0)"
        totalAmountLabel.text = "₦ \(booking?.total ?? 0)"
//        proceedView.isHidden = true
        peopleCapacityLabel.text = "\(booking?.noOfPeople ?? "")"
        
//        amenities = booking?.boat.amenities ?? []
        destinationLabel.text = booking?.boatDestination?.name

        
        topImage.isUserInteractionEnabled = true
        topImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewImages)))
        
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

    @objc func viewImages(){
        
        if let rooms = booking?.boat.images{
            roomImages = rooms.compactMap { $0.url }
            coordinator?.gotoAllPhotos(images: roomImages)
        }
        
    }
    
    
    @IBAction func writeReviewTapped(_ sender: Any) {
        
        RatingModal.show(on: self.view, userComment: "", delegate: self)
    }
    
    @IBAction func messageHostTapped(_ sender: Any) {
//        let personId = booking?.hostID ?? ""
//        let conversationRequest = StartConversationRequest(personId: personId, bookingId: booking?.id, propertyType: "BeachHouse")
//        print(conversationRequest)
//            chatInput.onNext(.startConversation(conversationRequest))
//            LoadingModal.show()
    }
    
    
    
    @IBAction func cancelBookingTapped(_ sender: Any) {
        let cancelBookingView = CancelBookingView()
        cancelBookingView.bookingId = booking?.bookingId ?? ""
        cancelBookingView.bookingType = "Boat"
        cancelBookingView.modalPresentationStyle = .custom
        cancelBookingView.transitioningDelegate = self
        currentModalHeight = UIScreen.main.bounds.height * 0.75
        cancelBookingView.transitioningDelegate = self

        present(cancelBookingView, animated: true, completion: nil)
    }
    

    @IBAction func continueBookingTapped(_ sender: Any) {
        print("Continue Tapped")
        
        coordinator?.gotoBoatDetails(id: booking?.boat.id ?? "")
    }
    
    
    func bind(){
//        chatVm.transform(input: chatInput)
        
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
        
//        chatVm.output.subscribe(onNext: { [weak self] data in
//            LoadingModal.dismiss()
//            switch data {
//            case .startConversationSuccess(let response):
//                if let res = response.data{
//                    self?.coordinator?.gotoChat(otherUser: "", conversationId: res.id)
//                }
//            case .startConversationFailed(let error) :
//                MiddleModal.show(title: error.message ?? "", type: .error)
//            }
//        }).disposed(by: disposeBag)

    }


}

extension BoatBookingDetailsView: SumbitBtnDelegate {
    
    func submitTapped(rating: Int, comment: String?) {
        print("The rating is \(rating)")
        print("The comment is \(comment ?? "")")
        
        userComment = comment
        userRating = rating

        LoadingModal.show(title: "Submitting review...")
        let request = AddReviewRequest(itemId: booking?.boat.id ?? "", type: "Boat", note: comment ?? "", rating: rating)
        vm.saveReview(request)
       
    }

}

extension BoatBookingDetailsView: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController,
                              presenting: UIViewController?,
                              source: UIViewController) -> UIPresentationController? {
        return CustomBottomSheetPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            height: currentModalHeight)
    }
}

extension BoatBookingDetailsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 1:
            return amenities.count
        case 2:
            return comments.count
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
            let cellAt = amenities[indexPath.item]
            
            let view = CategoriesCell(frame: cell.bounds)
            view.identifier = "Amenitiess " + indexPath.description
            view.model.image = cellAt.icon ?? ""
            view.model.title = cellAt.name
            view.isSubcategory = true
            
            cell.applyView(view: view)
            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
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
        case 1:
            return CGSize(width: (collectionView.bounds.width / 6), height: 50)
        case 2:
            return CGSize(width: (collectionView.bounds.width / 6), height: 50)
        default:
            return CGSize()
        }
    }
    
    
}



extension BoatBookingDetailsView {
    func setupCustomNavigationButtons() {
        
        let addButton = UIButton(type: .custom)
        addButton.setImage(Assets.favorite.image, for: .normal)
        addButton.addTarget(self, action: #selector(viewImages), for: .touchUpInside)
        let addBarButtonItem = UIBarButtonItem(customView: addButton)

        let settingsButton = UIButton(type: .custom)
        settingsButton.setImage(Assets.share .image, for: .normal)
        settingsButton.addTarget(self, action: #selector(viewImages), for: .touchUpInside)
        let settingsBarButtonItem = UIBarButtonItem(customView: settingsButton)

        navigationItem.rightBarButtonItems = [addBarButtonItem, settingsBarButtonItem]
    }


}

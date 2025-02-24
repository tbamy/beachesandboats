//
//  BeachDetailsView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 23/12/2024.
//

import UIKit
import MapKit
import Kingfisher
import RxSwift

class BeachDetailsView: BaseViewControllerPlain {
    
    var coordinator: ExploreCoordinator?
    
    
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
    
    
    @IBOutlet weak var dayBookingBtn: CheckboxButton!
    @IBOutlet weak var nightBookingBtn: CheckboxButton!
    
    var isDayBooking: Bool = false
    
    var beachDetails: Listing?
    var amenities: [Amenity] = []
    var roomImages: [String] = []
    var comments: [Review] = []
    
    var from_when: Date?
    var to_when: Date?
    
    var backendFrom_when: Date?
    var backendTo_when: Date?
    
    let vm = StartConversationVM()
    let disposeBag = DisposeBag()
    let input = PublishSubject<StartConversationVM.Input>()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        configureAllCollectionViews()
        setupCustomNavigationButtons()
        bind()
    }
    
    func setup(){
        checkinDateLabel.placeholder = "Select Date"
        checkoutDateLabel.placeholder = "Select Date"
        
        if let url = URL(string: beachDetails?.rooms?.first?.images?.first?.url?.replacingOccurrences(of: "http://", with: "https://") ?? "") {
//            print("Image Url is: \(url)")
            topImage.kf.setImage(with: url)
        }
//        print("Beach Details: \(beachDetails)")
        
        
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
        
        titleLabel.text = beachDetails?.name
        locationLabel.text = "\(beachDetails?.locations?.city ?? ""), \(beachDetails?.locations?.state ?? "") \(beachDetails?.locations?.country ?? "")"
        locationView.layer.cornerRadius = 8
        descriptionLabel.text = beachDetails?.description
        aboutHostLabel.text = beachDetails?.aboutOwner
        hostNameLabel.text = "\(beachDetails?.owner?.firstName ?? "") \(beachDetails?.owner?.lastName ?? "")"
        ratingLabel.text = "\(beachDetails?.rating ?? 0)"
        totalAmountLabel.text = "₦ \(beachDetails?.pricePerNight ?? 0)"
        let totalGuests = (beachDetails?.noOfAdults ?? 0) + (beachDetails?.noOfChildren ?? 0)
        roomAndGuestsLabel.text = "\(totalGuests) guests, \(beachDetails?.rooms?.count ?? 0) rooms"
        
        
        amenities = beachDetails?.amenities ?? []
        comments = beachDetails?.reviews ?? []
        
        topImage.isUserInteractionEnabled = true
        topImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewImages)))
        
    }
    
    @objc func viewImages(){
        
        if let rooms = beachDetails?.rooms{
            roomImages = rooms.compactMap { $0.images }
                .flatMap { $0 }
                .compactMap { $0.url }
            coordinator?.gotoAllPhotos(images: roomImages)
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

    @IBAction func continueBookingTapped(_ sender: Any) {
        print("Continue Tapped")
        let bookingType = isDayBooking ? "DAY" : "NIGHT"

        if let fromWhen = from_when, let toWhen = to_when{
            if let beachDetails = beachDetails{
                let beachBookingRequest = CreateBeachHouseBookingRequest(userId: "", beachHouseRoomId: "", checkingDate: fromWhen.toBackendDate() , checkoutDate: toWhen.toBackendDate() , checkingTime: "", checkoutTime: "", numberOfPeople: 0, amount: 0, units: 0, bookingType: bookingType)
                print(beachBookingRequest)
                
                coordinator?.gotoBookingRoomsListView(listing: beachDetails, booking: beachBookingRequest)
            }
        }else{
            MiddleModal.show(title: "Invalid Date", subtitle: "Please pick checkout and checkin dates", type: .error, dismissable: true, dismissOnConfirm: true)
        }
        
    }
    
    @IBAction func sendPreBookingTapped(_ sender: Any) {
        //start conversation
        let personId = beachDetails?.owner?.id ?? ""
        let conversationRequest = StartConversationRequest(personId: personId, bookingId: nil, propertyType: nil)
        print(conversationRequest)
            input.onNext(.startConversation(conversationRequest))
            LoadingModal.show()
    }
    
    func bind(){
        vm.transform(input: input)
        
        vm.output.subscribe(onNext: { [weak self] data in
            LoadingModal.dismiss()
            switch data {
            case .startConversationSuccess(let response):
//                self?.conversationResponse = response
                if let res = response.data{
                    let data = ChatMessage(message: "", name: "", time: "")
                    self?.coordinator?.gotoChat(data: [data])
                }
            case .startConversationFailed(let error) :
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
        }).disposed(by: disposeBag)
    }
    
}

extension BeachDetailsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
            view.model.name = cellAt.firstName ?? ""
            view.model.rating = 1
            view.model.comment = "Lorem ipsum"
            
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


extension BeachDetailsView {
    func setupCustomNavigationButtons() {
        
        let addButton = UIButton(type: .custom)
        addButton.setImage(Assets.backButton.image, for: .normal)
        addButton.addTarget(self, action: #selector(addNewBtnTapped), for: .touchUpInside)
        let addBarButtonItem = UIBarButtonItem(customView: addButton)

        let settingsButton = UIButton(type: .custom)
        settingsButton.setImage(Assets.backButton .image, for: .normal)
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

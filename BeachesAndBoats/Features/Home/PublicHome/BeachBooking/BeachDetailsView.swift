//
//  BeachDetailsView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 23/12/2024.
//

import UIKit
import MapKit
import SDWebImage
import SDWebImageSVGCoder
import RxSwift
import CoreLocation

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
    
    @IBOutlet weak var guestCommentsStack: UIStackView!
    
    
    @IBOutlet weak var dayBookingBtn: CheckboxButton!
    @IBOutlet weak var nightBookingBtn: CheckboxButton!
    
    private let beachVM = BeachHouseVM()
    private let beachInput = PublishSubject<BeachHouseVM.Input>()
    
    private var currentModalHeight: CGFloat = UIScreen.main.bounds.height * 0.5
    
    let locationManager = CLLocationManager()
    var isDayBooking: Bool = false
    
    var beachDetails: GetBeachData?
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
    
    var id: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        configureAllCollectionViews()
        setupCustomNavigationButtons()
        bind()
        
        LoadingModal.show()
//        print(id)
        beachInput.onNext(.getBeachHouse(id: id ?? ""))
    }
    
    func setup(){
//        setupMap()
        checkinDateLabel.placeholder = "Select Date"
        checkoutDateLabel.placeholder = "Select Date"
        
        
        let imgUrl = beachDetails?.rooms?.first?.images?.first?.url
        imgUrl?.loadImage(into: topImage, placeholder: "dummy")
        backendFrom_when = beachDetails?.availabilities?.availableFrom?.convertFromBackendDateString()
        backendTo_when = beachDetails?.availabilities?.availableTo?.convertFromBackendDateString()
        
//        if let from = backendFrom_when , let to = backendTo_when{
//            checkinDateLabel.text = "\(from.toFormattedDate())"
//            checkoutDateLabel.text = "\(to.toFormattedDate())"
//        }
        
        
        nightBookingBtn.isChecked = true
        totalAmountLabel.text = "From ₦ \(beachDetails?.minRoomPricePerNight?.toAmount() ?? "0")"
        
        
        dayBookingBtn.stateChanged = { [weak self] isSelected in
            guard let self = self else { return }
            self.isDayBooking = true
            self.nightBookingBtn.isChecked = false
            
            totalAmountLabel.text = "From ₦ \(beachDetails?.minRoomPricePerDay?.toAmount() ?? "0")"
        }
        
        nightBookingBtn.stateChanged = { [weak self] isSelected in
            guard let self = self else { return }
            self.isDayBooking = false
            self.dayBookingBtn.isChecked = false
            
            totalAmountLabel.text = "From ₦ \(beachDetails?.minRoomPricePerNight?.toAmount() ?? "0")"
        }
        
        checkinDateLabel.onDateSelected = { (date) in
            
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
        
        checkinDateLabel.onDatesSelected = { (from, to) in
            
            self.from_when = from
            self.to_when = to
            
            if let backendFrom = self.backendFrom_when, let backendTo = self.backendTo_when {
                guard from >= backendFrom && to ?? Date() <= backendTo else {
                    MiddleModal.show(title: "Invalid Date", subtitle: "Please pick between (\(backendFrom.toFormattedDate()) and \(backendTo.toFormattedDate()))", type: .error, dismissable: true, dismissOnConfirm: true)
                    return
                }
                self.checkinDateLabel.text = "\(from.toFormattedDate())"
                self.checkoutDateLabel.text = "\(to?.toFormattedDate() ?? "")"

            } else {
                print("Backend dates are not set.")
                self.checkinDateLabel.text = "\(from.toFormattedDate())"
                self.checkoutDateLabel.text = "\(to?.toFormattedDate() ?? "")"
            }
        }

        
        checkoutDateLabel.onDatesSelected = { (from, to) in
            
            self.from_when = from
            self.to_when = to
            
            if let backendFrom = self.backendFrom_when, let backendTo = self.backendTo_when {
                guard from >= backendFrom && to ?? Date() <= backendTo else {
                    MiddleModal.show(title: "Invalid Date", subtitle: "Please pick between (\(backendFrom.toFormattedDate()) and \(backendTo.toFormattedDate()))", type: .error, dismissable: true, dismissOnConfirm: true)
                    return
                }
                
                
                self.checkinDateLabel.text = "\(from.toFormattedDate())"
                self.checkoutDateLabel.text = "\(to?.toFormattedDate() ?? "")"
            
            } else {
                print("Backend dates are not set.")
                self.checkinDateLabel.text = "\(from.toFormattedDate())"
                self.checkoutDateLabel.text = "\(to?.toFormattedDate() ?? "")"
            }
        }
        
        titleLabel.text = beachDetails?.name
        locationLabel.text = "\(beachDetails?.locations?.city ?? ""), \(beachDetails?.locations?.state ?? "") \(beachDetails?.locations?.country ?? "")"
        locationView.layer.cornerRadius = 8
        let longitude = Double(beachDetails?.locations?.longitude ?? "") ?? 0
        let latitude = Double(beachDetails?.locations?.latitude ?? "") ?? 0
        
//        let longitude = Double("-95.5878280") ?? 0
//        let latitude = Double("23.9900130") ?? 0
        print("\(latitude), \(longitude)")
        
        centerMapOnLocation(latitude: latitude, longitude: longitude)
        descriptionLabel.text = beachDetails?.description
        aboutHostLabel.text = beachDetails?.aboutOwner
        hostNameLabel.text = "\(beachDetails?.owner?.firstName ?? "") \(beachDetails?.owner?.lastName ?? "")"
        ratingLabel.text = "\(beachDetails?.rating ?? 0)"
        roomAndGuestsLabel.text = "\(beachDetails?.rooms?.first?.noOfOccupant ?? "") guests, \(beachDetails?.rooms?.count ?? 0) room(s)"

        
        amenities = beachDetails?.amenities ?? []
        comments = beachDetails?.reviews ?? []
        guestCommentsStack.isHidden = comments.isEmpty
        categoriesCollectionView.reloadData()
        guestCommentsCollectionView.reloadData()
    
        print("Amenities: \(amenities)")
        
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
                print("Details: \(beachDetails)")
                
                let rules = beachDetails.houseRules?.compactMap { rule -> String? in
                    return rule.name?.trimmingCharacters(in: .whitespacesAndNewlines)
                }

                let bulletRules = rules?.map { "• \($0)" }.joined(separator: "\n") ?? ""
                
                HouseRulesModal.show(on: self.view, rules: bulletRules, callBack: { [weak self] in
                    self?.coordinator?.gotoBookingRoomsListView(listing: beachDetails, booking: beachBookingRequest)
                })
                
                
            }
        }else{
            MiddleModal.show(title: "Invalid Date", subtitle: "Please pick checkout and checkin dates", type: .error, dismissable: true, dismissOnConfirm: true)
        }
        
    }
    
    @IBAction func sendPreBookingTapped(_ sender: Any) {
        //start conversation
        let personId = beachDetails?.owner?.id ?? ""
        let conversationRequest = StartConversationRequest(personId: personId, bookingId: nil, propertyType: "BeachHouse")
        print(conversationRequest)
            input.onNext(.startConversation(conversationRequest))
            LoadingModal.show()
    }
    
    func bind(){
        vm.transform(input: input)
        beachVM.transform(input: beachInput)
        
        vm.output.subscribe(onNext: { [weak self] data in
            LoadingModal.dismiss()
            switch data {
            case .startConversationSuccess(let response):
//                self?.conversationResponse = response
                if let res = response.data{
                    self?.coordinator?.gotoChat(bookingId: "", otherUser: self?.beachDetails?.owner?.firstName ?? "", conversationId: res.id, propertyType: "BeachHouse")
//                    self?.coordinator?.gotoChat(otherUser: self?.beachDetails?.owner?.firstName ?? "", conversationId: res.id)
                }
            case .startConversationFailed(let error) :
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
        }).disposed(by: disposeBag)
        
        beachVM.output.subscribe(onNext: { [weak self] data in
            LoadingModal.dismiss()
            switch data {
            case .getBeachHouseSuccess(let response):
                self?.beachDetails = response.data
//                print("Details: \(self?.beachDetails)")
                self?.setup()
                
            case .getBeachHouseFailed(let error) :
                MiddleModal.show(title: error.message ?? "", type: .error, dismissable: false, onConfirm: {self?.coordinator?.pop()})
            }
        }).disposed(by: disposeBag)
    }
    
}

extension BeachDetailsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
            let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
            let cellAt = amenities[indexPath.item]
            
            let view = CategoriesCell(frame: cell.bounds)
            view.identifier = "Amenitiess " + indexPath.description
            view.model.image = cellAt.icon ?? ""
            view.model.title = cellAt.name
            view.model.dummyImage = "luxuryIcon"
            view.isSubcategory = true
            
            cell.applyView(view: view)
            return cell
            
        case 2:
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
        case 1:
            return CGSize(width: (collectionView.bounds.width / 6), height: 50)
        case 2:
            return CGSize(width: (collectionView.bounds.width) - 20, height: 150)
        default:
            return CGSize()
        }
    }
    
    
}


extension BeachDetailsView {
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
    
    func centerMapOnLocation(latitude: Double, longitude: Double, radius: Double = 500) {
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(
            center: location,
            latitudinalMeters: radius,
            longitudinalMeters: radius
        )
        locationView.setRegion(region, animated: true)
    }

}

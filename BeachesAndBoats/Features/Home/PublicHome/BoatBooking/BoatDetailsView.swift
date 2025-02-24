//
//  BoatDetailsView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 26/12/2024.
//

import UIKit
import MapKit
import RxSwift

class BoatDetailsView: BaseViewControllerPlain {
    
    var coordinator: ExploreCoordinator?
    
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var peopleCapacityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var startingLocationLabel: UILabel!
    @IBOutlet weak var bookingDateLabel: DatePicker!
    @IBOutlet weak var bookingTimeLabel: TimePicker!
    @IBOutlet weak var numberOfPeopleLabel: DropDown!
    @IBOutlet weak var cruiseLengthLabel: DropDown!
    @IBOutlet weak var cruiseLengthStack: UIStackView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var guestCommentsCollectionView: UICollectionView!
    @IBOutlet weak var locationView: MKMapView!
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var aboutHostLabel: UILabel!
    @IBOutlet weak var proceedView: UIView!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var cruisingOption: CheckboxButton!
    @IBOutlet weak var travelDestinationOption: CheckboxButton!
    @IBOutlet weak var myDestinationStack: UIStackView!
    @IBOutlet weak var myDestinationDropdown: DropDown!
    
    
    
    var boatDetails: Listing?
    
    var amenities: [Amenity] = []
    var roomImages: [String] = []
    var destinations: [Destination] = []
    var pickerItems: [PickerItem] = []
    
    var numberOfPeoplePickerItems: [PickerItem] = []
    var cruiseLengthPickerItems: [PickerItem] = []
    
    var isCruising: Bool = false
    let user = UserSession.shared.userDetails?.id
    
    let vm = StartConversationVM()
    let disposeBag = DisposeBag()
    let input = PublishSubject<StartConversationVM.Input>()
    
    var destinationMapping: [String: Destination] = [:]
    var selectedDestination: Destination?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        configureAllCollectionViews()
        setupCustomNavigationButtons()
        bind()
    }
    
    func setup(){
        if let url = URL(string: boatDetails?.images?.first?.url?.replacingOccurrences(of: "http://", with: "https://") ?? "") {
            print("Image Url is: \(url)")
            topImage.kf.setImage(with: url)
        }
        titleLabel.text = boatDetails?.name
        locationLabel.text = "\(boatDetails?.locations?.city ?? ""), \(boatDetails?.locations?.state ?? "") \(boatDetails?.locations?.country ?? "")"
        locationView.layer.cornerRadius = 8
        descriptionLabel.text = boatDetails?.description
        aboutHostLabel.text = boatDetails?.aboutOwner
        hostNameLabel.text = "\(boatDetails?.owner?.firstName ?? "") \(boatDetails?.owner?.lastName ?? "")"
        ratingLabel.text = "\(boatDetails?.rating ?? 0)"
//        totalAmountLabel.text = "₦ \(boatDetails?.pricePerNight ?? 0)"
        proceedView.isHidden = true
        peopleCapacityLabel.text = "1 - \((boatDetails?.noOfAdults ?? 0) + (boatDetails?.noOfChildren ?? 0)) "
        
        amenities = boatDetails?.amenities ?? []
        destinations = boatDetails?.destinations ?? []
        pickerItems = destinations.compactMap{ destination in
            let id = destination.id ?? ""
            let name = destination.name ?? "Unknown"
            let price = destination.price ?? ""
            
            destinationMapping[id] = destination
            return PickerItem(name: "\(name) - ₦\(price) / trip", value: id)
        }
        
        myDestinationDropdown.items = pickerItems
        myDestinationDropdown.itemChanged = { [weak self] item in
            guard let self = self, let destination = destinationMapping[item.value] else { return }
            proceedView.isHidden = false
            let selectedPrice = destination.price ?? ""
            selectedDestination = destination
            totalAmountLabel.text = "₦\(selectedPrice)"
        }
        
        numberOfPeoplePickerItems = (1...10).map { PickerItem(name: "\($0)", value: "\($0)") }
        cruiseLengthPickerItems = (1...10).map { PickerItem(name: "\($0) hours", value: "\($0)") }
        
        numberOfPeopleLabel.items = numberOfPeoplePickerItems
        cruiseLengthLabel.items = cruiseLengthPickerItems
                
        travelDestinationOption.isChecked = true
        updateTravel()
        cruisingOption.stateChanged = { [weak self] isSelected in
            guard let self = self else { return }
            self.isCruising = isSelected
            updateCruising()
        }
        
        travelDestinationOption.stateChanged = { [weak self] isSelected in
            guard let self = self else { return }
            self.isCruising = isSelected
            updateTravel()
        }

        
        topImage.isUserInteractionEnabled = true
        topImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewImages)))
        
    }
    
    func updateCruising(){
        self.travelDestinationOption.isChecked = false
        cruiseLengthStack.isHidden = false
        myDestinationStack.isHidden = true
    }
    
    func updateTravel(){
        self.cruisingOption.isChecked = false
        myDestinationStack.isHidden = false
        cruiseLengthStack.isHidden = true
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
        
        if let rooms = boatDetails?.images{
            roomImages = rooms.compactMap { $0.url }
            coordinator?.gotoAllPhotos(images: roomImages)
        }
        
    }
    
    @IBAction func continueBookingTapped(_ sender: Any) {
        print("Continue Tapped")
        
        let bookingType = isCruising ? "CRUISE" : "TRIP"
        
        if validateRequest(){
            if let boatDetails = boatDetails, let selectedDestination = selectedDestination, let bookingDate = bookingDateLabel.selectedDate, let bookingTime = bookingTimeLabel.selectedTime, let numberOfPeople = numberOfPeopleLabel.selectedItem{
                let request = CreateBoatBookingRequest(boatId: boatDetails.id ?? "", userId: user ?? "", bookingDate: bookingDate.toBackendDate(), bookingTime: bookingTime.toBackendTime(), bookingType: bookingType, numberOfPeople: Int(numberOfPeople.value) ?? 1, destinationId: myDestinationDropdown.selectedItem?.value ?? "", cruiseLength: Int(cruiseLengthLabel.selectedItem?.value ?? "") ?? 0)
                print(request)
                coordinator?.gotoConfirmBoatBookingView(listing: boatDetails, booking: request, destination: selectedDestination)
            }
        }
        
    }
    
    @IBAction func sendPreBookingTapped(_ sender: Any) {
        //start conversation
        let personId = boatDetails?.owner?.id ?? ""
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
    
    
    func validateRequest() -> Bool{
        let validateBookingDate = bookingDateLabel.validate(rules: [Rule(.isEmpty, "Booking Date must be selected")])
        let validateBookingTime = bookingTimeLabel.validate(rules: [Rule(.isEmpty, "Booking Time must be selected")])
//        let validateCruiseLength = cruiseLengthLabel.validate(rules: [Rule(.isEmpty, "Select must be selected")])
        let validateNumberOfPeople = numberOfPeopleLabel.validate(rules: [Rule(.isEmpty, "Number of people must be selected")])
        
        return validateBookingDate && validateBookingTime && validateNumberOfPeople
    }

}

extension BoatDetailsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 1:
            return amenities.count
        case 2:
            return amenities.count
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
            view.model.title = cellAt.name ?? ""
            view.isSubcategory = true
            
            cell.applyView(view: view)
            return cell
        case 2:
            let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
            let cellAt = amenities[indexPath.item]
            
            let view = CategoriesCell(frame: cell.bounds)
            view.identifier = "Amenitiess " + indexPath.description
            view.model.image = cellAt.icon ?? ""
            view.model.title = cellAt.name ?? ""
            view.isSubcategory = true
            
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



extension BoatDetailsView {
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

//
//  BoatDetailsView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 26/12/2024.
//

import UIKit
import RxSwift
import SDWebImage
import SDWebImageSVGCoder

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
    @IBOutlet weak var guestCommentsStack: UIStackView!
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var aboutHostLabel: UILabel!
    @IBOutlet weak var proceedView: UIView!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var cruisingOption: CheckboxButton!
    @IBOutlet weak var travelDestinationOption: CheckboxButton!
    @IBOutlet weak var myDestinationStack: UIStackView!
    @IBOutlet weak var myDestinationDropdown: DropDown!
    
    
    @IBOutlet weak var boatOptionsStack: UIStackView!
    @IBOutlet weak var cruiseOptionStack: UIStackView!
    
    private let boatVM = BoatVM()
    private let boatInput = PublishSubject<BoatVM.Input>()
    
    var boatDetails: GetBoatData?
    
    var amenities: [Amenity] = []
    var roomImages: [String] = []
    var destinations: [Destination] = []
    var pickerItems: [PickerItem] = []
    var comments: [Review] = []
    
    var numberOfPeoplePickerItems: [PickerItem] = []
    var cruiseLengthPickerItems: [PickerItem] = []
    
    var isCruising: Bool = false
    let user = UserSession.shared.userDetails?.id
    
    let vm = StartConversationVM()
    let disposeBag = DisposeBag()
    let input = PublishSubject<StartConversationVM.Input>()
    var boatCapacity = 1
    
    var id: String?
    
    var destinationMapping: [String: Destination] = [:]
    var selectedDestination: Destination?

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setup()
        configureAllCollectionViews()
//        setupCustomNavigationButtons()
        bind()
        
        LoadingModal.show()
        boatInput.onNext(.getBoat(id: id ?? ""))
    }
    
    func setup(){
        
        if let url = URL(string: boatDetails?.images?.first?.url?.replacingOccurrences(of: "http://", with: "https://") ?? ""){
            topImage.sd_setImage(with: url, placeholderImage: UIImage(named: "dummy"))
        } else {
            topImage.image = UIImage(named: "dummy")
        }
        
        titleLabel.text = boatDetails?.name
        locationLabel.text = "\(boatDetails?.locations?.jettyLocation ?? ""), \(boatDetails?.locations?.name ?? "")"
        descriptionLabel.text = boatDetails?.description
        aboutHostLabel.text = boatDetails?.aboutOwner
        hostNameLabel.text = "\(boatDetails?.owner?.firstName ?? "") \(boatDetails?.owner?.lastName ?? "")"
        ratingLabel.text = "\(boatDetails?.rating ?? 0)"
        let maxDate = boatDetails?.availabilities?.availableTo
        print(maxDate)
//        11\/27\/2025
        bookingDateLabel.minimumDate = Date()
        bookingDateLabel.maximumDate = maxDate?.convertFromBackendDateString()
//        totalAmountLabel.text = "₦ \(boatDetails?.pricePerNight ?? 0)"
        proceedView.isHidden = true
        
        boatCapacity = (Int(boatDetails?.noOfPassengers ?? 1))
        
        print("Cap: \(boatCapacity)")
        
        peopleCapacityLabel.text = "1 - \(boatCapacity) "
        startingLocationLabel.text = "\(boatDetails?.locations?.jettyLocation ?? ""), \(boatDetails?.locations?.name ?? "")"
        
        destinations = boatDetails?.destinations ?? []
        if destinations.contains(where: { $0.name.caseInsensitiveCompare("Cruising") == .orderedSame}) && destinations.count == 1{
            boatOptionsStack.isHidden = true
            myDestinationStack.isHidden = true
            
        }else if destinations.contains(where: { $0.name.caseInsensitiveCompare("Cruising") == .orderedSame}) && destinations.count > 1{
            boatOptionsStack.isHidden = false
            myDestinationStack.isHidden = false
            cruiseOptionStack.isHidden = false
        }else{
            cruiseOptionStack.isHidden = true
        }
        
//        pickerItems = destinations.compactMap{ destination in
//            let id = destination.id
//            let name = destination.name
//            let price = destination.price ?? "0"
//            
//            destinationMapping[id] = destination
//            return PickerItem(name: "\(name) - ₦\(price.toAmount() ?? "0") / trip", value: id)
//        }
//        
//        myDestinationDropdown.items = pickerItems
//        myDestinationDropdown.itemChanged = { [weak self] item in
//            guard let self = self, let destination = destinationMapping[item.value] else { return }
//            proceedView.isHidden = false
//            let selectedPrice = destination.price ?? "0"
//            selectedDestination = destination
//            totalAmountLabel.text = "₦\(selectedPrice.toAmount() ?? "0")"
//        }
        print("Cap: \(boatCapacity)")
        
        numberOfPeoplePickerItems = (1...Int(boatCapacity)).map { PickerItem(name: "\($0)", value: "\($0)") }
        cruiseLengthPickerItems = (1...10).map { PickerItem(name: "\($0) hours", value: "\($0)") }
        
        numberOfPeopleLabel.items = numberOfPeoplePickerItems
        numberOfPeopleLabel.pickerTitle = "Select number of people"
        cruiseLengthLabel.items = cruiseLengthPickerItems
        cruiseLengthLabel.pickerTitle = "Select cruise length"
        myDestinationDropdown.pickerTitle = "Select a destination"
                
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
        
        amenities = boatDetails?.amenities ?? []
        comments = boatDetails?.reviews ?? []
        guestCommentsStack.isHidden = comments.isEmpty
        
        guestCommentsCollectionView.reloadData()
        categoriesCollectionView.reloadData()
        
        topImage.isUserInteractionEnabled = true
        topImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewImages)))
        
    }
    
    func updateCruising(){
        self.destinations = boatDetails?.destinations?.filter({ $0.name.caseInsensitiveCompare("Cruising") == .orderedSame }) ?? []
        self.isCruising = true
        self.travelDestinationOption.isChecked = false
        cruiseLengthStack.isHidden = false
        myDestinationStack.isHidden = true
    }
    
    func updateTravel(){
        self.destinations = boatDetails?.destinations?.filter({ $0.name.caseInsensitiveCompare("Cruising") != .orderedSame }) ?? []
        self.isCruising = false
        self.cruisingOption.isChecked = false
        myDestinationStack.isHidden = false
        cruiseLengthStack.isHidden = true
        
        pickerItems = destinations.compactMap{ destination in
            let id = destination.id
            let name = destination.name
            let price = destination.price ?? "0"
            
            destinationMapping[id] = destination
            return PickerItem(name: "\(name) - ₦\(price.toAmount() ?? "0") / trip", value: id)
        }
        
        myDestinationDropdown.items = pickerItems
        myDestinationDropdown.itemChanged = { [weak self] item in
            guard let self = self, let destination = destinationMapping[item.value] else { return }
            proceedView.isHidden = false
            let selectedPrice = destination.price ?? "0"
            selectedDestination = destination
            totalAmountLabel.text = "₦\(selectedPrice.toAmount() ?? "0")"
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
                let request = CreateBoatBookingRequest(boatId: boatDetails.id, userId: user ?? "", bookingDate: bookingDate.toBackendDate(), bookingTime: bookingTime.toBackendTime(), bookingType: bookingType, numberOfPeople: Int(numberOfPeople.value) ?? 1, destinationId: myDestinationDropdown.selectedItem?.value ?? "", cruiseLength: Int(cruiseLengthLabel.selectedItem?.value ?? "") ?? 0)
                print(request)
                coordinator?.gotoConfirmBoatBookingView(listing: boatDetails, booking: request, destination: selectedDestination)
            }
        }
        
    }
    
    @IBAction func sendPreBookingTapped(_ sender: Any) {
        //start conversation
        let personId = boatDetails?.owner?.id ?? ""
        let conversationRequest = StartConversationRequest(personId: personId, bookingId: nil, propertyType: "Boat")
        print(conversationRequest)
            input.onNext(.startConversation(conversationRequest))
            LoadingModal.show()
    }
    
    func bind(){
        vm.transform(input: input)
        boatVM.transform(input: boatInput)
        
        vm.output.subscribe(onNext: { [weak self] data in
            LoadingModal.dismiss()
            switch data {
            case .startConversationSuccess(let response):
//                self?.conversationResponse = response
                if let res = response.data{
                    self?.coordinator?.gotoChat(bookingId: "", otherUser: self?.boatDetails?.owner?.firstName ?? "", conversationId: res.id, propertyType: "Boat")
//                    self?.coordinator?.gotoChat(otherUser: self?.boatDetails?.owner?.firstName ?? "", conversationId: res.id)
                }
            case .startConversationFailed(let error) :
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
        }).disposed(by: disposeBag)
        
        
        boatVM.output.subscribe(onNext: { [weak self] data in
            LoadingModal.dismiss()
            switch data {
            case .getBoatSuccess(let response):
                self?.boatDetails = response.data
                self?.setup()
            case .getBoatFailed(let error) :
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
            view.model.rating = "\(cellAt.rating ?? 0)"
            view.model.comment = cellAt.note ?? ""
            
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

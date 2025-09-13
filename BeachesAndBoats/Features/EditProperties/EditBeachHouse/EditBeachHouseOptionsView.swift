//
//  EditBeachHouseOptionsView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 23/07/2025.
//

import UIKit
import RxSwift

class EditBeachHouseOptionsView: BaseViewControllerPlain {
    
    
    var coordinator: HostingServiceMenuCoordinator?

    @IBOutlet weak var propertyNameLabel: UILabel!
    @IBOutlet weak var propertyNameEditBtn: UILabel!
    @IBOutlet weak var locationEditBtn: UILabel!
    @IBOutlet weak var availabilityEditBtn: UILabel!
    @IBOutlet weak var amenitiesEditBtn: UILabel!
    @IBOutlet weak var aboutListerEditBtn: UILabel!
    @IBOutlet weak var houseRulesEditBtn: UILabel!
    @IBOutlet weak var roomsAndPricingEditBtn: UILabel!
    @IBOutlet weak var houseDetailsEditBtn: UILabel!
    @IBOutlet weak var listingPriceEditBtn: UILabel!
    @IBOutlet weak var generalPropertyImagesEditBtn: UILabel!
    @IBOutlet weak var deletepropertyBtn: UILabel!
    
    
    let vm = BeachDataViewModel()
    let beachVM = BeachHouseVM()
    let deleteVM = EditBeachViewModel()
    let disposeBag = DisposeBag()
    let beachInput = PublishSubject<BeachHouseVM.Input>()
    
    var beachDataR: BeachDatas?
    var beachDetails: GetBeachData?
    var request: CreateBeachListingRequest?
    var id: String?
    
    // Flag to track if beachData has been loaded
    private var hasLoadedBeachData = false
    var isEntireHouse: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Edit Property"
        
        bindNetwork()
        
        if !hasLoadedBeachData {
            LoadingModal.show()
            vm.getBeachData()
        } else {
            fetchBeachDetails()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if hasLoadedBeachData {
            fetchBeachDetails()
        }
    }
    
    func fetchBeachDetails(){
        LoadingModal.show()
        beachInput.onNext(.getBeachHouse(id: id ?? ""))
    }

    func setup(){
        isEntireHouse = beachDetails?.bookingType == "FULL"
        houseDetailsEditBtn.isHidden = !isEntireHouse
        generalPropertyImagesEditBtn.isHidden = !isEntireHouse
        roomsAndPricingEditBtn.isHidden = isEntireHouse
        roomsAndPricingEditBtn.isHidden = beachDetails?.rooms?.count ?? 0 < 1
        
        propertyNameLabel.text = beachDetails?.name
        let textsAndLabels: [(String, UILabel)] = [
            ("Property name and description", propertyNameEditBtn),
            ("Location", locationEditBtn),
            ("Availability" , availabilityEditBtn),
            ("Amenities and Services" , amenitiesEditBtn),
            ("About lister" , aboutListerEditBtn),
            ("House Rules" , houseRulesEditBtn),
            ("House Details" , houseDetailsEditBtn),
            ("Rooms and Pricing" , roomsAndPricingEditBtn),
            ("General Property Images", generalPropertyImagesEditBtn),
            ("Listing Price" , listingPriceEditBtn),
            ("Delete Property", deletepropertyBtn)
        ]
        gestureRecognizers()

        textsAndLabels.forEach { underlineText(text: $0.0, titleLabel: $0.1) }
        
        
        request = CreateBeachListingRequest(name: beachDetails?.name,
                                            description: beachDetails?.description,
                                            aboutOwner: beachDetails?.aboutOwner,
                                            overnightCheckIn: beachDetails?.overnightCheckIn?.toBackendTime(),
                                            overnightCheckOut: beachDetails?.overnightCheckOut?.toBackendTime(),
                                            dayCheckIn: beachDetails?.dayCheckIn?.toBackendTime(),
                                            dayCheckOut: beachDetails?.dayCheckOut?.toBackendTime(),
                                            categoryId: beachDetails?.category?.id,
                                            subCategoryId: beachDetails?.subCategory?.id,
                                            bookingType: beachDetails?.bookingType,
                                            locationName: beachDetails?.locations?.name,
                                            jettyLocation: beachDetails?.locations?.jettyLocation,
                                            additionalHouseRules: beachDetails?.additionalHouseRules,
                                            isPrivateStay: (beachDetails?.isPrivateStay ?? false) ? 1 : 0,
                                            availableFrom: beachDetails?.availabilities?.availableFrom,
                                            availableTo: beachDetails?.availabilities?.availableTo,
                                            amenities: beachDetails?.amenities?.compactMap{ $0.id },
                                            languages: beachDetails?.languages?.compactMap{ $0.id },
                                            houseRules: beachDetails?.houseRules?.compactMap{ $0.id },
                                            rooms: (beachDetails?.rooms?.count ?? 0 < 1) ? nil : beachDetails?.rooms?.map { $0.toRoom() },
                                            roleType: nil,
                                            listingPrice: beachDetails?.listingPrice,
                                            discountPercent: Int(beachDetails?.discountPercent ?? 0),
                                            pricePerDay: beachDetails?.pricePerDay,
                                            dayDiscountPercent: Int(beachDetails?.dayDiscountPercent ?? 0),
                                            noOfRooms : beachDetails?.noOfRooms,
                                            noOfGuests : beachDetails?.noOfGuests,
                                            noOfBeds : beachDetails?.noOfBeds,
                                            noOfBathrooms : beachDetails?.noOfBathrooms
                                        )

    }
    
    func gestureRecognizers() {
        propertyNameEditBtn.isUserInteractionEnabled = true
        locationEditBtn.isUserInteractionEnabled = true
        availabilityEditBtn.isUserInteractionEnabled = true
        amenitiesEditBtn.isUserInteractionEnabled = true
        aboutListerEditBtn.isUserInteractionEnabled = true
        houseRulesEditBtn.isUserInteractionEnabled = true
        roomsAndPricingEditBtn.isUserInteractionEnabled = true
        generalPropertyImagesEditBtn.isUserInteractionEnabled = true
        listingPriceEditBtn.isUserInteractionEnabled = true
        deletepropertyBtn.isUserInteractionEnabled = true
        
        let gestures: [(UILabel, Selector)] = [
            (propertyNameEditBtn, #selector(propertyNameEditBtnTapped)),
            (locationEditBtn, #selector(locationEditBtnTapped)),
            (availabilityEditBtn, #selector(availabilityEditBtnTapped)),
            (amenitiesEditBtn, #selector(amenitiesEditBtnTapped)),
            (aboutListerEditBtn, #selector(aboutListerEditBtnTapped)),
            (houseRulesEditBtn, #selector(houseRulesEditBtnTapped)),
            (houseDetailsEditBtn, #selector(houseDetailsEditBtnTapped)),
            (roomsAndPricingEditBtn, #selector(roomsAndPricingEditBtnTapped)),
            (generalPropertyImagesEditBtn, #selector(generalPropertyImagesBtnTapped)),
            (listingPriceEditBtn, #selector(listingPriceEditBtnTapped)),
            (deletepropertyBtn, #selector(roomsAndPricingEditBtnTapped))
        ]
        
        for (label, selector) in gestures {
            GestureRecognizerHelper.addTapGestureToLabel(to: label, target: self, action: selector)
        }
    }

    func bindNetwork(){
        beachVM.transform(input: beachInput)
        
        vm.output.subscribe(onNext: { [weak self] response in
            
            switch response {
            case .getBeachDataSuccess(let response):
                self?.beachDataR = response.data
                self?.hasLoadedBeachData = true // Mark as loaded
                self?.fetchBeachDetails()
            case .getBeachDataError(let error):
                LoadingModal.dismiss()
                MiddleModal.show(title: error.message ?? "", type: .error, onConfirm: { self?.coordinator?.pop() })
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
    
    func underlineText(text: String, titleLabel: UILabel){
        let attributedString = NSAttributedString(
            string: text,
            attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue]
        )
        titleLabel.attributedText = attributedString
    }
    
    
    @objc func propertyNameEditBtnTapped(){
        print(beachDataR)
        print(request)
        guard let id = id else { return }
        coordinator?.gotoEditPropertyNameView(beachData: beachDataR, request: request, id: id)
    }
    
    @objc func locationEditBtnTapped(){
        guard let id = id else { return }
        coordinator?.gotoEditPropertyAddressView(beachData: beachDataR, request: request, id: id)
    }
    
    @objc func availabilityEditBtnTapped(){
        guard let id = id else { return }
        coordinator?.gotoEditPropertyAvailableDatesView(beachData: beachDataR, request: request, id: id)
    }
    
    @objc func amenitiesEditBtnTapped(){
        guard let id = id else { return }
        coordinator?.gotoEditPropertyAmenitiesView(beachData: beachDataR, request: request, id: id)
    }
    
    @objc func aboutListerEditBtnTapped(){
        guard let id = id else { return }
        coordinator?.gotoEditAboutYouLanguageView(beachData: beachDataR, request: request, id: id)
    }
    
    @objc func houseRulesEditBtnTapped(){
        guard let id = id else { return }
        coordinator?.gotoEditHouseRulesView(beachData: beachDataR, request: request, id: id)
    }
    
    @objc func houseDetailsEditBtnTapped(){
        guard let id = id else { return }
        coordinator?.gotoEditHouseDetailsView(beachData: beachDataR, request: request, id: id)
    }
    
    @objc func generalPropertyImagesBtnTapped(){
        guard let id = id else { return }
        coordinator?.gotoEditUploadImageView(beachData: beachDataR, request: request, currentImages: beachDetails?.images?.compactMap{$0.url } ?? [], id: id)
    }
    
    @objc func roomsAndPricingEditBtnTapped(){
        guard let id = id else { return }
        coordinator?.gotoEditRoomsListView(beachData: beachDataR, request: request, id: id, details: beachDetails)
    }
    
    @objc func listingPriceEditBtnTapped(){
        guard let id = id else { return }
        coordinator?.gotoEditEntireApartmentPriceView(beachData: beachDataR, request: request, id: id)
    }
    
    @objc func deletePropertyBtn(){
        guard let id = id else { return }
        LoadingModal.show()
        deleteVM.deleteBeach(id: id)

        // Listen to deleteOutput (already in bindNetwork)
        deleteVM.deleteBeachOutput.subscribe(onNext: { [weak self] response in
            LoadingModal.dismiss()
            switch response {
            case .deleteBeachSuccessful(let response):
                MiddleModal.show(title: response.message ?? "", type: .success, onConfirm: { self?.coordinator?.pop() })
                
            case .deleteBeachFailed(let error):
                Toast.show(message: error.message ?? "")
            }
        }).disposed(by: disposeBag)
    }
}

extension BeachRoom {
    func toRoom() -> Room {
        return Room(
            id: id,
            name: name,
            description: description,
            quantity: quantity,
            roomAmenities: [],
            pricePerNight: pricePerNight,
            discountPercent: Int(discountPercent ?? 0),
            pricePerDay: pricePerDay,
            dayDiscountPercent: Int(dayDiscountPercent ?? 0),
            bedTypes: bedTypes,
            hasPrivateBathroom: Int(hasPrivateBathroom ?? ""),
            noOfOccupant: Int(noOfOccupant ?? "")
        )
    }
}

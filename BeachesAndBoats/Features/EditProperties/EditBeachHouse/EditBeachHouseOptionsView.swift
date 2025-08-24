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
    @IBOutlet weak var listingPriceEditBtn: UILabel!
    
    
    let vm = BeachDataViewModel()
    let beachVM = BeachHouseVM()
    let disposeBag = DisposeBag()
    let beachInput = PublishSubject<BeachHouseVM.Input>()
    
    var beachDataR: BeachDatas?
    var beachDetails: GetBeachData?
    var request: CreateBeachListingRequest?
    var id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Edit Property"
        LoadingModal.show()
        vm.getBeachData()
        bindNetwork()
        setup()
        
        
        LoadingModal.show()
        beachInput.onNext(.getBeachHouse(id: id ?? ""))
    }

    func setup(){
        propertyNameLabel.text = beachDetails?.name
        let textsAndLabels: [(String, UILabel)] = [
            ("Property name and description", propertyNameEditBtn),
            ("Location", locationEditBtn),
            ("Availability" , availabilityEditBtn),
            ("Amenities and Services" , amenitiesEditBtn),
            ("About lister" , aboutListerEditBtn),
            ("House Rules" , houseRulesEditBtn),
            ("Rooms and Pricing" , roomsAndPricingEditBtn),
            ("Listing Price" , listingPriceEditBtn),
        ]
        gestureRecognizers()

        textsAndLabels.forEach { underlineText(text: $0.0, titleLabel: $0.1) }
        
        print(beachDetails)
        
        
        request = CreateBeachListingRequest(name: beachDetails?.name,
                                            description: beachDetails?.description,
                                            aboutOwner: beachDetails?.aboutOwner,
                                            checkInFrom: beachDetails?.checkInFrom,
                                            checkInTo: beachDetails?.checkInTo,
                                            checkOutFrom: beachDetails?.checkOutFrom,
                                            checkOutTo: beachDetails?.checkOutTo,
                                            categoryId: beachDetails?.category?.id,
                                            subCategoryId: beachDetails?.subCategory?.id,
                                            bookingType: beachDetails?.bookingType,
                                            country: beachDetails?.locations?.country,
                                            state: beachDetails?.locations?.state,
                                            streetName: beachDetails?.locations?.streetName,
                                            city: beachDetails?.locations?.city,
                                            latitude: Double(beachDetails?.locations?.latitude ?? "0"),
                                            longitude: Double(beachDetails?.locations?.longitude ?? "0"),
                                            availableFrom: beachDetails?.availabilities?.availableFrom,
                                            availableTo: beachDetails?.availabilities?.availableTo,
                                            amenities: beachDetails?.amenities?.compactMap{ $0.id },
                                            languages: beachDetails?.languages?.compactMap{ $0.id },
                                            houseRules: beachDetails?.houseRules?.compactMap{ $0.id },
                                            rooms: beachDetails?.rooms?.map { $0.toRoom() },
                                            roleType: beachDetails?.owner?.roles?.first,
                                            listingPrice: beachDetails?.listingPrice,
                                            discountPercent: beachDetails?.discountPercent ?? 0,
                                            pricePerDay: beachDetails?.pricePerDay,
                                            dayDiscountPercent: beachDetails?.dayDiscountPercent ?? 0 )

    }
    
    func gestureRecognizers() {
        propertyNameEditBtn.isUserInteractionEnabled = true
        locationEditBtn.isUserInteractionEnabled = true
        availabilityEditBtn.isUserInteractionEnabled = true
        amenitiesEditBtn.isUserInteractionEnabled = true
        aboutListerEditBtn.isUserInteractionEnabled = true
        houseRulesEditBtn.isUserInteractionEnabled = true
        roomsAndPricingEditBtn.isUserInteractionEnabled = true
        listingPriceEditBtn.isUserInteractionEnabled = true
        
        let gestures: [(UILabel, Selector)] = [
            (propertyNameEditBtn, #selector(propertyNameEditBtnTapped)),
            (locationEditBtn, #selector(locationEditBtnTapped)),
            (availabilityEditBtn, #selector(availabilityEditBtnTapped)),
            (amenitiesEditBtn, #selector(amenitiesEditBtnTapped)),
            (aboutListerEditBtn, #selector(aboutListerEditBtnTapped)),
            (houseRulesEditBtn, #selector(houseRulesEditBtnTapped)),
            (roomsAndPricingEditBtn, #selector(roomsAndPricingEditBtnTapped)),
            (listingPriceEditBtn, #selector(listingPriceEditBtnTapped))
        ]
        
        for (label, selector) in gestures {
            GestureRecognizerHelper.addTapGestureToLabel(to: label, target: self, action: selector)
        }
    }

    func bindNetwork(){
        beachVM.transform(input: beachInput)
        
        vm.output.subscribe(onNext: { [weak self] response in
            LoadingModal.dismiss()
            
            switch response {
            case .getBeachDataSuccess(let response):
                self?.beachDataR = response.data
            case .getBeachDataError(let error):
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
        coordinator?.gotoEditPropertyNameView(beachData: beachDataR, request: request)
    }
    
    @objc func locationEditBtnTapped(){
        coordinator?.gotoEditPropertyAddressView(beachData: beachDataR, request: request)
    }
    
    @objc func availabilityEditBtnTapped(){
        coordinator?.gotoEditPropertyAvailableDatesView(beachData: beachDataR, request: request)
    }
    
    @objc func amenitiesEditBtnTapped(){
        coordinator?.gotoEditPropertyAmenitiesView(beachData: beachDataR, request: request)
    }
    
    @objc func aboutListerEditBtnTapped(){
        coordinator?.gotoEditAboutYouLanguageView(beachData: beachDataR, request: request)
    }
    
    @objc func houseRulesEditBtnTapped(){
        coordinator?.gotoEditHouseRulesView(beachData: beachDataR, request: request)
    }
    
    @objc func roomsAndPricingEditBtnTapped(){
        coordinator?.gotoEditRoomsListView(beachData: beachDataR, request: request)
    }
    
    @objc func listingPriceEditBtnTapped(){
        coordinator?.gotoEditEntireApartmentPriceView(beachData: beachDataR, request: request)
    }
}

extension BeachRoom {
    func toRoom() -> Room {
        return Room(
            name: name,
            description: description,
            quantity: quantity,
            roomAmenities: [],
            pricePerNight: pricePerNight,
            discountPercent: discountPercent ?? 0,
            pricePerDay: pricePerDay,
            dayDiscountPercent: dayDiscountPercent ?? 0,
            bedTypes: bedTypes,
            hasPrivateBathroom: Int(hasPrivateBathroom ?? ""),
            noOfOccupant: Int(noOfOccupant ?? ""),
            images: nil
        )
    }
}

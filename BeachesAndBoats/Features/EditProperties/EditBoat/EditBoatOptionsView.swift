//
//  EditBoatOptionsView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/09/2025.
//

import UIKit
import RxSwift

class EditBoatOptionsView: BaseViewControllerPlain {
    
    
    var coordinator: HostingServiceMenuCoordinator?

    @IBOutlet weak var propertyNameLabel: UILabel!
    @IBOutlet weak var boatTypeEditBtn: UILabel!
    @IBOutlet weak var boatNameEditBtn: UILabel!
    @IBOutlet weak var locationEditBtn: UILabel!
    @IBOutlet weak var availabilityEditBtn: UILabel!
    @IBOutlet weak var amenitiesEditBtn: UILabel!
    @IBOutlet weak var aboutListerEditBtn: UILabel!
    @IBOutlet weak var boatRulesEditBtn: UILabel!
    @IBOutlet weak var boatDestinationPriceEditBtn: UILabel!
    @IBOutlet weak var boatImagesEditBtn: UILabel!
    @IBOutlet weak var deletepropertyBtn: UILabel!
    
    
    let vm = BoatDataViewModel()
    let boatVM = BoatVM()
    let deleteVM = EditBoatViewModel()
    let disposeBag = DisposeBag()
    let boatInput = PublishSubject<BoatVM.Input>()
    
    var boatDataR: BoatDatas?
    var boatDetails: GetBoatData?
    var request: CreateBoatListingRequest?
    var id: String?
    
    // Flag to track if boatData has been loaded
    private var hasLoadedBoatData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Edit Property"
        
        bindNetwork()
        
        if !hasLoadedBoatData {
            LoadingModal.show()
            vm.getBoatData()
        } else {
            fetchBoatDetails()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if hasLoadedBoatData {
            fetchBoatDetails()
        }
    }
    
    func fetchBoatDetails(){
        LoadingModal.show()
        boatInput.onNext(.getBoat(id: id ?? ""))
    }

    func setup(){
        propertyNameLabel.text = boatDetails?.name
        let textsAndLabels: [(String, UILabel)] = [
            ("Type of boat", boatTypeEditBtn),
            ("Name and description of boat", boatNameEditBtn),
            ("Location", locationEditBtn),
            ("Availability" , availabilityEditBtn),
            ("Amenities and Features" , amenitiesEditBtn),
            ("About lister" , aboutListerEditBtn),
            ("Boat rules" , boatRulesEditBtn),
            ("Boat destination and pricing" , boatDestinationPriceEditBtn),
            ("Boat Images", boatImagesEditBtn),
            ("Delete Property", deletepropertyBtn)
        ]
        gestureRecognizers()

        textsAndLabels.forEach { underlineText(text: $0.0, titleLabel: $0.1) }
        
        
        request = CreateBoatListingRequest(name: boatDetails?.name,
                                           description: boatDetails?.description,
                                           aboutOwner: boatDetails?.aboutOwner,
                                           noOfPassengers: Int(boatDetails?.noOfPassengers ?? "0"),
                                           subCategoryId: boatDetails?.subCategory?.id,
                                           jettyLocation: boatDetails?.locations?.jettyLocation,
                                           locationName: boatDetails?.locations?.name,
                                           availableFrom: boatDetails?.availabilities?.availableFrom,
                                           availableTo: boatDetails?.availabilities?.availableTo,
                                           amenities: boatDetails?.amenities?.compactMap{ $0.id },
                                           languages: boatDetails?.languages?.compactMap{ $0.id },
                                           houseRules: boatDetails?.houseRules?.compactMap{ $0.id },
                                           destinations: boatDetails?.destinations?.compactMap { $0.toCreateDestination() }
                                    )

    }
    
    
    func gestureRecognizers() {
        boatTypeEditBtn.isUserInteractionEnabled = true
        boatNameEditBtn.isUserInteractionEnabled = true
        locationEditBtn.isUserInteractionEnabled = true
        availabilityEditBtn.isUserInteractionEnabled = true
        amenitiesEditBtn.isUserInteractionEnabled = true
        aboutListerEditBtn.isUserInteractionEnabled = true
        boatRulesEditBtn.isUserInteractionEnabled = true
        boatDestinationPriceEditBtn.isUserInteractionEnabled = true
        boatImagesEditBtn.isUserInteractionEnabled = true
        deletepropertyBtn.isUserInteractionEnabled = true
        
        let gestures: [(UILabel, Selector)] = [
            (boatTypeEditBtn, #selector(boatTypeEditBtnTapped)),
            (boatNameEditBtn, #selector(boatNameEditBtnTapped)),
            (locationEditBtn, #selector(locationEditBtnTapped)),
            (availabilityEditBtn, #selector(availabilityEditBtnTapped)),
            (amenitiesEditBtn, #selector(amenitiesEditBtnTapped)),
            (aboutListerEditBtn, #selector(aboutListerEditBtnTapped)),
            (boatRulesEditBtn, #selector(houseRulesEditBtnTapped)),
            (boatDestinationPriceEditBtn, #selector(roomsAndPricingEditBtnTapped)),
            (boatImagesEditBtn, #selector(boatImagesEditBtnTapped)),
            (deletepropertyBtn, #selector(deletePropertyBtnTapped))
        ]
        
        for (label, selector) in gestures {
            GestureRecognizerHelper.addTapGestureToLabel(to: label, target: self, action: selector)
        }
    }

    func bindNetwork(){
        boatVM.transform(input: boatInput)
        
        vm.output.subscribe(onNext: { [weak self] response in
            
            switch response {
            case .getBoatDataSuccess(let response):
                self?.boatDataR = response.data
                self?.hasLoadedBoatData = true // Mark as loaded
                self?.fetchBoatDetails()
            case .getBoatDataError(let error):
                LoadingModal.dismiss()
                MiddleModal.show(title: error.message ?? "", type: .error, onConfirm: { self?.coordinator?.pop() })
            }
            
        }).disposed(by: disposeBag)
        
        
        boatVM.output.subscribe(onNext: { [weak self] data in
            LoadingModal.dismiss()
            switch data {
            case .getBoatSuccess(let response):
                self?.boatDetails = response.data
//                print("Details: \(self?.beachDetails)")
                self?.setup()
                
            case .getBoatFailed(let error) :
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
    
    @objc func boatTypeEditBtnTapped(){
        print(boatDataR)
        print(request)
        guard let id = id else { return }
        coordinator?.gotoEditBoatTypeView(boatData: boatDataR, request: request, id: id, boatType: boatDetails?.subCategory?.name)
    }
    
    @objc func boatNameEditBtnTapped(){
        guard let id = id else { return }
        coordinator?.gotoEditBoatNameView(boatData: boatDataR, request: request, id: id, boatType: boatDetails?.subCategory?.name)
    }
    
    @objc func locationEditBtnTapped(){
        guard let id = id else { return }
        coordinator?.gotoEditBoatAddressView(boatData: boatDataR, request: request, id: id, boatType: boatDetails?.subCategory?.name)
    }
    
    @objc func availabilityEditBtnTapped(){
        guard let id = id else { return }
        coordinator?.gotoEditBoatAvailableDatesView(boatData: boatDataR, request: request, id: id, boatType: boatDetails?.subCategory?.name)
    }
    
    @objc func amenitiesEditBtnTapped(){
        guard let id = id else { return }
        coordinator?.gotoEditBoatFacilitiesView(boatData: boatDataR, request: request, id: id, boatType: boatDetails?.subCategory?.name)
    }
    
    @objc func aboutListerEditBtnTapped(){
        guard let id = id else { return }
        coordinator?.gotoEditBoatAboutYouDescriptionView(boatData: boatDataR, request: request, id: id, boatType: boatDetails?.subCategory?.name)
    }
    
    @objc func houseRulesEditBtnTapped(){
        guard let id = id else { return }
        coordinator?.gotoEditBoatRulesView(boatData: boatDataR, request: request, id: id, boatType: boatDetails?.subCategory?.name)
    }
    
    @objc func roomsAndPricingEditBtnTapped(){
        guard let id = id else { return }
        coordinator?.gotoEditBoatTravelLocationView(boatData: boatDataR, request: request, id: id, boatType: boatDetails?.subCategory?.name)
    }
    
    @objc func boatImagesEditBtnTapped(){
        guard let id = id else { return }
        coordinator?.gotoEditBoatUploadImageView(boatData: boatDataR, request: request, id: id, details: boatDetails, boatType: boatDetails?.subCategory?.name)
    }
    
    @objc func deletePropertyBtnTapped(){
        guard let id = id else { return }
        LoadingModal.show()
        deleteVM.deleteBoat(id: id)

        // Listen to deleteOutput (already in bindNetwork)
        deleteVM.deleteBoatOutput.subscribe(onNext: { [weak self] response in
            LoadingModal.dismiss()
            switch response {
            case .deleteBoatSuccessful(let response):
                MiddleModal.show(title: response.message ?? "", type: .success, onConfirm: { self?.coordinator?.pop() })
                
            case .deleteBoatFailed(let error):
                Toast.show(message: error.message ?? "")
            }
        }).disposed(by: disposeBag)
    }
}

extension Destination {
    func toCreateDestination() -> CreateDestination? {
        guard let price = price,
              let priceValue = Float(price) else {
            return nil
        }
        return CreateDestination(
            destinationId: id,
            pricePerHour: priceValue
        )
    }
}

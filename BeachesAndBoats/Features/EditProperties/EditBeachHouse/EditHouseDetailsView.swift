//
//  EditHouseDetailsView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/09/2025.
//

import UIKit
import RxSwift

class EditHouseDetailsView: BaseViewControllerPlain {
    var coordinator: HostingServiceMenuCoordinator?
    
    @IBOutlet weak var noOfRooms : IncreaseDecreaseField!
    @IBOutlet weak var noOfGuests : IncreaseDecreaseField!
    @IBOutlet weak var noOfBeds : IncreaseDecreaseField!
    @IBOutlet weak var noOfBathrooms : IncreaseDecreaseField!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    var details: GetBeachData?
    
    var id: String?
    
    var disposeBag = DisposeBag()
    var vm = EditBeachViewModel()
    
//    var houseRulesList: [HouseRule]?
    var selectedItems: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beach Houses"
        
        bindNetwork()
        setup()
    }
    
    
    func setup(){
        
        // Set initial counts from saved data or default to 0
        let roomsCount = details?.noOfRooms ?? 1
        let guestsCount = details?.noOfGuests ?? 1
        let bedsCount = details?.noOfBeds ?? 1
        let bathroomsCount = details?.noOfBathrooms ?? 1
        
        noOfRooms.model = IncreaseDecreaseModel(id: "", type: "Number of rooms", subtitle: "", count: roomsCount)
        noOfGuests.model = IncreaseDecreaseModel(id: "", type: "Number of guest allowed", subtitle: "", count: guestsCount)
        noOfBeds.model = IncreaseDecreaseModel(id: "", type: "Number of beds", subtitle: "", count: bedsCount)
        noOfBathrooms.model = IncreaseDecreaseModel(id: "", type: "Number of bathrooms", subtitle: "", count: bathroomsCount)
        
        
    }
    
    
    @IBAction func saveAndExit(_ sender: Any) {
        guard let id = id else { return }
        
//        if let beachData = beachData{
        if createBeachListing == nil{
            createBeachListing = CreateBeachListingRequest()
        }
                createBeachListing?.noOfRooms = noOfRooms.count
                createBeachListing?.noOfGuests = noOfGuests.count
                createBeachListing?.noOfBeds = noOfBeds.count
                createBeachListing?.noOfBathrooms = noOfBathrooms.count
                print(createBeachListing)
                
                guard noOfRooms.count > 0 && noOfGuests.count > 0 && noOfBeds.count > 0 && noOfBathrooms.count > 0 else {
                    Toast.show(message: "Please select at least one item for each.")
                    return
                }
                
                print(createBeachListing)
                
            if let createBeachListing = createBeachListing{
                LoadingModal.show(title: "Updating Record...")
                vm.editBeach(createBeachListing, id: id)
            }
//        }
    }
    
    func bindNetwork(){
        vm.output.subscribe(onNext: {[weak self] response in
            LoadingModal.dismiss()
            
            switch response {
            case .editBeachSuccessful(let response):
                print(response)
                MiddleModal.show(title: response.message ?? "", type: .success, onConfirm: { self?.coordinator?.popToOptionsScreen() })
                
            case .editBeachFailed(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
            
        }).disposed(by: disposeBag)
    }
}

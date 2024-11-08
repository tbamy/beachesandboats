//
//  ListRoomsView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 02/10/2024.
//

import UIKit

class ListRoomsView: BaseViewControllerPlain {
    
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var nextBtn: PrimaryButton!
    @IBOutlet weak var roomName: InputField!
    @IBOutlet weak var roomDescription: TextViewField!
    @IBOutlet weak var roomCount: NumberField!
    @IBOutlet weak var sofaBedView: IncreaseDecreaseField!
    @IBOutlet weak var bunkBedView: IncreaseDecreaseField!
    @IBOutlet weak var singleBedView: IncreaseDecreaseField!
    @IBOutlet weak var queensBendView: IncreaseDecreaseField!
    @IBOutlet weak var kingsBedView: IncreaseDecreaseField!
    
//    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var peopleCount: NumberField!
    @IBOutlet weak var privateRoomYes: CheckboxButton!
    @IBOutlet weak var privateRoomNo: CheckboxButton!
    
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    
    var bedTypes: [IncreaseDecreaseModel] = []
    var privateStatus: Bool?
    
    var allRoomData : [RoomData] = []
    var currentRoomIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beaches Houses"
        
        setup()
        
    }
    
    func setup(){
        stepOneProgress.setProgress(1, animated: false)
        stepOneProgress.tintColor = .success
        stepTwoProgress.setProgress(0.1, animated: true)
        stepTwoProgress.tintColor = .B_B
        
        privateRoomNo.isUserInteractionEnabled = true
        privateRoomYes.isUserInteractionEnabled = true
        
        privateRoomNo.stateChanged = { [weak self] isSelected in
            guard let self = self else { return }
            self.privateStatus = isSelected
            privateRoomYes.isChecked = false
        }
        
        privateRoomYes.stateChanged = { [weak self] isSelected in
            guard let self = self else { return }
            self.privateStatus = isSelected
            privateRoomNo.isChecked = false
        }



        setupBedTypes()
        
      
        
    }
    
    func setupBedTypes() {
        sofaBedView.model = IncreaseDecreaseModel(type: "Sofa Bed", subtitle: "No Specific size", count: 0)
        bunkBedView.model = IncreaseDecreaseModel(type: "Bunk Bed", subtitle: "No Specific size", count: 0)
        singleBedView.model = IncreaseDecreaseModel(type: "Single Bed", subtitle: "90 - 130 cm wide", count: 0)
        queensBendView.model = IncreaseDecreaseModel(type: "Queens Bed", subtitle: "131 - 150 cm wide", count: 0)
        kingsBedView.model = IncreaseDecreaseModel(type: "King Size Bed", subtitle: "151 - 180 cm wide", count: 0)
    }


    
    @IBAction func nextTapped(_ sender: Any) {
        if let beachData = beachData{
            let roomId = allRoomData.count
            let newRoomData = RoomData(id: roomId, name: roomName.text, description: roomDescription.text, amenities: [], price_per_night: 0, discount: 0, amount_to_earn: 0, room_images: [], number_of_guests: "", number_of_rooms: "", number_of_beds: "")
            
            allRoomData.append(newRoomData)
                
            let request = CreateBeachListingRequest(category_id: createBeachListing?.category_id ?? "", sub_cat_id: createBeachListing?.sub_cat_id ?? "", guest_booking_id: createBeachListing?.guest_booking_id ?? "", name: createBeachListing?.name ?? "", description: createBeachListing?.description ?? "", country: createBeachListing?.country ?? "", state: createBeachListing?.state ?? "", city: createBeachListing?.city ?? "", street_address: createBeachListing?.street_address ?? "", from_when: "", to_when: "", amenities: createBeachListing?.amenities ?? [], preferred_languages: createBeachListing?.preferred_languages ?? [], brief_introduction: createBeachListing?.brief_introduction ?? "", house_rules: createBeachListing?.house_rules ?? [], check_in_start: createBeachListing?.check_in_start ?? "", check_in_end: createBeachListing?.check_in_end ?? "", check_out_start: createBeachListing?.check_out_start ?? "", check_out_end: createBeachListing?.check_out_end ?? "", roominfo: allRoomData, full_apartment_cost: 0, full_apartment_discount: 0, full_apartment_amount_to_earn: 0)
            
            coordinator?.gotoRoomAmenitiesView(beachData: beachData, createBeachListingData: request)
        }
    }

}


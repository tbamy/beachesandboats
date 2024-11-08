//
//  CheckInAndOutRulesView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/10/2024.
//

import UIKit

class CheckInAndOutRulesView: BaseViewControllerPlain {
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var nextBtn: PrimaryButton!
    @IBOutlet weak var checkInFrom: TimePicker!
    @IBOutlet weak var checkInUntil: TimePicker!
    @IBOutlet weak var checkOutFrom: TimePicker!
    @IBOutlet weak var checkOutUntil: TimePicker!
    
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beaches Houses"
        
        setup()
    }

    func setup(){
        stepOneProgress.setProgress(1, animated: true)
        stepOneProgress.tintColor = .B_B
        stepTwoProgress.setProgress(0, animated: false)
        
        
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        if let beachData = beachData{
            let request = CreateBeachListingRequest(category_id: createBeachListing?.category_id ?? "", sub_cat_id: createBeachListing?.sub_cat_id ?? "", guest_booking_id: createBeachListing?.guest_booking_id ?? "", name: createBeachListing?.name ?? "", description: createBeachListing?.description ?? "", country: createBeachListing?.country ?? "", state: createBeachListing?.state ?? "", city: createBeachListing?.city ?? "", street_address: createBeachListing?.street_address ?? "", from_when: "", to_when: "", amenities: createBeachListing?.amenities ?? [], preferred_languages: createBeachListing?.preferred_languages ?? [], brief_introduction: createBeachListing?.brief_introduction ?? "", house_rules: createBeachListing?.house_rules ?? [], check_in_start: checkInFrom.text, check_in_end: checkInUntil.text, check_out_start: checkOutFrom.text, check_out_end: checkOutUntil.text, roominfo: [], full_apartment_cost: 0, full_apartment_discount: 0, full_apartment_amount_to_earn: 0)
            
            coordinator?.gotoListRoomsView(beachData: beachData, createBeachListingData: request)
        }
    }

}

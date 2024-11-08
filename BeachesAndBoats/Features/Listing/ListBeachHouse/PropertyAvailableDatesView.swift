//
//  PropertyAvailableDatesView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/10/2024.
//

import UIKit

class PropertyAvailableDatesView: BaseViewControllerPlain {
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var calendarView: HorizonCalendar!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    var selectedItems: [String] = []
    
    var from_when: Date?
    var to_when: Date?
    
    var currentDate = Date()
    
    var amenitiesList: [Amenity]?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beaches Houses"
        setup()
    }
    
    func setup(){
        stepOneProgress.setProgress(0.60, animated: true)
        stepOneProgress.tintColor = .B_B
        stepTwoProgress.setProgress(0, animated: false)
        
        calendarView.onDateSelected = { startDate, endDate in
            
            self.from_when = startDate
            if let endDate = endDate {
                self.to_when = endDate
            }
        }
        
        if (from_when ?? Date() < currentDate) || (to_when ?? Date() < currentDate){
            nextBtn.isEnabled = false
        }else{
            nextBtn.isEnabled = true
        }
            
        
    }

    @IBAction func nextTapped(_ sender: Any) {
        if let beachData = beachData{
            let request = CreateBeachListingRequest(category_id: createBeachListing?.category_id ?? "", sub_cat_id: createBeachListing?.sub_cat_id ?? "", guest_booking_id: createBeachListing?.guest_booking_id ?? "", name: createBeachListing?.name ?? "", description: createBeachListing?.description ?? "", country: createBeachListing?.country ?? "", state: createBeachListing?.state ?? "", city: createBeachListing?.city ?? "", street_address: createBeachListing?.street_address ?? "", from_when: from_when?.toFormattedDate() ?? "", to_when: to_when?.toFormattedDate() ?? "", amenities: selectedItems, preferred_languages: [""], brief_introduction: "", house_rules: [], check_in_start: "", check_in_end: "", check_out_start: "", check_out_end: "", roominfo: [], full_apartment_cost: 0, full_apartment_discount: 0, full_apartment_amount_to_earn: 0)
            
            coordinator?.gotoPropertyAmenitiesView(beachData: beachData, createBeachListingData: request)
        }
    }
    

}

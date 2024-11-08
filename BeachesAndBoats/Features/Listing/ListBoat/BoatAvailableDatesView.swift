//
//  BoatAvailableDatesView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 06/11/2024.
//

import UIKit

class BoatAvailableDatesView: BaseViewControllerPlain {
    
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var calendarView: HorizonCalendar!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var boatData: BoatDatas?
    var createBoatListing: CreateBoatListingRequest?
    var boatType: String?
    
    var from_when: Date?
    var to_when: Date?
    
    var currentDate = Date()
    
    var amenitiesList: [Amenity]?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Boats"
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
        if let boatData = boatData{
            let request = CreateBoatListingRequest(type: createBoatListing?.type ?? [], name: createBoatListing?.name ?? "", description: createBoatListing?.description ?? "", from_when: from_when?.toBackendDateAlone() ?? "", to_when: to_when?.toBackendDateAlone() ?? "", amenities: [], preferred_languages: [], brief_introduction: "", rules: [], no_of_adults: 0, no_of_children: 0, no_of_pets: 0, country: "", state: "", city: "", street_address: "", destinations_prices: [], images: [])
            
            coordinator?.gotoBoatFacilitiesView(boatData: boatData, createBoatListingData: request, boatType: boatType ?? "")
        }
    }
    

}

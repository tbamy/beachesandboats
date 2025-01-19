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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beaches Houses"
        setup()
    }
    
    func setup(){
        stepOneProgress.setProgress(0.60, animated: true)
        stepOneProgress.tintColor = .B_B
        stepTwoProgress.setProgress(0, animated: false)
        
        calendarView.onDatesSelected = { startDate, endDate in
            
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
            if var createBeachListing = createBeachListing{
                createBeachListing.availableFrom = from_when?.toBackendDate() ?? ""
                createBeachListing.availableTo = to_when?.toBackendDate() ?? ""
                print(createBeachListing)
                
                coordinator?.gotoPropertyAmenitiesView(beachData: beachData, createBeachListingData: createBeachListing)
            }
            
        }
    }
    
    
    @IBAction func saveAndExit(_ sender: Any) {
        if var createBeachListing = createBeachListing{
            createBeachListing.availableFrom = from_when?.toBackendDate() ?? ""
            createBeachListing.availableTo = to_when?.toBackendDate() ?? ""
            
            AppStorage.beachListing = createBeachListing
            coordinator?.backToDashboard()
        }

    }
    

}

//
//  DJAvailableDatesView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/11/2024.
//

import UIKit

class DJAvailableDatesView: BaseViewControllerPlain {
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var calendarView: HorizonCalendar!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var createServiceListing: CreateServiceListingRequest?
    
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
        if var createServiceListing = createServiceListing{
            createServiceListing.availableFrom = from_when?.toBackendDateAlone() ?? ""
            createServiceListing.availableTo = to_when?.toBackendDateAlone() ?? ""
            
            print(createServiceListing)
            
            coordinator?.gotoDJPriceViewView(createServiceListingData: createServiceListing)
        }
        
    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        if var createServiceListing = createServiceListing{
            createServiceListing.availableFrom = from_when?.toBackendDateAlone() ?? ""
            createServiceListing.availableTo = to_when?.toBackendDateAlone() ?? ""
            
            AppStorage.serviceListing = createServiceListing
            coordinator?.backToDashboard()
        }
        
    }
    

}

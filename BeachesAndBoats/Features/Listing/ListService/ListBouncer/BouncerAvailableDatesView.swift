//
//  BouncerAvailableDatesView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/11/2024.
//

import UIKit

class BouncerAvailableDatesView: BaseViewControllerPlain {
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var calendarView: HorizonCalendar!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var createServiceListing: CreateServiceListingRequest?
    
    var from_when: Date?
    var to_when: Date?
    
    var currentDate = Date()
    
    var amenitiesList: [Amenity]?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bouncers"
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
        let request = CreateServiceListingRequest(name: createServiceListing?.name ?? "", description: createServiceListing?.description ?? "", profile_image: createServiceListing?.profile_image ?? Data(), from_when: from_when?.toBackendDateAlone() ?? "", to_when: to_when?.toBackendDateAlone() ?? "", dishes: [], price: 0, sample_images: [], type: "", gender: createServiceListing?.gender ?? "")
        coordinator?.gotoBouncerPriceView(createServiceListingData: request)
    }
    

}

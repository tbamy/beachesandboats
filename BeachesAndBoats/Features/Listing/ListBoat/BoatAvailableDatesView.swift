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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Boats"
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
            
            self.nextBtn.isEnabled = true
        }
        
//        loadSavedDates()
        
//        if (from_when ?? Date() < currentDate) || (to_when ?? Date() < currentDate){
//            nextBtn.isEnabled = false
//        }else{
//            nextBtn.isEnabled = true
//        }
            
        
    }
    
//    private func checkAndLoadSavedListing() {
//        if let savedListing = AppStorage.boatListing {
//            print("=== LOADING SAVED BOAT LISTING ===")
//            print("Available from: \(savedListing.availableFrom ?? "No start date")")
//            print("Available to: \(savedListing.availableTo ?? "No end date")")
//            
//            // Use the saved listing
//            createBoatListing = savedListing
//            
//            // Convert saved dates back to Date objects
//            if let fromDateString = savedListing.availableFrom, !fromDateString.isEmpty {
//                from_when = Date.fromBackendDate(fromDateString)
//            }
//            if let toDateString = savedListing.availableTo, !toDateString.isEmpty {
//                to_when = Date.fromBackendDate(toDateString)
//            }
//            
//            print("Loaded saved boat listing successfully")
//            print("===============================")
//        } else {
//            print("No saved boat listing found, starting fresh")
//        }
//    }
//    
//    private func loadSavedDates() {
//        // Set calendar with saved dates if available
//        if let fromDate = from_when, let toDate = to_when {
//            calendarView.setSelectedDates(startDate: fromDate, endDate: toDate)
//            nextBtn.isEnabled = true
//        }
//    }


    @IBAction func nextTapped(_ sender: Any) {
        if let boatData = boatData{
            if var createBoatListing = createBoatListing{
                createBoatListing.availableFrom = from_when?.toBackendDate() ?? ""
                createBoatListing.availableTo = to_when?.toBackendDate() ?? ""
                
                print(createBoatListing)
                
                coordinator?.gotoBoatFacilitiesView(boatData: boatData, createBoatListingData: createBoatListing, boatType: boatType ?? "")
            }
            
        }
    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        if var createBoatListing = createBoatListing{
            createBoatListing.availableFrom = from_when?.toBackendDate() ?? ""
            createBoatListing.availableTo = to_when?.toBackendDate() ?? ""
            
            print(createBoatListing)
            
            AppStorage.boatListing = createBoatListing
            coordinator?.backToDashboard()
        }
        
    }
    

}

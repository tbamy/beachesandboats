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
    @IBOutlet weak var overnightCheckIn: TimePicker!
    @IBOutlet weak var overnightCheckOut: TimePicker!
    @IBOutlet weak var dayCheckIn: TimePicker!
    @IBOutlet weak var dayCheckOut: TimePicker!
    
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beach Houses"
        
        setup()
    }

    func setup(){
        stepOneProgress.setProgress(1, animated: true)
        stepOneProgress.tintColor = .B_B
        stepTwoProgress.setProgress(0, animated: false)
        
        loadSavedData()
    }

    @IBAction func nextTapped(_ sender: Any) {
        guard
            let overnightCheckInTime = overnightCheckIn.selectedTime,
            let overnightCheckOutTime = overnightCheckOut.selectedTime,
            let dayCheckInTime = dayCheckIn.selectedTime,
            let dayCheckOutTime = dayCheckOut.selectedTime
        else {
            MiddleModal.show(
                title: "Incomplete Times",
                subtitle: "Please make sure to select all check-in and check-out time slots before proceeding.",
                type: .error,
                dismissable: true,
                dismissOnConfirm: true
            )
            return
        }

        if overnightCheckOutTime <= overnightCheckInTime {
            MiddleModal.show(
                title: "Overnight Booking Time Mismatch",
                subtitle: "The check-out time must be after the check-in time.",
                type: .error,
                dismissable: true,
                dismissOnConfirm: true
            )
            return
        }

        if dayCheckOutTime <= dayCheckInTime {
            MiddleModal.show(
                title: "Day Booking Time Mismatch",
                subtitle: "The check-out time must be after the check-in time.",
                type: .error,
                dismissable: true,
                dismissOnConfirm: true
            )
            return
        }

        // All checks passed
        if let beachData = beachData, var createBeachListing = createBeachListing {
            createBeachListing.overnightCheckIn = overnightCheckIn.text
            createBeachListing.overnightCheckOut = overnightCheckOut.text
            createBeachListing.dayCheckIn = dayCheckIn.text
            createBeachListing.dayCheckOut = dayCheckOut.text

            print(createBeachListing)
            if createBeachListing.bookingType == "FULL" {
                coordinator?.gotoPropertyDetailsView(beachData: beachData, createBeachListingData: createBeachListing)
            }else {
                coordinator?.gotoListRoomsView(beachData: beachData, createBeachListingData: createBeachListing)
            }
        }
    }

    
    
    @IBAction func saveAndExit(_ sender: Any) {
        if var createBeachListing = createBeachListing{
            createBeachListing.overnightCheckIn = overnightCheckIn.text
            createBeachListing.overnightCheckOut = overnightCheckOut.text
            createBeachListing.dayCheckIn = dayCheckIn.text
            createBeachListing.dayCheckOut = dayCheckOut.text
            
            AppStorage.beachListing = createBeachListing
            coordinator?.backToDashboard()
        }

    }


}


extension CheckInAndOutRulesView {
    func loadSavedData() {
        guard let savedListing = AppStorage.beachListing else { return }
        
        // Populate check-in and check-out times
        if let overnightCheckInTime = savedListing.overnightCheckIn, !overnightCheckInTime.isEmpty {
            overnightCheckIn.text = overnightCheckInTime
        }
        
        if let overnightCheckOutTime = savedListing.overnightCheckOut, !overnightCheckOutTime.isEmpty {
            overnightCheckOut.text = overnightCheckOutTime
        }
        
        if let dayCheckInTime = savedListing.dayCheckIn, !dayCheckInTime.isEmpty {
            dayCheckIn.text = dayCheckInTime
        }
        
        if let dayCheckOutTime = savedListing.dayCheckOut, !dayCheckOutTime.isEmpty {
            dayCheckOut.text = dayCheckOutTime
        }
        
        // Enable next button if all required times are set
        let hasAllTimes = !overnightCheckIn.text.isEmpty &&
                         !overnightCheckOut.text.isEmpty &&
                         !dayCheckIn.text.isEmpty &&
                         !dayCheckOut.text.isEmpty
        nextBtn.isEnabled = hasAllTimes
    }
}

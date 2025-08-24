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
        title = "Beach Houses"
        
        setup()
    }

    func setup(){
        stepOneProgress.setProgress(1, animated: true)
        stepOneProgress.tintColor = .B_B
        stepTwoProgress.setProgress(0, animated: false)
        
        
    }

    @IBAction func nextTapped(_ sender: Any) {
        guard
            let checkInFromTime = checkInFrom.selectedTime,
            let checkInUntilTime = checkInUntil.selectedTime,
            let checkOutFromTime = checkOutFrom.selectedTime,
            let checkOutUntilTime = checkOutUntil.selectedTime
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

        // Validation 1: Check-in range
        if checkInUntilTime <= checkInFromTime {
            MiddleModal.show(
                title: "Check-In Time Mismatch",
                subtitle: "The latest check-in time must be after the earliest check-in time.",
                type: .error,
                dismissable: true,
                dismissOnConfirm: true
            )
            return
        }

        // Validation 2: Check-out cannot start before check-in ends
        if checkOutFromTime <= checkInUntilTime {
            MiddleModal.show(
                title: "Check-Out Too Early",
                subtitle: "Check-out should start after check-in ends. Please adjust the times accordingly.",
                type: .error,
                dismissable: true,
                dismissOnConfirm: true
            )
            return
        }

        // Validation 3: Check-out range
        if checkOutUntilTime <= checkOutFromTime {
            MiddleModal.show(
                title: "Check-Out Time Mismatch",
                subtitle: "The latest check-out time must be after the earliest check-out time.",
                type: .error,
                dismissable: true,
                dismissOnConfirm: true
            )
            return
        }

        // All checks passed
        if let beachData = beachData, var createBeachListing = createBeachListing {
            createBeachListing.checkInFrom = checkInFrom.text
            createBeachListing.checkInTo = checkInUntil.text
            createBeachListing.checkOutFrom = checkOutFrom.text
            createBeachListing.checkOutTo = checkOutUntil.text

            print(createBeachListing)
            coordinator?.gotoListRoomsView(beachData: beachData, createBeachListingData: createBeachListing)
        }
    }

    
    
    @IBAction func saveAndExit(_ sender: Any) {
        if var createBeachListing = createBeachListing{
            createBeachListing.checkInFrom = checkInFrom.text
            createBeachListing.checkInTo = checkInUntil.text
            createBeachListing.checkOutFrom = checkOutFrom.text
            createBeachListing.checkOutTo = checkOutUntil.text
            
            AppStorage.beachListing = createBeachListing
            coordinator?.backToDashboard()
        }

    }


}

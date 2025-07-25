//
//  EditCheckInAndOutRulesView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 23/07/2025.
//

import UIKit

class EditCheckInAndOutRulesView: BaseViewControllerPlain {
    var coordinator: HostingServiceMenuCoordinator?
    
    @IBOutlet weak var nextBtn: PrimaryButton!
    @IBOutlet weak var checkInFrom: TimePicker!
    @IBOutlet weak var checkInUntil: TimePicker!
    @IBOutlet weak var checkOutFrom: TimePicker!
    @IBOutlet weak var checkOutUntil: TimePicker!
    
    var property: BeachHouseListing?
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Property"
        
        setup()
    }

    func setup(){
        checkInFrom.selectedTime = createBeachListing?.checkInFrom?.fromBackendTime()
        checkInUntil.selectedTime = createBeachListing?.checkInTo?.fromBackendTime()
        checkOutFrom.selectedTime = createBeachListing?.checkOutFrom?.fromBackendTime()
        checkOutUntil.selectedTime = createBeachListing?.checkOutTo?.fromBackendTime()
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

            self.createBeachListing = createBeachListing
            print(createBeachListing)
            
            coordinator?.popToOptionsScreen()
        }
    }


}

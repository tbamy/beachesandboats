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
        guard
            let checkInFromTime = checkInFrom.selectedTime,
            let checkInUntilTime = checkInUntil.selectedTime,
            let checkOutFromTime = checkOutFrom.selectedTime,
            let checkOutUntilTime = checkOutUntil.selectedTime
        else {
            MiddleModal.show(title: "Invalid Input", subtitle: "Please select all check-in and check-out times.", type: .error, dismissable: true, dismissOnConfirm: true)
            return
        }
        
        // Validation logic
        if checkInUntilTime <= checkInFromTime {
            MiddleModal.show(title: "Invalid Check-In Time", subtitle: "Check-in until time must be after check-in from time.", type: .error, dismissable: true, dismissOnConfirm: true)
            return
        }
        
        if checkOutFromTime <= checkInUntilTime {
            MiddleModal.show(title: "Invalid Check-Out Time", subtitle: "Check-out from time must be after check-in until time.", type: .error, dismissable: true, dismissOnConfirm: true)
            return
        }
        
        if checkOutUntilTime <= checkOutFromTime {
            MiddleModal.show(title: "Invalid Check-Out Time", subtitle: "Check-out until time must be after check-out from time.", type: .error, dismissable: true, dismissOnConfirm: true)
            return
        }
        
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

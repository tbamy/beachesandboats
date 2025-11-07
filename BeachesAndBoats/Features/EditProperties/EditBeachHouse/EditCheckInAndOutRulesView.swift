//
//  EditCheckInAndOutRulesView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 23/07/2025.
//

import UIKit
import RxSwift

class EditCheckInAndOutRulesView: BaseViewControllerPlain {
    var coordinator: HostingServiceMenuCoordinator?
    
//    @IBOutlet weak var nextBtn: PrimaryButton!
    @IBOutlet weak var overnightCheckIn: TimePicker!
    @IBOutlet weak var overnightCheckOut: TimePicker!
    @IBOutlet weak var dayCheckIn: TimePicker!
    @IBOutlet weak var dayCheckOut: TimePicker!
    
    var property: BeachHouseListing?
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    var details: GetBeachData?
    var id: String?
    
    var disposeBag = DisposeBag()
    var vm = EditBeachViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Property"
        
        bindNetwork()
        setup()
    }

    func setup() {
        guard let savedListing = details else { return }
        
        // Populate check-in and check-out times
        if let overnightCheckInTime = savedListing.overnightCheckIn, !overnightCheckInTime.isEmpty {
            print(overnightCheckInTime)
            overnightCheckIn.text = overnightCheckInTime
            overnightCheckIn.selectedTime = overnightCheckInTime.fromBackendTime()
        }
        
        if let overnightCheckOutTime = savedListing.overnightCheckOut, !overnightCheckOutTime.isEmpty {
            print(overnightCheckOutTime)
            overnightCheckOut.text = overnightCheckOutTime
            overnightCheckOut.selectedTime = overnightCheckOutTime.fromBackendTime()
        }
        
        if let dayCheckInTime = savedListing.dayCheckIn, !dayCheckInTime.isEmpty {
            print(dayCheckInTime)
            dayCheckIn.text = dayCheckInTime
            dayCheckIn.selectedTime = dayCheckInTime.fromBackendTime()
        }
        
        if let dayCheckOutTime = savedListing.dayCheckOut, !dayCheckOutTime.isEmpty {
            print(dayCheckOutTime)
            dayCheckOut.text = dayCheckOutTime
            dayCheckOut.selectedTime = dayCheckOutTime.fromBackendTime()
        }
    }

    @IBAction func nextTapped(_ sender: Any) {
        guard
            let overnightCheckInTime = overnightCheckIn.selectedTime,
            let overnightCheckOutTime = overnightCheckOut.selectedTime,
            let dayCheckInTime = dayCheckIn.selectedTime,
            let dayCheckOutTime = dayCheckOut.selectedTime
        else {
            print("Missing selectedTime: overnightCheckIn=\(overnightCheckIn.selectedTime), overnightCheckOut=\(overnightCheckOut.selectedTime), dayCheckIn=\(dayCheckIn.selectedTime), dayCheckOut=\(dayCheckOut.selectedTime)")
            
            MiddleModal.show(
                title: "Incomplete Times",
                subtitle: "Please make sure to select all check-in and check-out time slots before proceeding.",
                type: .error,
                dismissable: true,
                dismissOnConfirm: true
            )
            return
        }

//        if overnightCheckOutTime <= overnightCheckInTime {
//            MiddleModal.show(
//                title: "Overnight Booking Time Mismatch",
//                subtitle: "The check-out time must be after the check-in time.",
//                type: .error,
//                dismissable: true,
//                dismissOnConfirm: true
//            )
//            return
//        }
//
//        if dayCheckOutTime <= dayCheckInTime {
//            MiddleModal.show(
//                title: "Day Booking Time Mismatch",
//                subtitle: "The check-out time must be after the check-in time.",
//                type: .error,
//                dismissable: true,
//                dismissOnConfirm: true
//            )
//            return
//        }

        // All checks passed
        if var createBeachListing = createBeachListing {
            guard let id = id else { return }
            
            createBeachListing.overnightCheckIn = overnightCheckIn.text
            createBeachListing.overnightCheckOut = overnightCheckOut.text
            createBeachListing.dayCheckIn = dayCheckIn.text
            createBeachListing.dayCheckOut = dayCheckOut.text

            self.createBeachListing = createBeachListing
            print(createBeachListing)
            
            LoadingModal.show(title: "Updating Record...")
            vm.editBeach(createBeachListing, id: id)
        }
    }

    
    func bindNetwork(){
        vm.output.subscribe(onNext: {[weak self] response in
            LoadingModal.dismiss()
            
            switch response {
            case .editBeachSuccessful(let response):
                print(response)
                MiddleModal.show(title: response.message ?? "", type: .success, onConfirm: { self?.coordinator?.popToOptionsScreen() })
                
            case .editBeachFailed(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
            
        }).disposed(by: disposeBag)
    }
    

}

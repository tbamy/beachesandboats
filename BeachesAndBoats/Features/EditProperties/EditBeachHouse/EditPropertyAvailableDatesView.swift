//
//  EditPropertyAvailableDatesView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 23/07/2025.
//

import UIKit
import RxSwift


class EditPropertyAvailableDatesView: BaseViewControllerPlain {
    var coordinator: HostingServiceMenuCoordinator?
    
    @IBOutlet weak var calendarView: HorizonCalendar!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var property: BeachHouseListing?
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    var selectedItems: [String] = []
    var id: String?
    
    var from_when: Date?
    var to_when: Date?
    
    var currentDate = Date()
    
    var disposeBag = DisposeBag()
    var vm = EditBeachViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Property"
        
        bindNetwork()
        setup()
    }
    
    func setup(){
        from_when = createBeachListing?.availableFrom?.convertFromBackendDateString()
        to_when = createBeachListing?.availableTo?.convertFromBackendDateString()
        
        calendarView.onDatesSelected = { startDate, endDate in
            self.from_when = startDate
            if let endDate = endDate {
                self.to_when = endDate
            }
            
            // Update button state based on date selection
            self.updateNextButtonState()
        }
        
        print("From: \(from_when) to: \(to_when)")
        print("Self From: \(self.from_when) self to: \(self.to_when)")
        
        updateNextButtonState()
    }
    
    private func updateNextButtonState() {
        nextBtn.isEnabled = from_when != nil && to_when != nil
    }
    
    private func validateDates() -> Bool {
        guard let fromDate = from_when, let toDate = to_when else {
//            showAlert(message: "Please select both start and end dates")
            MiddleModal.show(subtitle: "Please select both start and end dates", type: .error)
            return false
        }
        
        if fromDate > toDate {
//            showAlert(message: "Start date cannot be after end date")
            MiddleModal.show(subtitle: "Start date cannot be after end date", type: .error)
            return false
        }
        
        return true
    }
    
//    private func showAlert(message: String) {
//        let alert = UIAlertController(title: "Invalid Dates", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alert, animated: true)
//    }

    @IBAction func nextTapped(_ sender: Any) {
        guard validateDates() else { return }
        guard let id = id else { return }
        
        if var createBeachListing = createBeachListing {
            createBeachListing.availableFrom = from_when?.toBackendDate() ?? ""
            createBeachListing.availableTo = to_when?.toBackendDate() ?? ""
            
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



//class EditPropertyAvailableDatesView: BaseViewControllerPlain {
//    var coordinator: HostingServiceMenuCoordinator?
//    
//    @IBOutlet weak var calendarView: HorizonCalendar!
//    @IBOutlet weak var nextBtn: PrimaryButton!
//    
//    var property: BeachHouseListing?
//    var beachData: BeachDatas?
//    var createBeachListing: CreateBeachListingRequest?
//    var selectedItems: [String] = []
//    var id: String?
//    
//    var from_when: Date?
//    var to_when: Date?
//    
//    var currentDate = Date()
//    
//    var disposeBag = DisposeBag()
//    var vm = EditBeachViewModel()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Edit Property"
//        
//        bindNetwork()
//        setup()
//    }
//    
//    func setup(){
//        from_when = createBeachListing?.availableFrom?.convertFromBackendDateString()
//        to_when = createBeachListing?.availableTo?.convertFromBackendDateString()
//        
//        calendarView.onDatesSelected = { startDate, endDate in
//            
//            self.from_when = startDate
//            if let endDate = endDate {
//                self.to_when = endDate
//            }
//        }
//        
//        print("From: \(from_when) to: \(to_when)")
//        print("Self From: \(self.from_when) self to: \(self.to_when)")
//        
////        if (self.from_when ?? Date() < currentDate) || (self.to_when ?? Date() < currentDate){
////            nextBtn.isEnabled = false
////        }else{
////            nextBtn.isEnabled = true
////        }
//        
//    }
//
//    @IBAction func nextTapped(_ sender: Any) {
//        guard let id = id else { return }
//        if var createBeachListing = createBeachListing{
//            createBeachListing.availableFrom = from_when?.toBackendDate() ?? ""
//            createBeachListing.availableTo = to_when?.toBackendDate() ?? ""
//            
//            self.createBeachListing = createBeachListing
//            print(createBeachListing)
//            
//            LoadingModal.show(title: "Updating Record...")
//            vm.editBeach(createBeachListing, id: id)
//            
//        }
//    }
//    
//    func bindNetwork(){
//        vm.output.subscribe(onNext: {[weak self] response in
//            LoadingModal.dismiss()
//            
//            switch response {
//            case .editBeachSuccessful(let response):
//                print(response)
//                MiddleModal.show(title: response.message ?? "", type: .success, onConfirm: { self?.coordinator?.popToOptionsScreen() })
//                
//            case .editBeachFailed(let error):
//                MiddleModal.show(title: error.message ?? "", type: .error)
//            }
//            
//        }).disposed(by: disposeBag)
//    }
//    
//
//}


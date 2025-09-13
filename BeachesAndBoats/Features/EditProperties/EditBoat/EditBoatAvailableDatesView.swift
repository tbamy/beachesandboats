//
//  EditBoatAvailableDatesView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/09/2025.
//

import UIKit
import RxSwift

class EditBoatAvailableDatesView: BaseViewControllerPlain {
    
    var coordinator: HostingServiceMenuCoordinator?
    
    @IBOutlet weak var calendarView: HorizonCalendar!
    
    var boatData: BoatDatas?
    var createBoatListing: CreateBoatListingRequest?
    var boatType: String?
    
    var from_when: Date?
    var to_when: Date?
    
    var currentDate = Date()
    
    var disposeBag = DisposeBag()
    var vm = EditBoatViewModel()
    var id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Boats"
        
        bindNetwork()
        setup()
    }
    
    func setup(){
        calendarView.onDatesSelected = { startDate, endDate in
            
            self.from_when = startDate
            if let endDate = endDate {
                self.to_when = endDate
            }
        }
    }

    
    @IBAction func saveAndExit(_ sender: Any) {
        guard let id = id else { return }
        
        if var createBoatListing = createBoatListing{
            createBoatListing.availableFrom = from_when?.toBackendDate() ?? ""
            createBoatListing.availableTo = to_when?.toBackendDate() ?? ""
            
            self.createBoatListing = createBoatListing
            print(createBoatListing)
            
            LoadingModal.show(title: "Updating Record...")
            vm.editBoat(createBoatListing, id: id)
            
        }
        
    }
    
    func bindNetwork(){
        vm.output.subscribe(onNext: {[weak self] response in
            LoadingModal.dismiss()
            
            switch response {
            case .editBoatSuccessful(let response):
                print(response)
                MiddleModal.show(title: response.message ?? "", type: .success, onConfirm: { self?.coordinator?.popToBoatOptionsScreen() })
                
            case .editBoatFailed(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
            
        }).disposed(by: disposeBag)
    }
    

}

//
//  BlockBoatAvailabilityView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 03/10/2025.
//

import UIKit
import RxSwift


class BlockBoatAvailabilityView: BaseViewControllerPlain {
    var coordinator: HostingServiceMenuCoordinator?
    
    @IBOutlet weak var calendarView: HorizonCalendar!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var selectedDates: [String] = []
    var blockedDates: [String] = []
    var id: String?
    
    var disposeBag = DisposeBag()
    var vm = BlockDateVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Property"
        
        if let id = id {
            let request = GetReservedDatesRequest(dateable_id: id, dateable_type: "boat")
            vm.getReservedDates(request: request)
            LoadingModal.show()
        }
        
        nextBtn.isEnabled = true
        bindNetwork()
        setup()
    }
    
    
    func setup(){
        
        calendarView.setBlockingMode(true)
        
        let alreadyBlockedDates = blockedDates.map { $0.convertFromBackendDateString() ?? Date() }
        print("Already blocked dates: \(alreadyBlockedDates.forEach { print($0) })")
        calendarView.setBlockedDates(alreadyBlockedDates)
        
        calendarView.onBlockedDatesChanged = { blockedDates in
            print("Current blocked dates: \(blockedDates.count)")
            
            if blockedDates.isEmpty {
                print("All dates unblocked")
            } else {
                print("Blocked dates:")
                blockedDates.forEach { print($0.toBackendDate() ) }
                self.selectedDates = blockedDates.map{ $0.toBackendDate() }
            }
        }
        
    }


    @IBAction func nextTapped(_ sender: Any) {
        guard let id = id else { return }
            print(selectedDates)
        
            LoadingModal.show(title: "Updating Record...")
        let request = AddReservedDateRequest(dates: selectedDates, dateable_id: id, dateable_type: "boat")
            vm.addReservedDates(request: request)
    }
    
    func bindNetwork(){
        vm.output.subscribe(onNext: {[weak self] response in
            LoadingModal.dismiss()
            
            switch response {
            case .addReservedDateSuccessful(let response):
                print(response)
                MiddleModal.show(title: response.message ?? "", type: .success, onConfirm: { self?.coordinator?.popToOptionsScreen() })
                
            case .addReservedDateFailed(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
        
            case .getReservedDateSuccessful(let response):
                self?.blockedDates = response.data?.dates ?? []
                self?.setup()
                
            case .getReservedDateFailed(let error):
                MiddleModal.show(title: error.message ?? "", type: .error, onConfirm: { self?.coordinator?.popToOptionsScreen() })
            }
            
        }).disposed(by: disposeBag)
    }
}


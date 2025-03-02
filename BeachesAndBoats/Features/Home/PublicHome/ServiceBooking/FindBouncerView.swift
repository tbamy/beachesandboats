//
//  FindBouncerView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 30/01/2025.
//

import UIKit
import RxSwift

class FindBouncerView: BaseViewControllerPlain {
    var coordinator: ExploreCoordinator?

    @IBOutlet weak var dateField: HorizonDateField!
    @IBOutlet weak var anyCheckbox: CheckboxButton!
    @IBOutlet weak var maleCheckbox: CheckboxButton!
    @IBOutlet weak var femaleCheckbox: CheckboxButton!
    @IBOutlet weak var armedCheckbox: CheckboxButton!
    @IBOutlet weak var unarmedCheckbox: CheckboxButton!
    
    var selectedGender: String = ""
    var isArmed: Bool = false
    var findBouncerResponse: FindServiceProviderResponse?
    
    let vm = FindServiceProviderVM()
    let disposeBag = DisposeBag()
    let input = PublishSubject<FindServiceProviderVM.Input>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Bouncer"
        
        setup()
        bind()
        
    }

    func setup(){
        dateField.placeholder = "Select available date from calendar"
        dateField.placeHolderColor = .B_B
        dateField.onDateSelected = { (date) in
//            self.day = date
            self.dateField.text = "\(date.toFormattedDate())"
        }
        
        maleCheckbox.stateChanged = { [weak self] maleSelected in
            guard let self = self else { return }
            
            selectedGender = maleSelected ? "male" : ""
            femaleCheckbox.isChecked = false
            anyCheckbox.isChecked = false
            
        }
        
        femaleCheckbox.stateChanged = { [weak self] femaleSelected in
            guard let self = self else { return }
            
            selectedGender = femaleSelected ? "female" : ""
            maleCheckbox.isChecked = false
            anyCheckbox.isChecked = false
        }
        
        anyCheckbox.stateChanged = { [weak self] anySelected in
            guard let self = self else { return }
            
            selectedGender = anySelected ? "any" : ""
            femaleCheckbox.isChecked = false
            maleCheckbox.isChecked = false
        }
        
        unarmedCheckbox.stateChanged = { [weak self] unarmedSelected in
            guard let self = self else { return }
            
            isArmed = unarmedSelected
            armedCheckbox.isChecked = false
        }
        
        armedCheckbox.stateChanged = { [weak self] armedSelected in
            guard let self = self else { return }
            
            isArmed = armedSelected
            unarmedCheckbox.isChecked = false
        }
    }
    
    @IBAction func findBouncerTapped(_ sender: Any) {
        let request = selectedGender
        if request == ""{
            MiddleModal.show(title: "Select a gender", type: .error)
        }else{
            input.onNext(.findBouncer(request))
            LoadingModal.show()
        }
        
    }
    
    func bind(){
        vm.transform(input: input)
        
        vm.bouncerOutput.subscribe(onNext: { [weak self] event in
            guard let self = self else { return }
            LoadingModal.dismiss()
            switch event {
            case .findBouncerSuccessful(let response):
                self.findBouncerResponse = response
                if let bouncerResponse = findBouncerResponse{
                    if let bouncerData = bouncerResponse.data, !bouncerData.isEmpty{
                        self.coordinator?.gotoRecommentdations(data: bouncerResponse, provider: "Bouncer")
                    }else{
                        MiddleModal.show(title: "Oops!", subtitle: "No Data returned for your search, try another", type: .error)
                    }
                    
                }
                
            case .findBouncerFailed(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
                
            }
        }).disposed(by: disposeBag)
    }

}

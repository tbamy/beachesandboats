//
//  BankDetailsView.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 03/01/2025.
//

import UIKit
import RxSwift

class BankDetailsView: BaseViewControllerPlain {
    
    @IBOutlet weak var bankNameField: InputField!
    @IBOutlet weak var accountNumberField: InputField!
    @IBOutlet weak var bankDropDownField: DropDown!
    
    var coordinator: HostingServiceEarningCoordinator?
    
    let vm = BankDetailsVM()
    let disposeBag = DisposeBag()
    let input = PublishSubject<BankDetailsVM.Input>()
    
    var country: String = ""
    var paymentMethod: String = ""
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        input.onNext(.getBanks)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        //        title = "Payment Settings"
        
    }
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        if validateFields() {
            AppStorage.accountName = bankNameField.text
            AppStorage.accountNumber = accountNumberField.text
            AppStorage.bankName = bankDropDownField.selectedItem?.name
            
            MiddleModal.show(title: "Payment details saved successfully", type: .success, onConfirm: { self.coordinator?.popToRoot()})
        }
    }
    
    func getBanks(_ banks: ListOfBanksResponse) {
        guard let listOfBanks = banks.data else { return }
        
        bankDropDownField.items = listOfBanks.compactMap { bank in
            let bankName = bank.name
            let bankCode = bank.code
            
            return PickerItem(name: bankName ?? "", value: bankCode ?? "")
        }
    }
}

//MARK: - Bindin
extension BankDetailsView {
    func bind() {
        vm.transform(input: input)
        vm.output.subscribe(onNext: { [weak self] output in
            LoadingModal.dismiss()
            switch output {
            case .getBanksSuccess(let response):
                self?.getBanks(response)
            case .getBanksFailure(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
        }).disposed(by: disposeBag)
    }
}

//MARK: - Field Validation
extension BankDetailsView {
    func validateFields() -> Bool {
        let bank = bankNameField.validate(rules: [Rule(.isEmpty, "Enter a bank")])
        let accNo = accountNumberField.validate(rules: [Rule(.isEmpty, "Enter a acoount number")])
        let bankDropdown = bankDropDownField.validate(rules: [Rule(.isEmpty, "Select a bank")])
        return bank && accNo && bankDropdown
    }
}


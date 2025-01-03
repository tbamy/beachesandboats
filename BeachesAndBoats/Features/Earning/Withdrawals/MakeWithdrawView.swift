//
//  MakeWithdrawView.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 02/01/2025.
//

import UIKit
import RxSwift

protocol PaymentSelected: AnyObject {
    func bankPayment()
    func mobilePayment()
}

class MakeWithdrawView: UIViewController {
    
    @IBOutlet weak var bankBtn: CheckboxButton!
    @IBOutlet weak var mobileMoneyBtn: CheckboxButton!
    @IBOutlet weak var withdrawalAmountField: BigMoneyInputField!
    @IBOutlet weak var bankNameField: DropDown!
    @IBOutlet weak var bankAccountField: DigitField!
    @IBOutlet weak var mobileMoneyField: DigitField!
    @IBOutlet weak var withdrawBtn: PrimaryButton!
    @IBOutlet weak var bankAccNoStack: UIStackView!
    @IBOutlet weak var acctNameLbl: UILabel!
    @IBOutlet var allFields: [DigitField]!
    @IBOutlet var radioBtns: [CheckboxButton]!
    
    var paymentDestination: PaymentDestination?
    weak var paymentSelectedDelegate: PaymentSelected?
    
    var coordinator: EarningCoordinator?
    
    let vm = MakeWithdrawVM()
    let disposeBag = DisposeBag()
    let input = PublishSubject<MakeWithdrawVM.Input>()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LoadingModal.show(title: "Loading")
        input.onNext(.getBanks)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bankBtn.isChecked = true
        paymentDestination = .bank
        paymentSelected()
        bind()
    }
    
    func paymentSelected() {
        for radioBtn in radioBtns {
            radioBtn.stateChanged = { [weak self] isSelected in
                guard let self = self else { return }
                if isSelected {
                    self.deselectOtherButtons(except: radioBtn)
                    self.handlePaymentSelection(for: radioBtn)
                }
            }
        }
        updateUI(paymentSelected: .bank)
    }
    
    private func deselectOtherButtons(except selectedButton: CheckboxButton) {
        for radioBtn in radioBtns where radioBtn != selectedButton {
            radioBtn.isChecked = false
        }
    }
    
    private func handlePaymentSelection(for selectedButton: CheckboxButton) {
        if selectedButton == bankBtn {
            paymentDestination = .bank
            updateUI(paymentSelected: .bank)
        } else if selectedButton == mobileMoneyBtn {
            paymentDestination = .mobile
            updateUI(paymentSelected: .mobile)
        }
    }

    func updateUI(paymentSelected: PaymentDestination) {
        switch paymentSelected {
        case .bank:
            print("Bank Selected")
            mobileMoneyField.isHidden = true
            withdrawalAmountField.isHidden = false
            bankNameField.isHidden = false
            bankAccNoStack.isHidden = false
        case .mobile:
            print("Mobile Selected")
            mobileMoneyField.isHidden = false
            withdrawalAmountField.isHidden = false
            bankNameField.isHidden = true
            bankAccNoStack.isHidden = true
        }
    }
    
    @IBAction func withdrawBtnTapped(_ sender: Any) {
        if validateFields() {
            LoadingModal.show(title: "Making Withdrawal...")
            switch paymentDestination {
            case .bank:
                let request = CreateWithdrawalRequest(
                    withdrawalType: .bank,
                    amount: withdrawalAmountField.getDoubleValue() ?? 0,
                    bankName: bankNameField.text,
                    bankAccountNumber: bankAccountField.text
                )
                input.onNext(.makeWithdrawal(request))
//                paymentSelectedDelegate?.bankPayment()
            case .mobile:
                let request = CreateWithdrawalRequest(
                    withdrawalType: .mobileMoeny,
                    amount: withdrawalAmountField.getDoubleValue() ?? 0,
                    mobileMoneyNumber: mobileMoneyField.text
                )
                input.onNext(.makeWithdrawal(request))
//                paymentSelectedDelegate?.mobilePayment()
            default:
                return
            }
        }
    }
    
    func getBankList(_ listOfBanks: ListOfBanksResponse) {
        guard let bankList = listOfBanks.data else { return }
        bankNameField.pickerTitle = "Banks"
        bankNameField.items = bankList.compactMap { bank in
            let bankName = bank.name
            return PickerItem(name: bankName ?? "", value: bankName ?? "")
        }
    }
}

//MARK: - Binding
extension MakeWithdrawView {
    func bind() {
        vm.transform(input: input)
        vm.output.subscribe(onNext: { [weak self] output in
            LoadingModal.dismiss()
            switch output {
            case .makeWithdrawalSuccess(let response):
                MiddleModal.show(title: response.message ?? "", primaryText: "Done", onConfirm: {
                    self?.coordinator?.gotoServiceDashboard()
                })
            case .makeWithdrawalFailure(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            case .getBanksSuccess(let response):
                self?.getBankList(response)
            case .getBanksFailure(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
        }).disposed(by: disposeBag)
    }
}

//MARK: - Field Validation
extension MakeWithdrawView {
    func validateFields() -> Bool {
        switch paymentDestination {
        case .bank:
            let withdrawAmount = withdrawalAmountField.validate(rules: [Rule(.isEmpty, "Field cannot be empty")])
            let bankName = bankNameField.validate(rules: [Rule(.isEmpty, "Selecte a bank")])
            let bankAccNo = bankAccountField.validate(rules: [Rule(.isEmpty, "Field cannot be empty")])
            return withdrawAmount && bankName && bankAccNo
        case .mobile:
            let withdrawAmount = withdrawalAmountField.validate(rules: [Rule(.isEmpty, "Field cannot be empty")])
            let mobileNo = mobileMoneyField.validate(rules: [Rule(.isEmpty, "Field cannot be empty")])
            return withdrawAmount && mobileNo
        default:
            return false
        }
    }
}

enum PaymentDestination {
    case bank, mobile
}

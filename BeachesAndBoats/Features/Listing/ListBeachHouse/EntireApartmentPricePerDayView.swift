//
//  EntireApartmentPricePerDayView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 08/02/2025.
//

import UIKit
import RxSwift

class EntireApartmentPricePerDayView: UIViewController {

    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var nextBtn: PrimaryButton!
    @IBOutlet weak var moneyField: BigMoneyInputField!
    @IBOutlet weak var commissionView: UIView!
    @IBOutlet weak var commissionField: UILabel!
    @IBOutlet weak var discountCheck: UIImageView!
    @IBOutlet weak var discountField: DiscountField!
    
    var disposeBag = DisposeBag()
    var vm = ListBeachViewModel()
    
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    
    var isDiscountChecked: Bool = false
    var finalDiscountPercent: Float = 0.1 // This will store the final discount percentage
    var finalEarnings: Float = 0 // This will store what the user actually earns
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beaches Houses"
        setup()
        bindNetwork()
    }

    func setup(){
        discountCheck.isUserInteractionEnabled = true
        discountCheck.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(discountCheckTapped)))
        discountCheck.image = isDiscountChecked ? UIImage(named: "check_icon") : UIImage(named: "uncheck_icon")
        discountField.isHidden = !isDiscountChecked
        discountField.keyboardType = .numberPad
        stepOneProgress.setProgress(1, animated: false)
        stepOneProgress.tintColor = .success
        stepTwoProgress.setProgress(0.95, animated: true)
        stepTwoProgress.tintColor = .B_B
        
        moneyField.updateHeight(to: 70)
        moneyField.amountChanged = { [weak self] in
            if let amount = self?.moneyField.getDoubleValue() {
                self?.updateCommission(with: String(amount))
            }
            self?.nextBtn.isEnabled = true
        }

        discountField.textChanged = { [weak self] _,_,_ in
            if let amount = self?.moneyField.getDoubleValue() {
                self?.updateCommission(with: String(amount))
            }
        }
        
        commissionView.layer.borderWidth = 1
        commissionView.layer.borderColor = UIColor.background.cgColor
        commissionView.isHidden = true
    }
    
    @objc func discountCheckTapped() {
        isDiscountChecked.toggle()
        discountCheck.image = isDiscountChecked ? UIImage(named: "check_icon") : UIImage(named: "uncheck_icon")
        discountField.isHidden = !isDiscountChecked
        
        // Recalculate commission when discount check state changes
        if let amount = moneyField.getFloatValue() {
            updateCommission(with: String(amount))
        }
    }
    
    func updateCommission(with enteredText: String) {
        guard let enteredAmount = moneyField.getFloatValue(), enteredAmount > 0 else {
            print("Invalid or zero amount entered.")
            commissionField.text = ""
            commissionView.isHidden = true
            finalEarnings = 0
            finalDiscountPercent = 0.1
            return
        }
        
        print("Original Amount: ₦\(enteredAmount)")
        
        if isDiscountChecked {
            // If discount is checked, apply additional discount on top of the base 10%
            let additionalDiscountPercent = (discountField.getFloatValue() ?? 0) / 100
            
            // First apply the base 10% commission
            let amountAfterBaseCommission = enteredAmount * 0.9 // User gets 90% after base commission
            
            // Then apply the additional discount on the remaining amount
            let additionalDiscountAmount = amountAfterBaseCommission * additionalDiscountPercent
            finalEarnings = amountAfterBaseCommission - additionalDiscountAmount
            
            // Calculate the total effective discount percentage
            let totalCommissionAmount = enteredAmount - finalEarnings
            finalDiscountPercent = totalCommissionAmount / enteredAmount
            
            print("Base 10% commission applied: ₦\(enteredAmount * 0.1)")
            print("Amount after base commission: ₦\(amountAfterBaseCommission)")
            print("Additional discount (\(additionalDiscountPercent * 100)%): ₦\(additionalDiscountAmount)")
            print("Total commission: ₦\(totalCommissionAmount)")
            print("Final discount percentage: \(finalDiscountPercent * 100)%")
        } else {
            // If discount is not checked, apply only the base 10% commission
            finalDiscountPercent = 0.1
            finalEarnings = enteredAmount * (1 - finalDiscountPercent)
            
            print("Base 10% commission applied: ₦\(enteredAmount * finalDiscountPercent)")
        }
        
        // Update the UI
        commissionView.isHidden = false
        commissionField.text = String(format: "You earn ₦%.2f", finalEarnings)
        
        print("Final User Earnings: ₦\(finalEarnings)")
        print("---")
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        if var createBeachListing = createBeachListing{
            createBeachListing.pricePerDay = moneyField.getFloatValue() ?? 0
            // Store the final discount percentage (converted to percentage for storage)
            createBeachListing.dayDiscountPercent = finalDiscountPercent * 100
            
            if createBeachListing.bookingType?.isEmpty ?? true {
                createBeachListing.bookingType = "FULL"
            }
            print("Final Request is: \(createBeachListing)")
            print("Stored day discount percent: \(createBeachListing.dayDiscountPercent)%")
            
            LoadingModal.show(title: "Hold on while we list your Property")
            vm.createBeach(createBeachListing)
        }
    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        if var createBeachListing = createBeachListing{
            createBeachListing.pricePerDay = moneyField.getFloatValue() ?? 0
            // Store the final discount percentage (converted to percentage for storage)
            createBeachListing.dayDiscountPercent = finalDiscountPercent * 100
            
            if createBeachListing.bookingType?.isEmpty ?? true {
                createBeachListing.bookingType = "FULL"
            }
            
            AppStorage.beachListing = createBeachListing
            coordinator?.backToDashboard()
        }
    }
    
    func bindNetwork(){
        vm.output.subscribe(onNext: {[weak self] response in
            LoadingModal.dismiss()
            
            switch response {
            case .listBeachSuccessful(let response):
                print(response)
                self?.coordinator?.gotoListingSuccessView(type: 2)
            case .listBeachFailed(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
            
        }).disposed(by: disposeBag)
    }
}

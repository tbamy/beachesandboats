//
//  EditEntireApartmentPricePerDayView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 23/07/2025.
//

import UIKit
import RxSwift

class EditEntireApartmentPricePerDayView: UIViewController {
    var coordinator: HostingServiceMenuCoordinator?
    
    @IBOutlet weak var nextBtn: PrimaryButton!
    @IBOutlet weak var moneyField: BigMoneyInputField!
    @IBOutlet weak var commissionView: UIView!
    @IBOutlet weak var commissionField: UILabel!
    @IBOutlet weak var discountCheck: UIImageView!
    @IBOutlet weak var discountField: DiscountField!
    
    var disposeBag = DisposeBag()
    var vm = EditBeachViewModel()
    
    var property: BeachHouseListing?
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    
    var isDiscountChecked: Bool = false
    var finalDiscountPercent: Float = 0.1 // Total effective discount percentage for display
    var finalEarnings: Float = 0 // What the user actually earns
    var id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Property"
        setup()
        bindNetwork()
    }
    
    func setup() {
        // Get stored values
        let storedPrice = createBeachListing?.pricePerDay ?? 0
        let storedDiscountPercent = Float(createBeachListing?.dayDiscountPercent ?? 0) / 100 // Additional discount percentage
        
        // Set the price field
        moneyField.text = storedPrice.toAmount() ?? ""
        nextBtn.isEnabled = true
        // Check if additional discount was applied
        if storedDiscountPercent > 0 {
            isDiscountChecked = true
            discountField.text = String(format: "%.1f", storedDiscountPercent * 100)
            
            // Calculate earnings with base charge and additional discount
            let amountAfterBaseCharge = storedPrice * 0.9
            let additionalDiscountAmount = amountAfterBaseCharge * storedDiscountPercent
            finalEarnings = amountAfterBaseCharge - additionalDiscountAmount
            finalDiscountPercent = (storedPrice - finalEarnings) / storedPrice
            
            print("EDITING MODE - Loading stored day price data:")
            print("Stored price: ₦\(storedPrice)")
            print("Stored additional discount: \(storedDiscountPercent * 100)%")
            print("Amount after base charge: ₦\(amountAfterBaseCharge)")
            print("Additional discount amount: ₦\(additionalDiscountAmount)")
            print("User earnings: ₦\(finalEarnings)")
        } else {
            // Only base charge was applied
            isDiscountChecked = false
            finalDiscountPercent = 0.1
            finalEarnings = storedPrice * (1 - finalDiscountPercent)
            
            print("EDITING MODE - Only base 10% charge applied")
            print("Stored price: ₦\(storedPrice)")
            print("User earnings: ₦\(finalEarnings)")
        }
        
        // Update UI based on discount state
        discountCheck.image = isDiscountChecked ? UIImage(named: "check_icon") : UIImage(named: "uncheck_icon")
        discountField.isHidden = !isDiscountChecked
        
        // Update commission display
        commissionField.text = String(format: "You earn ₦%.2f", finalEarnings)
        commissionView.isHidden = storedPrice > 0 ? false : true
        
        // Setup UI interactions
        discountField.keyboardType = .numberPad
        discountCheck.isUserInteractionEnabled = true
        discountCheck.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(discountCheckTapped)))
        
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
    }
    
    @objc func discountCheckTapped() {
        isDiscountChecked.toggle()
        discountCheck.image = isDiscountChecked ? UIImage(named: "check_icon") : UIImage(named: "uncheck_icon")
        discountField.isHidden = !isDiscountChecked
        
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
        
        // Apply mandatory 10% charge
        let baseCharge = enteredAmount * 0.1
        let amountAfterBaseCharge = enteredAmount * 0.9
        
        if isDiscountChecked {
            // Apply additional discount on the amount after the base charge
            let additionalDiscountPercent = (discountField.getFloatValue() ?? 0) / 100
            let additionalDiscountAmount = amountAfterBaseCharge * additionalDiscountPercent
            finalEarnings = amountAfterBaseCharge - additionalDiscountAmount
            
            // Calculate total effective discount percentage for display
            let totalCommissionAmount = enteredAmount - finalEarnings
            finalDiscountPercent = totalCommissionAmount / enteredAmount
            
            print("Base 10% charge applied: ₦\(baseCharge)")
            print("Amount after base charge: ₦\(amountAfterBaseCharge)")
            print("Additional discount (\(additionalDiscountPercent * 100)%): ₦\(additionalDiscountAmount)")
            print("Total commission: ₦\(totalCommissionAmount)")
            print("Total effective discount percentage: \(finalDiscountPercent * 100)%")
        } else {
            // Only the base 10% charge applies
            finalEarnings = amountAfterBaseCharge
            finalDiscountPercent = 0.1
            
            print("Base 10% charge applied: ₦\(baseCharge)")
        }
        
        // Update the UI
        commissionView.isHidden = false
        commissionField.text = String(format: "You earn ₦%.2f", finalEarnings)
        
        print("Final User Earnings: ₦\(finalEarnings)")
        print("---")
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        guard let id = id else { return }
        guard let amount = moneyField.getFloatValue(), amount > 0 else {
            Toast.show(message: "Price cannot be empty")
            return
        }
        if var createBeachListing = createBeachListing {
            createBeachListing.pricePerDay = moneyField.getFloatValue() ?? 0
            createBeachListing.dayDiscountPercent = isDiscountChecked ? Int((discountField.getFloatValue() ?? 0)) : 0
            
            if createBeachListing.bookingType?.isEmpty ?? true {
                createBeachListing.bookingType = "FULL"
            }
            print("Final Request is: \(createBeachListing)")
            print("Stored additional day discount percent: \(createBeachListing.dayDiscountPercent)%")
            
            LoadingModal.show(title: "Updating Record...")
            vm.editBeach(createBeachListing, id: id)
        }
    }

    func bindNetwork() {
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
//import UIKit
//import RxSwift
//
//class EditEntireApartmentPricePerDayView: UIViewController {
//
//    var coordinator: HostingServiceMenuCoordinator?
//    
//    @IBOutlet weak var nextBtn: PrimaryButton!
//    @IBOutlet weak var moneyField: BigMoneyInputField!
//    @IBOutlet weak var commissionView: UIView!
//    @IBOutlet weak var commissionField: UILabel!
//    @IBOutlet weak var discountCheck: UIImageView!
//    @IBOutlet weak var discountField: DiscountField!
//    
//    var disposeBag = DisposeBag()
//    var vm = ListBeachViewModel()
//    
//    var property: BeachHouseListing?
//    var beachData: BeachDatas?
//    var createBeachListing: CreateBeachListingRequest?
//    
//    var isDiscountChecked: Bool = false
//    var finalDiscountPercent: Float = 0.1 // This will store the final discount percentage
//    var finalEarnings: Float = 0 // This will store what the user actually earns
//    var id: String?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Edit Property"
//        setup()
//        bindNetwork()
//    }
//    
//    func setup(){
//        
//        // Get stored values
//        let storedPrice = createBeachListing?.pricePerDay ?? 0
//        let storedDiscountPercent = Float(createBeachListing?.dayDiscountPercent ?? 10) / 100 // Convert back to decimal
//        
//        // Set the price field
//        moneyField.text = String(storedPrice)
//        
//        // Perform reverse calculation to determine if discount was applied
//        if storedDiscountPercent > 0.1 { // More than base 10% commission
//            // Discount was applied, so we need to reverse calculate
//            isDiscountChecked = true
//            
//            // Reverse calculate the additional discount percentage
//            // Formula: finalDiscountPercent = (baseCommission + additionalDiscount)
//            // where additionalDiscount = additionalDiscountPercent * (1 - baseCommission)
//            // Solving for additionalDiscountPercent:
//            let baseCommission: Float = 0.1
//            let additionalDiscountFactor = (storedDiscountPercent - baseCommission) / (1 - baseCommission)
//            let additionalDiscountPercent = additionalDiscountFactor * 100
//            
//            discountField.text = String(format: "%.1f", additionalDiscountPercent)
//            finalDiscountPercent = storedDiscountPercent
//            
//            // Calculate what user actually earns
//            finalEarnings = storedPrice * (1 - finalDiscountPercent)
//            
//            print("Reverse Calculation Results:")
//            print("Stored price: ₦\(storedPrice)")
//            print("Stored total discount: \(storedDiscountPercent * 100)%")
//            print("Calculated additional discount: \(additionalDiscountPercent)%")
//            print("User earnings: ₦\(finalEarnings)")
//        } else {
//            // Only base commission was applied
//            isDiscountChecked = false
//            finalDiscountPercent = 0.1
//            finalEarnings = storedPrice * 0.9
//            
//            print("Base commission only:")
//            print("Price: ₦\(storedPrice)")
//            print("User earnings: ₦\(finalEarnings)")
//        }
//        
//        // Update UI based on discount state
//        discountCheck.image = isDiscountChecked ? UIImage(named: "check_icon") : UIImage(named: "uncheck_icon")
//        discountField.isHidden = !isDiscountChecked
//        
//        // Update commission display
//        commissionField.text = String(format: "You earn ₦%.2f", finalEarnings)
//        
//        // Setup UI interactions
//        discountField.keyboardType = .numberPad
//        discountCheck.isUserInteractionEnabled = true
//        discountCheck.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(discountCheckTapped)))
//        
//        moneyField.updateHeight(to: 70)
//        moneyField.amountChanged = { [weak self] in
//            if let amount = self?.moneyField.getDoubleValue() {
//                self?.updateCommission(with: String(amount))
//            }
//            self?.nextBtn.isEnabled = true
//        }
//        
//        discountField.textChanged = { [weak self] _,_,_ in
//            if let amount = self?.moneyField.getDoubleValue() {
//                self?.updateCommission(with: String(amount))
//            }
//        }
//        
//        commissionView.layer.borderWidth = 1
//        commissionView.layer.borderColor = UIColor.background.cgColor
//        commissionView.isHidden = false // Show commission view since we have data
//    }
//
////    func setup(){
////        discountCheck.isUserInteractionEnabled = true
////        discountCheck.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(discountCheckTapped)))
////        discountCheck.image = isDiscountChecked ? UIImage(named: "check_icon") : UIImage(named: "uncheck_icon")
////        discountField.isHidden = !isDiscountChecked
////        discountField.keyboardType = .numberPad
////        
////        
////        moneyField.updateHeight(to: 70)
////        moneyField.amountChanged = { [weak self] in
////            if let amount = self?.moneyField.getDoubleValue() {
////                self?.updateCommission(with: String(amount))
////            }
////            self?.nextBtn.isEnabled = true
////        }
////
////        discountField.textChanged = { [weak self] _,_,_ in
////            if let amount = self?.moneyField.getDoubleValue() {
////                self?.updateCommission(with: String(amount))
////            }
////        }
////        
////        commissionView.layer.borderWidth = 1
////        commissionView.layer.borderColor = UIColor.background.cgColor
////        commissionView.isHidden = true
////    }
//    
//    @objc func discountCheckTapped() {
//        isDiscountChecked.toggle()
//        discountCheck.image = isDiscountChecked ? UIImage(named: "check_icon") : UIImage(named: "uncheck_icon")
//        discountField.isHidden = !isDiscountChecked
//        
//        // Recalculate commission when discount check state changes
//        if let amount = moneyField.getFloatValue() {
//            updateCommission(with: String(amount))
//        }
//    }
//    
//    func updateCommission(with enteredText: String) {
//        guard let enteredAmount = moneyField.getFloatValue(), enteredAmount > 0 else {
//            print("Invalid or zero amount entered.")
//            commissionField.text = ""
//            commissionView.isHidden = true
//            finalEarnings = 0
//            finalDiscountPercent = 0.1
//            return
//        }
//        
//        print("Original Amount: ₦\(enteredAmount)")
//        
//        if isDiscountChecked {
//            // If discount is checked, apply additional discount on top of the base 10%
//            let additionalDiscountPercent = (discountField.getFloatValue() ?? 0) / 100
//            
//            // First apply the base 10% commission
//            let amountAfterBaseCommission = enteredAmount * 0.9 // User gets 90% after base commission
//            
//            // Then apply the additional discount on the remaining amount
//            let additionalDiscountAmount = amountAfterBaseCommission * additionalDiscountPercent
//            finalEarnings = amountAfterBaseCommission - additionalDiscountAmount
//            
//            // Calculate the total effective discount percentage
//            let totalCommissionAmount = enteredAmount - finalEarnings
//            finalDiscountPercent = totalCommissionAmount / enteredAmount
//            
//            print("Base 10% commission applied: ₦\(enteredAmount * 0.1)")
//            print("Amount after base commission: ₦\(amountAfterBaseCommission)")
//            print("Additional discount (\(additionalDiscountPercent * 100)%): ₦\(additionalDiscountAmount)")
//            print("Total commission: ₦\(totalCommissionAmount)")
//            print("Final discount percentage: \(finalDiscountPercent * 100)%")
//        } else {
//            // If discount is not checked, apply only the base 10% commission
//            finalDiscountPercent = 0.1
//            finalEarnings = enteredAmount * (1 - finalDiscountPercent)
//            
//            print("Base 10% commission applied: ₦\(enteredAmount * finalDiscountPercent)")
//        }
//        
//        // Update the UI
//        commissionView.isHidden = false
//        commissionField.text = String(format: "You earn ₦%.2f", finalEarnings)
//        
//        print("Final User Earnings: ₦\(finalEarnings)")
//        print("---")
//    }
//    
//    @IBAction func nextTapped(_ sender: Any) {
//        if var createBeachListing = createBeachListing{
//            createBeachListing.pricePerDay = moneyField.getFloatValue() ?? 0
//            // Store the final discount percentage (converted to percentage for storage)
//            createBeachListing.dayDiscountPercent = Int(finalDiscountPercent * 100)
//            
//            if createBeachListing.bookingType?.isEmpty ?? true {
//                createBeachListing.bookingType = "FULL"
//            }
//            print("Final Request is: \(createBeachListing)")
//            print("Stored day discount percent: \(createBeachListing.dayDiscountPercent)%")
//            
//            LoadingModal.show(title: "Hold on while we list your Property")
//            vm.createBeach(createBeachListing)
//        }
//    }
//    
//    @IBAction func saveAndExit(_ sender: Any) {
//        if var createBeachListing = createBeachListing{
//            createBeachListing.pricePerDay = moneyField.getFloatValue() ?? 0
//            // Store the final discount percentage (converted to percentage for storage)
//            createBeachListing.dayDiscountPercent = Int(finalDiscountPercent * 100)
//            
//            if createBeachListing.bookingType?.isEmpty ?? true {
//                createBeachListing.bookingType = "FULL"
//            }
//    
//        }
//    }
//    
//    func bindNetwork(){
//        vm.output.subscribe(onNext: {[weak self] response in
//            LoadingModal.dismiss()
//            
//            switch response {
//            case .listBeachSuccessful(let response):
//                print(response)
////                self?.coordinator?.gotoListingSuccessView(type: 2)
//            case .listBeachFailed(let error):
//                MiddleModal.show(title: error.message ?? "", type: .error)
//            }
//            
//        }).disposed(by: disposeBag)
//    }
//}
//

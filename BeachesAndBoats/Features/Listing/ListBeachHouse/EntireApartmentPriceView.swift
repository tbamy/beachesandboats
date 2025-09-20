//
//  EntireApartmentPriceView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 09/10/2024.
//

import UIKit

class EntireApartmentPriceView: UIViewController {

    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var nextBtn: PrimaryButton!
    @IBOutlet weak var moneyField: BigMoneyInputField!
    @IBOutlet weak var commissionView: UIView!
    @IBOutlet weak var commissionField: UILabel!
    @IBOutlet weak var discountCheck: UIImageView!
    @IBOutlet weak var discountField: DiscountField!
    
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    
    var isDiscountChecked: Bool = false
    var finalDiscountPercent: Float = 0.1 // Total effective discount percentage for display
    var finalEarnings: Float = 0 // What the user actually earns
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beaches Houses"
        setup()
        loadSavedData()
    }

    func setup() {
        discountCheck.isUserInteractionEnabled = true
        discountCheck.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(discountCheckTapped)))
        discountCheck.image = isDiscountChecked ? UIImage(named: "check_icon") : UIImage(named: "uncheck_icon")
        discountField.isHidden = !isDiscountChecked
        discountField.keyboardType = .numberPad
        stepOneProgress.setProgress(1, animated: false)
        stepOneProgress.tintColor = .success
        stepTwoProgress.setProgress(0.85, animated: true)
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
            finalDiscountPercent = 0.1 // Only the base charge percentage for display
            
            print("Base 10% charge applied: ₦\(baseCharge)")
        }
        
        // Update the UI
        commissionView.isHidden = false
        commissionField.text = String(format: "You earn ₦%.2f", finalEarnings)
        
        print("Final User Earnings: ₦\(finalEarnings)")
        print("---")
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        if var createBeachListing = createBeachListing, let beachData = beachData {
            createBeachListing.listingPrice = moneyField.getFloatValue() ?? 0
            // Store only the additional discount percentage
            createBeachListing.discountPercent = isDiscountChecked ? Int((discountField.getFloatValue() ?? 0)) : 0
            
            if createBeachListing.bookingType?.isEmpty ?? true {
                createBeachListing.bookingType = "FULL"
            }
            print("Request is: \(createBeachListing)")
            print("Stored additional discount percent: \(createBeachListing.discountPercent)%")
            
            coordinator?.gotoEntireApartmentPricePerDayView(beachData: beachData, createBeachListingData: createBeachListing)
        }
    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        if var createBeachListing = createBeachListing {
            createBeachListing.listingPrice = moneyField.getFloatValue() ?? 0
            // Store only the additional discount percentage
            createBeachListing.discountPercent = isDiscountChecked ? Int((discountField.getFloatValue() ?? 0)) : 0
            
            if createBeachListing.bookingType?.isEmpty ?? true {
                createBeachListing.bookingType = "FULL"
            }
            
            AppStorage.beachListing = createBeachListing
            coordinator?.backToDashboard()
        }
    }
}


extension EntireApartmentPriceView {
    func loadSavedData() {
        guard let savedListing = AppStorage.beachListing else { return }
        
        // Load stored listing price
        let storedPrice = savedListing.listingPrice ?? 0
        let storedDiscountPercent = Float(savedListing.discountPercent ?? 0) / 100
        
        // Set price field
        moneyField.text = storedPrice.toAmount() ?? ""
        
        // Set discount state
        if storedDiscountPercent > 0 {
            isDiscountChecked = true
            discountField.text = String(format: "%.1f", storedDiscountPercent * 100)
            discountCheck.image = UIImage(named: "check_icon")
            discountField.isHidden = false
            
            // Calculate earnings
            let amountAfterBaseCharge = storedPrice * 0.9
            let additionalDiscountAmount = amountAfterBaseCharge * storedDiscountPercent
            finalEarnings = amountAfterBaseCharge - additionalDiscountAmount
            finalDiscountPercent = (storedPrice - finalEarnings) / storedPrice
        } else {
            isDiscountChecked = false
            finalDiscountPercent = 0.1
            finalEarnings = storedPrice * 0.9
            discountCheck.image = UIImage(named: "uncheck_icon")
            discountField.isHidden = true
        }
        
        // Update commission display
        if storedPrice > 0 {
            commissionField.text = String(format: "You earn ₦%.2f", finalEarnings)
            commissionView.isHidden = false
            nextBtn.isEnabled = true
        }
    }
}

//import UIKit
//
//class EntireApartmentPriceView: UIViewController {
//
//    var coordinator: AccountCoordinator?
//    
//    @IBOutlet weak var stepOneProgress: UIProgressView!
//    @IBOutlet weak var stepTwoProgress: UIProgressView!
//    @IBOutlet weak var nextBtn: PrimaryButton!
//    @IBOutlet weak var moneyField: BigMoneyInputField!
//    @IBOutlet weak var commissionView: UIView!
//    @IBOutlet weak var commissionField: UILabel!
//    @IBOutlet weak var discountCheck: UIImageView!
//    @IBOutlet weak var discountField: DiscountField!
//    
//    var beachData: BeachDatas?
//    var createBeachListing: CreateBeachListingRequest?
//    
//    var isDiscountChecked: Bool = false
//    var finalDiscountPercent: Float = 0.1 // This will store the final discount percentage
//    var finalEarnings: Float = 0 // This will store what the user actually earns
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Beaches Houses"
//        setup()
//    }
//
//    func setup(){
//        discountCheck.isUserInteractionEnabled = true
//        discountCheck.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(discountCheckTapped)))
//        discountCheck.image = isDiscountChecked ? UIImage(named: "check_icon") : UIImage(named: "uncheck_icon")
//        discountField.isHidden = !isDiscountChecked
//        discountField.keyboardType = .numberPad
//        stepOneProgress.setProgress(1, animated: false)
//        stepOneProgress.tintColor = .success
//        stepTwoProgress.setProgress(0.85, animated: true)
//        stepTwoProgress.tintColor = .B_B
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
//        commissionView.isHidden = true
//    }
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
//        if var createBeachListing = createBeachListing, let beachData = beachData{
//            createBeachListing.listingPrice = moneyField.getFloatValue() ?? 0
//            // Store the final discount percentage (converted to percentage for storage)
//            createBeachListing.discountPercent = Int(finalDiscountPercent * 100)
//            
//            if createBeachListing.bookingType?.isEmpty ?? true {
//                createBeachListing.bookingType = "FULL"
//            }
//            print("Request is: \(createBeachListing)")
//            print("Stored discount percent: \(createBeachListing.discountPercent)%")
//            
//            coordinator?.gotoEntireApartmentPricePerDayView(beachData: beachData, createBeachListingData: createBeachListing)
//        }
//    }
//    
//    @IBAction func saveAndExit(_ sender: Any) {
//        if var createBeachListing = createBeachListing{
//            createBeachListing.listingPrice = moneyField.getFloatValue() ?? 0
//            // Store the final discount percentage (converted to percentage for storage)
//            createBeachListing.discountPercent = Int(finalDiscountPercent * 100)
//            
//            if createBeachListing.bookingType?.isEmpty ?? true {
//                createBeachListing.bookingType = "FULL"
//            }
//            
//            AppStorage.beachListing = createBeachListing
//            coordinator?.backToDashboard()
//        }
//    }
//}

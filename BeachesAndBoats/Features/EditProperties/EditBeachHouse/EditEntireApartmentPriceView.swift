//
//  EditEntireApartmentPriceView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 23/07/2025.
//

import UIKit

class EditEntireApartmentPriceView: UIViewController {

    var coordinator: HostingServiceMenuCoordinator?
    
    @IBOutlet weak var nextBtn: PrimaryButton!
    @IBOutlet weak var moneyField: BigMoneyInputField!
    @IBOutlet weak var commissionView: UIView!
    @IBOutlet weak var commissionField: UILabel!
    @IBOutlet weak var discountCheck: UIImageView!
    @IBOutlet weak var discountField: DiscountField!
    
    var property: BeachHouseListing?
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    var id: String?
    
    var isDiscountChecked: Bool = false
    var finalDiscountPercent: Float = 0.1 // Total effective discount percentage for display
    var finalEarnings: Float = 0 // What the user actually earns
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Property"
        setup()
    }
    
    func setup() {
        // Get stored values
        let storedPrice = createBeachListing?.listingPrice ?? 0
        let storedDiscountPercent = Float(createBeachListing?.discountPercent ?? 0) / 100 // Additional discount percentage
        
        // Set the price field
        moneyField.text = storedPrice.toAmount() ?? ""
        
        // Determine if additional discount was applied
        if storedDiscountPercent > 0 {
            isDiscountChecked = true
            discountField.text = String(format: "%.1f", storedDiscountPercent * 100)
            
            // Calculate earnings with base charge and additional discount
            let amountAfterBaseCharge = storedPrice * 0.9
            let additionalDiscountAmount = amountAfterBaseCharge * storedDiscountPercent
            finalEarnings = amountAfterBaseCharge - additionalDiscountAmount
            finalDiscountPercent = (storedPrice - finalEarnings) / storedPrice
            
            print("Reverse Calculation Results:")
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
            
            print("Base charge only:")
            print("Price: ₦\(storedPrice)")
            print("User earnings: ₦\(finalEarnings)")
        }
        
        // Update UI based on discount state
        discountCheck.image = isDiscountChecked ? UIImage(named: "check_icon") : UIImage(named: "uncheck_icon")
        discountField.isHidden = !isDiscountChecked
        
        // Update commission display
        commissionField.text = String(format: "You earn ₦%.2f", finalEarnings)
        
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
        commissionView.isHidden = false // Show commission view since we have data
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
        guard let id = id else { return }
        if var createBeachListing = createBeachListing, let beachData = beachData {
            createBeachListing.listingPrice = moneyField.getFloatValue() ?? 0
            // Store only the additional discount percentage
            createBeachListing.discountPercent = isDiscountChecked ? Int((discountField.getFloatValue() ?? 0)) : 0
            
            if createBeachListing.bookingType?.isEmpty ?? true {
                createBeachListing.bookingType = "FULL"
            }
            print("Request is: \(createBeachListing)")
            print("Stored additional discount percent: \(createBeachListing.discountPercent)%")
            
            coordinator?.gotoEditEntireApartmentPricePerDayView(beachData: beachData, request: createBeachListing, id: id)
        }
    }
    
}

//import UIKit
//
//class EditEntireApartmentPriceView: UIViewController {
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
//    var property: BeachHouseListing?
//    var beachData: BeachDatas?
//    var createBeachListing: CreateBeachListingRequest?
//    var id: String?
//    
//    var isDiscountChecked: Bool = false
//    var finalDiscountPercent: Float = 0.1 // This will store the final discount percentage
//    var finalEarnings: Float = 0 // This will store what the user actually earns
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Edit Property"
//        setup()
//    }
//    
//    func setup() {
//        // Get stored values
//        let storedPrice = createBeachListing?.listingPrice ?? 0
//        let storedDiscountPercent = Float(createBeachListing?.discountPercent ?? 10) / 100 // Convert back to decimal
//        
//        // Set the price field
//        moneyField.text = storedPrice.toAmount() ?? ""
//        
//        // Determine if additional discount was applied
//        if storedDiscountPercent > 0.1 { // More than base 10% commission
//            isDiscountChecked = true
//            // Calculate the additional discount percentage
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
//            finalEarnings = storedPrice * (1 - finalDiscountPercent)
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
//            // Apply additional discount on top of the base 10% commission
//            let additionalDiscountPercent = (discountField.getFloatValue() ?? 0) / 100
//            let amountAfterBaseCommission = enteredAmount * 0.9 // User gets 90% after base commission
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
//            // Apply only the base 10% commission
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
//            coordinator?.gotoEditEntireApartmentPricePerDayView(beachData: beachData, request: createBeachListing, id: id)
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
//
//        }
//    }
//}
//

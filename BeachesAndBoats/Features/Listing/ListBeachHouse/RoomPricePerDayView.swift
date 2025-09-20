//
//  RoomPricePerDayView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 08/02/2025.
//


import UIKit

class RoomPricePerDayView: BaseViewControllerPlain {
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
    var room: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beaches Houses"
        setup()
    }
    
    func setup() {
        // Check if we're editing an existing room
        if let index = room, index >= 0, let rooms = createBeachListing?.rooms {
            let room = rooms[index]
            
            // Get stored values for editing
            let storedPrice = room.pricePerDay ?? 0
            let storedDiscountPercent = Float(room.dayDiscountPercent ?? 0) / 100 // Additional discount percentage
            
            // Set the price field with existing data
            moneyField.text = storedPrice.toAmount() ?? ""
            
            print("EDITING MODE - Loading stored day price data:")
            print("Stored price: ₦\(storedPrice)")
            print("Stored additional discount percent: \(storedDiscountPercent * 100)%")
            
            // Check if additional discount was applied
            if storedDiscountPercent > 0 {
                isDiscountChecked = true
                discountField.text = String(format: "%.1f", storedDiscountPercent * 100)
                
                // Calculate earnings with base charge and additional discount
                let amountAfterBaseCharge = storedPrice * 0.9
                let additionalDiscountAmount = amountAfterBaseCharge * storedDiscountPercent
                finalEarnings = amountAfterBaseCharge - additionalDiscountAmount
                finalDiscountPercent = (storedPrice - finalEarnings) / storedPrice
                
                print("Amount after base charge: ₦\(amountAfterBaseCharge)")
                print("Additional discount amount: ₦\(additionalDiscountAmount)")
                print("User earnings: ₦\(finalEarnings)")
            } else {
                // Only base charge was applied
                isDiscountChecked = false
                finalDiscountPercent = 0.1
                finalEarnings = storedPrice * (1 - finalDiscountPercent)
                
                print("Only base 10% charge applied")
                print("User earnings: ₦\(finalEarnings)")
            }
            
            // Update commission display
            commissionField.text = String(format: "You earn ₦%.2f", finalEarnings)
            commissionView.isHidden = false
        } else {
            // Creating fresh - no room data to load
            print("CREATING MODE - Fresh room creation")
            isDiscountChecked = false
            finalDiscountPercent = 0.1
            finalEarnings = 0
            moneyField.text = ""
            commissionView.isHidden = true
        }
        
        // Common UI setup for both create and edit modes
        stepOneProgress.setProgress(1, animated: false)
        stepOneProgress.tintColor = .success
        stepTwoProgress.setProgress(0.45, animated: true)
        stepTwoProgress.tintColor = .B_B
        
        discountField.keyboardType = .numberPad
        discountCheck.isUserInteractionEnabled = true
        discountCheck.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(discountCheckTapped)))
        
        discountCheck.image = isDiscountChecked ? UIImage(named: "check_icon") : UIImage(named: "uncheck_icon")
        discountField.isHidden = !isDiscountChecked
        
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
        
        loadSavedData()
    }
    
    @objc func discountCheckTapped() {
        isDiscountChecked.toggle()
        discountCheck.image = isDiscountChecked ? UIImage(named: "check_icon") : UIImage(named: "uncheck_icon")
        discountField.isHidden = !isDiscountChecked
        
        if let amount = moneyField.getDoubleValue() {
            updateCommission(with: String(amount))
        }
    }
    
    func updateCommission(with enteredText: String) {
        guard let enteredAmount = moneyField.getFloatValue(), enteredAmount > 0 else {
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
        guard let beachData = beachData, let createBeachListing = createBeachListing else { return }
        
        var updatedBeachListing = createBeachListing
        let roomIndex: Int = room ?? (createBeachListing.rooms?.count ?? 1) - 1
        
        print("Updating room price per day at index: \(roomIndex)")
        
        if roomIndex >= 0 && roomIndex < (updatedBeachListing.rooms?.count ?? 0) {
            var existingRoom = updatedBeachListing.rooms![roomIndex]
            existingRoom.pricePerDay = moneyField.getFloatValue() ?? 0
            existingRoom.dayDiscountPercent = isDiscountChecked ? Int((discountField.getFloatValue() ?? 0)) : 0
            updatedBeachListing.rooms![roomIndex] = existingRoom
            
            print("PRESERVED - Name: \(existingRoom.name ?? "")")
            print("PRESERVED - Night price: \(existingRoom.pricePerNight ?? 0)")
            print("UPDATED - Day price: \(existingRoom.pricePerDay ?? 0)")
            print("UPDATED - Day discount: \(existingRoom.dayDiscountPercent ?? 0)%")
        } else {
            print("Error: Room at index \(roomIndex) does not exist in room info.")
            return
        }
        
        coordinator?.gotoUploadImageView(beachData: beachData, createBeachListingData: updatedBeachListing, room: room)
    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        guard let createBeachListing = createBeachListing else { return }
        
        var updatedBeachListing = createBeachListing
        let roomIndex: Int = room ?? (createBeachListing.rooms?.count ?? 1) - 1
        
        if roomIndex >= 0 && roomIndex < (updatedBeachListing.rooms?.count ?? 0) {
            var existingRoom = updatedBeachListing.rooms![roomIndex]
            existingRoom.pricePerDay = moneyField.getFloatValue() ?? 0
            existingRoom.dayDiscountPercent = isDiscountChecked ? Int((discountField.getFloatValue() ?? 0)) : 0
            updatedBeachListing.rooms![roomIndex] = existingRoom
        }
        
        AppStorage.beachListing = updatedBeachListing
        coordinator?.backToDashboard()
    }
}


extension RoomPricePerDayView {
    func loadSavedData() {
        guard let savedListing = AppStorage.beachListing else { return }
        
        // If we're editing an existing room, load its day price data
        if let roomIndex = room, roomIndex >= 0, let rooms = savedListing.rooms, roomIndex < rooms.count {
            let roomData = rooms[roomIndex]
            
            // Load stored values
            let storedPrice = roomData.pricePerDay ?? 0
            let storedDiscountPercent = Float(roomData.dayDiscountPercent ?? 0) / 100
            
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
            }
            
            nextBtn.isEnabled = storedPrice > 0
        }
    }
}


//import UIKit
//
//class RoomPricePerDayView: BaseViewControllerPlain {
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
//    
//    var beachData: BeachDatas?
//    var createBeachListing: CreateBeachListingRequest?
//    
//    var isDiscountChecked: Bool = false
//    var finalDiscountPercent: Float = 0.1 // This will store the final discount percentage
//    var finalEarnings: Float = 0 // This will store what the user actually earns
//    var room: Int?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Beaches Houses"
//        setup()
//    }
//    
//    func setup(){
//        // Check if we're editing an existing room (room is not empty)
//        if let index = room,
//           index >= 0,
//           let rooms = createBeachListing?.rooms {
//            
//            let room = rooms[index]
//            
//            // Get stored values for editing
//            let storedPrice = room.pricePerDay ?? 0
//            let storedDiscountPercent = Float(room.dayDiscountPercent ?? 10) / 100 // Convert back to decimal
//            
//            // Set the price field with existing data
//            moneyField.text = String(storedPrice)
//            
//            print("EDITING MODE - Loading stored day price data:")
//            print("Stored price: ₦\(storedPrice)")
//            print("Stored total discount percent: \(storedDiscountPercent * 100)%")
//            
//            // Check if additional discount was applied beyond the base 10%
//            if storedDiscountPercent > 0.1000001 { // Use epsilon to avoid floating point precision issues
//                // Additional discount was applied
//                isDiscountChecked = true
//                
//                // CORRECTED REVERSE CALCULATION (same as night price)
//                let additionalDiscountDecimal = (storedDiscountPercent - 0.1) / 0.9
//                let additionalDiscountPercent = additionalDiscountDecimal * 100
//                
//                // Round to avoid floating point precision issues
//                let roundedAdditionalPercent = round(additionalDiscountPercent * 10) / 10
//                
//                discountField.text = String(format: "%.1f", roundedAdditionalPercent)
//                finalDiscountPercent = storedDiscountPercent
//                
//                print("Additional discount calculated: \(additionalDiscountPercent)%")
//                print("Rounded additional discount: \(roundedAdditionalPercent)%")
//                
//                // Verify the calculation
//                let verificationTotal = 0.1 + (0.9 * (roundedAdditionalPercent / 100))
//                print("Verification - should match stored discount: \(verificationTotal * 100)% vs \(storedDiscountPercent * 100)%")
//                
//            } else {
//                // Only base commission was applied
//                isDiscountChecked = false
//                finalDiscountPercent = 0.1
//                discountField.text = ""
//                
//                print("Only base 10% commission applied")
//            }
//            
//            // Calculate what user actually earns
//            finalEarnings = storedPrice * (1 - finalDiscountPercent)
//            
//            // Update commission display immediately for editing mode
//            commissionField.text = String(format: "You earn ₦%.2f", finalEarnings)
//            commissionView.isHidden = false // Show commission view since we have data
//            
//            print("Final earnings: ₦\(finalEarnings)")
//            print("---")
//            
//        } else {
//            // Creating fresh - no room data to load
//            print("CREATING MODE - Fresh room creation")
//            // Reset to default values
//            isDiscountChecked = false
//            finalDiscountPercent = 0.1
//            finalEarnings = 0
//            moneyField.text = ""
//            commissionView.isHidden = true
//        }
//        
//        // Common UI setup for both create and edit modes
//        stepOneProgress.setProgress(1, animated: false)
//        stepOneProgress.tintColor = .success
//        stepTwoProgress.setProgress(0.45, animated: true) // Different progress for day price
//        stepTwoProgress.tintColor = .B_B
//        
//        discountField.keyboardType = .numberPad
//        discountCheck.isUserInteractionEnabled = true
//        discountCheck.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(discountCheckTapped)))
//        
//        // Update UI based on discount state (important for edit mode)
//        discountCheck.image = isDiscountChecked ? UIImage(named: "check_icon") : UIImage(named: "uncheck_icon")
//        discountField.isHidden = !isDiscountChecked
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
//    }
//
//    
//
//    
//    @objc func discountCheckTapped() {
//        isDiscountChecked.toggle()
//        discountCheck.image = isDiscountChecked ? UIImage(named: "check_icon") : UIImage(named: "uncheck_icon")
//        discountField.isHidden = !isDiscountChecked
//        
//        // Recalculate commission when discount check state changes
//        if let amount = moneyField.getDoubleValue() {
//            updateCommission(with: String(amount))
//        }
//    }
//    
//    func updateCommission(with enteredText: String) {
//        guard let enteredAmount = moneyField.getFloatValue(), enteredAmount > 0 else {
//            commissionField.text = ""
//            commissionView.isHidden = true
//            finalEarnings = 0
//            finalDiscountPercent = 0.1
//            return
//        }
//        
////        print("Original Amount: ₦\(enteredAmount)")
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
//        } else {
//            // If discount is not checked, apply only the base 10% commission
//            finalDiscountPercent = 0.1
//            finalEarnings = enteredAmount * (1 - finalDiscountPercent)
//            
////            print("Base 10% commission applied: ₦\(enteredAmount * finalDiscountPercent)")
//        }
//        
//        // Update the UI
//        commissionView.isHidden = false
//        commissionField.text = String(format: "You earn ₦%.2f", finalEarnings)
//        
////        print("Final User Earnings: ₦\(finalEarnings)")
////        print("---")
//    }
//    
//    @IBAction func nextTapped(_ sender: Any) {
//        guard let beachData = beachData else { return }
//        guard let createBeachListing = createBeachListing else { return }
//        
//        var updatedBeachListing = createBeachListing
//        
//        // Determine which room index to update
//        let roomIndex: Int
//        if let editingRoomIndex = room, editingRoomIndex >= 0 {
//            roomIndex = editingRoomIndex
//        } else {
//            roomIndex = (createBeachListing.rooms?.count ?? 1) - 1
//        }
//        
//        print("Updating room price per day at index: \(roomIndex)")
//        
//        // Safely update the room price per day and discount
//        if roomIndex >= 0 && roomIndex < (updatedBeachListing.rooms?.count ?? 0) {
//            // PRESERVE existing room data, only update day price fields
//            var existingRoom = updatedBeachListing.rooms![roomIndex]
//            existingRoom.pricePerDay = moneyField.getFloatValue() ?? 0
//            existingRoom.dayDiscountPercent = Int(finalDiscountPercent * 100)
//            updatedBeachListing.rooms![roomIndex] = existingRoom
//            
//            print("PRESERVED - Name: \(existingRoom.name ?? "")")
//            print("PRESERVED - Night price: \(existingRoom.pricePerNight ?? 0)")
//            print("UPDATED - Day price: \(existingRoom.pricePerDay ?? 0)")
//            print("UPDATED - Day discount: \(existingRoom.dayDiscountPercent ?? 0)%")
//        } else {
//            print("Error: Room at index \(roomIndex) does not exist in room info.")
//            return
//        }
//        
//        coordinator?.gotoUploadImageView(beachData: beachData, createBeachListingData: updatedBeachListing, room: room)
//    }
//
//    @IBAction func saveAndExit(_ sender: Any) {
//        guard let createBeachListing = createBeachListing else { return }
//
//        var updatedBeachListing = createBeachListing
//        
//        // Determine which room index to update
//        let roomIndex: Int
//        if let editingRoomIndex = room, editingRoomIndex >= 0 {
//            roomIndex = editingRoomIndex
//        } else {
//            roomIndex = (createBeachListing.rooms?.count ?? 1) - 1
//        }
//        
//        // Safely update the room price per day and discount
//        if roomIndex >= 0 && roomIndex < (updatedBeachListing.rooms?.count ?? 0) {
//            var existingRoom = updatedBeachListing.rooms![roomIndex]
//            existingRoom.pricePerDay = moneyField.getFloatValue() ?? 0
//            existingRoom.dayDiscountPercent = Int(finalDiscountPercent * 100)
//            updatedBeachListing.rooms![roomIndex] = existingRoom
//        }
//        
//        AppStorage.beachListing = updatedBeachListing
//        coordinator?.backToDashboard()
//    }
//    
//}

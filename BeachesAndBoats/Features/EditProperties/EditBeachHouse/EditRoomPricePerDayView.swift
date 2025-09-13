//
//  EditRoomPricePerDayView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 23/07/2025.
//

import UIKit
//import RxSwift

class EditRoomPricePerDayView: BaseViewControllerPlain {
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
    var details: GetBeachData?
//    var disposeBag = DisposeBag()
//    var vm = EditBeachViewModel()
    
    var isDiscountChecked: Bool = false
    var finalDiscountPercent: Float = 0.1 // Total effective discount percentage for display
    var finalEarnings: Float = 0 // What the user actually earns
    var id: String?
    
    var room: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Property"
        setup()
    }
    
    func setup() {
        guard let roomNameToFind = room, let rooms = createBeachListing?.rooms,
              let index = rooms.firstIndex(where: { $0.name == roomNameToFind }) else {
            print("Error: Room not found or invalid data")
            return
        }

        let room = rooms[index]
        
        // Get stored values
        let storedPrice = room.pricePerDay ?? 0
        let storedDiscountPercent = Float(room.dayDiscountPercent ?? 0) / 100 // Additional discount percentage
        
        // Set the price field
        moneyField.text = storedPrice.toAmount() ?? ""
        
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
        
        if let amount = moneyField.getDoubleValue() {
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
        guard let beachData = beachData, let createBeachListing = createBeachListing,
              let roomNameToFind = room, let rooms = createBeachListing.rooms,
              let roomIndex = rooms.firstIndex(where: { $0.name == roomNameToFind }) else {
            print("Error: Invalid data or room not found")
            return
        }
        
        var updatedBeachListing = createBeachListing
        var updatedRoomInfo = rooms
        
        // Update the room price and discount
        var existingRoom = updatedRoomInfo[roomIndex]
        existingRoom.pricePerDay = moneyField.getFloatValue() ?? 0
        existingRoom.dayDiscountPercent = isDiscountChecked ? Int((discountField.getFloatValue() ?? 0)) : 0
        updatedRoomInfo[roomIndex] = existingRoom
        
        updatedBeachListing.rooms = updatedRoomInfo
        self.createBeachListing = updatedBeachListing
        
        print("Updated Room: \(existingRoom)")
        print("Request Room: \(self.createBeachListing)")
        print("Stored additional day discount percent: \(existingRoom.dayDiscountPercent)%")
        
        let roomImages = details?.rooms?
            .first(where: { $0.name == room })?
            .images?
            .compactMap { $0.url } ?? []
        
        coordinator?.gotoEditUploadImageView(beachData: beachData, request: createBeachListing, currentImages: roomImages, id: id)
}
    
    
}
//import UIKit
//
//class EditRoomPricePerDayView: BaseViewControllerPlain {
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
//    
//    var isDiscountChecked: Bool = false
//    var finalDiscountPercent: Float = 0.1 // This will store the final discount percentage
//    var finalEarnings: Float = 0 // This will store what the user actually earns
//    var id: String?
//    
//    var room: String?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Edit Property"
//        setup()
//    }
//    
//    func setup(){
//        guard let roomNameToFind = room,
//              let rooms = createBeachListing?.rooms,
//              let index = rooms.firstIndex(where: { $0.name == roomNameToFind }) else {
//            return
//        }
//
//        let room = rooms[index]
//        
//        // Get stored values
//        let storedPrice = room.pricePerDay ?? 0
//        let storedDiscountPercent = Float(room.dayDiscountPercent ?? 10) / 100 // Convert back to decimal
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
////            print("Base 10% commission applied: ₦\(enteredAmount * 0.1)")
////            print("Amount after base commission: ₦\(amountAfterBaseCommission)")
////            print("Additional discount (\(additionalDiscountPercent * 100)%): ₦\(additionalDiscountAmount)")
////            print("Total commission: ₦\(totalCommissionAmount)")
////            print("Final discount percentage: \(finalDiscountPercent * 100)%")
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
//        // Get the last index of the rooms array
//        let roomIndex = createBeachListing.rooms?.indices.last ?? -1
//        print("Current room index is \(roomIndex)")
//        
//        // Safely get a mutable copy of the rooms array
//        var updatedRoomInfo = createBeachListing.rooms
//        if roomIndex >= 0 && roomIndex < updatedRoomInfo?.count ?? 0 {
//            // Update the room price and discount at the current room index
//            if var existingRoom = updatedRoomInfo?[roomIndex]{
//                existingRoom.pricePerDay = moneyField.getFloatValue() ?? 0
//                // Store the final discount percentage (converted to percentage for storage)
//                existingRoom.dayDiscountPercent = Int(finalDiscountPercent * 100)
//                
//                // Reassign the updated room back to the array
//                updatedRoomInfo?[roomIndex] = existingRoom
//                
//            }
//        } else {
//            return
//        }
//        
//        // Create a mutable copy of the createBeachListing and update its rooms
//        var updatedBeachListing = createBeachListing
//        updatedBeachListing.rooms = updatedRoomInfo
//        
//        self.createBeachListing = updatedBeachListing
//        
//        print(self.createBeachListing)
//        
//        coordinator?.popToRoomsListScreen()
//    }
//    
//}


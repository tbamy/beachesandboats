//
//  EditRoomPriceView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 23/07/2025.
//

import UIKit

class EditRoomPriceView: BaseViewControllerPlain {
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
              let index = rooms.firstIndex(where: { $0.id == roomNameToFind }) else {
            print("Error: Room not found or invalid data")
            return
        }
        
        let room = rooms[index]
        
        // Get stored values
        let storedPrice = room.pricePerNight ?? 0
        let storedDiscountPercent = Float(room.discountPercent ?? 0) / 100 // Additional discount percentage
        
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
            
            print("EDITING MODE - Loading stored night price data:")
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
        guard let id = id, let beachData = beachData, let createBeachListing = createBeachListing,
              let roomNameToFind = room, let rooms = createBeachListing.rooms,
              let roomIndex = rooms.firstIndex(where: { $0.id == roomNameToFind }) else {
            print("Error: Invalid data or room not found")
            return
        }
        
        // Get the existing room to preserve its data
        var existingRoom = rooms[roomIndex]
        
        // Update only the price and discount fields
        existingRoom.pricePerNight = moneyField.getFloatValue() ?? 0
        existingRoom.discountPercent = isDiscountChecked ? Int((discountField.getFloatValue() ?? 0)) : 0
        
        // Update the rooms array
        var updatedRoomInfo = rooms
        updatedRoomInfo[roomIndex] = existingRoom
        
        // Update createBeachListing with the modified rooms
        var updatedBeachListing = createBeachListing
        updatedBeachListing.rooms = updatedRoomInfo
        
        print("Updated Room: \(existingRoom)")
        print("Updated CreateBeachListing: \(updatedBeachListing)")
        
        coordinator?.gotoEditRoomPricePerDayView(beachData: beachData, request: updatedBeachListing, room: room, id: id, details: details)
    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        guard let createBeachListing = createBeachListing,
              let roomNameToFind = room, let rooms = createBeachListing.rooms,
              let roomIndex = rooms.firstIndex(where: { $0.name == roomNameToFind }) else {
            print("Error: Invalid data or room not found")
            return
        }
        
        // Get the existing room to preserve its data
        var existingRoom = rooms[roomIndex]
        
        // Update only the price and discount fields
        existingRoom.pricePerNight = moneyField.getFloatValue() ?? 0
        existingRoom.discountPercent = isDiscountChecked ? Int((discountField.getFloatValue() ?? 0)) : 0
        
        // Update the rooms array
        var updatedRoomInfo = rooms
        updatedRoomInfo[roomIndex] = existingRoom
        
        // Update createBeachListing with the modified rooms
        var updatedBeachListing = createBeachListing
        updatedBeachListing.rooms = updatedRoomInfo
        self.createBeachListing = updatedBeachListing
        
        print("Updated Room: \(existingRoom)")
        print("Updated CreateBeachListing: \(updatedBeachListing)")
        
        coordinator?.popToRoomsListScreen()
    }
}

//
//  EditRoomPricePerDayView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 23/07/2025.
//

import UIKit

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
    
    var isDiscountChecked: Bool = false
    var finalDiscountPercent: Float = 0.1 // This will store the final discount percentage
    var finalEarnings: Float = 0 // This will store what the user actually earns
    
    var room: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Property"
        setup()
    }
    
    func setup(){
        
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
        commissionView.isHidden = true
    }
    
    @objc func discountCheckTapped() {
        isDiscountChecked.toggle()
        discountCheck.image = isDiscountChecked ? UIImage(named: "check_icon") : UIImage(named: "uncheck_icon")
        discountField.isHidden = !isDiscountChecked
        
        // Recalculate commission when discount check state changes
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
        
//        print("Original Amount: ₦\(enteredAmount)")
        
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
            
//            print("Base 10% commission applied: ₦\(enteredAmount * 0.1)")
//            print("Amount after base commission: ₦\(amountAfterBaseCommission)")
//            print("Additional discount (\(additionalDiscountPercent * 100)%): ₦\(additionalDiscountAmount)")
//            print("Total commission: ₦\(totalCommissionAmount)")
//            print("Final discount percentage: \(finalDiscountPercent * 100)%")
        } else {
            // If discount is not checked, apply only the base 10% commission
            finalDiscountPercent = 0.1
            finalEarnings = enteredAmount * (1 - finalDiscountPercent)
            
//            print("Base 10% commission applied: ₦\(enteredAmount * finalDiscountPercent)")
        }
        
        // Update the UI
        commissionView.isHidden = false
        commissionField.text = String(format: "You earn ₦%.2f", finalEarnings)
        
//        print("Final User Earnings: ₦\(finalEarnings)")
//        print("---")
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        guard let beachData = beachData else { return }
        guard let createBeachListing = createBeachListing else { return }
        
        // Get the last index of the rooms array
        let roomIndex = createBeachListing.rooms?.indices.last ?? -1
        print("Current room index is \(roomIndex)")
        
        // Safely get a mutable copy of the rooms array
        var updatedRoomInfo = createBeachListing.rooms
        if roomIndex >= 0 && roomIndex < updatedRoomInfo?.count ?? 0 {
            // Update the room price and discount at the current room index
            if var existingRoom = updatedRoomInfo?[roomIndex]{
                existingRoom.pricePerDay = moneyField.getFloatValue() ?? 0
                // Store the final discount percentage (converted to percentage for storage)
                existingRoom.dayDiscountPercent = finalDiscountPercent * 100
                
                // Reassign the updated room back to the array
                updatedRoomInfo?[roomIndex] = existingRoom
                
            }
        } else {
            return
        }
        
        // Create a mutable copy of the createBeachListing and update its rooms
        var updatedBeachListing = createBeachListing
        updatedBeachListing.rooms = updatedRoomInfo
        
        self.createBeachListing = updatedBeachListing
        
        print(self.createBeachListing)
        
        coordinator?.popToRoomsListScreen()
    }
    
}


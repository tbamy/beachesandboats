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
    var discount: Double = 0
    var discountedAmount: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beaches Houses"
        setup()

    }
    
    func setup(){
        stepOneProgress.setProgress(1, animated: false)
        stepOneProgress.tintColor = .success
        stepTwoProgress.setProgress(0.45, animated: true)
        stepTwoProgress.tintColor = .B_B
        
        discountCheck.isUserInteractionEnabled = true
        discountCheck.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(discountCheckTapped)))
        discountCheck.image = isDiscountChecked ? UIImage(named: "check_icon") : UIImage(named: "uncheck_icon")
        discountField.isHidden = !isDiscountChecked
        
//        nextBtn.isEnabled = true
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
    }
    
    func updateCommission(with enteredText: String) {
        guard let enteredAmount = moneyField.getDoubleValue(), enteredAmount > 0 else {
            commissionField.text = ""
            commissionView.isHidden = true
            return
        }
        
        if isDiscountChecked{
            discount = (discountField.getDoubleValue() ?? 0)  / 100
        }else{
            discount = 0.1
        }
        
        print("Valid Entered Amount: \(enteredAmount)")
        
        discountedAmount = enteredAmount - (enteredAmount * discount)
        
        // Update the commissionField to display the discounted amount
        commissionView.isHidden = false
        commissionField.text = String(format: "You earn ₦%.2f", discountedAmount)
        print("Discounted Amount: \(discountedAmount)")
        
    }

    
    @IBAction func nextTapped(_ sender: Any) {
        guard let beachData = beachData else { return }
        guard let createBeachListing = createBeachListing else { return }
        
        // Get the last index of the rooms array
        let roomIndex = createBeachListing.rooms.indices.last ?? -1
        print("Current room index is \(roomIndex)")
        
        // Safely get a mutable copy of the rooms array
        var updatedRoomInfo = createBeachListing.rooms
        if roomIndex >= 0 && roomIndex < updatedRoomInfo.count {
            // Update the room price and discount at the current room index
            var existingRoom = updatedRoomInfo[roomIndex]
            existingRoom.pricePerDay = moneyField.getFloatValue() ?? 0
            existingRoom.dayDiscountPercent = 10
            
            // Reassign the updated room back to the array
            updatedRoomInfo[roomIndex] = existingRoom
            
            print("Updated Room: \(existingRoom)")
        } else {
            print("Error: Room at index \(roomIndex) does not exist in room info.")
            return
        }
        
        // Create a mutable copy of the createBeachListing and update its rooms
        var updatedBeachListing = createBeachListing
        updatedBeachListing.rooms = updatedRoomInfo
        
        print("Updated CreateBeachListing: \(updatedBeachListing)")
        
        coordinator?.gotoUploadImageView(beachData: beachData, createBeachListingData: updatedBeachListing)
    }
    
    
    @IBAction func saveAndExit(_ sender: Any) {
        guard let createBeachListing = createBeachListing else { return }
        
        // Get the last index of the rooms array
        let roomIndex = createBeachListing.rooms.indices.last ?? -1
        print("Current room index is \(roomIndex)")
        
        // Safely get a mutable copy of the rooms array
        var updatedRoomInfo = createBeachListing.rooms
        if roomIndex >= 0 && roomIndex < updatedRoomInfo.count {
            // Update the room price and discount at the current room index
            var existingRoom = updatedRoomInfo[roomIndex]
            existingRoom.pricePerDay = moneyField.getFloatValue() ?? 0
            existingRoom.dayDiscountPercent = 10
            
            // Reassign the updated room back to the array
            updatedRoomInfo[roomIndex] = existingRoom
            
            print("Updated Room: \(existingRoom)")
        } else {
            print("Error: Room at index \(roomIndex) does not exist in room info.")
            return
        }
        
        // Create a mutable copy of the createBeachListing and update its rooms
        var updatedBeachListing = createBeachListing
        updatedBeachListing.rooms = updatedRoomInfo
            
            AppStorage.beachListing = updatedBeachListing
            coordinator?.backToDashboard()

    }
}

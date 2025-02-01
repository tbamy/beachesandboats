//
//  RoomPriceView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 08/10/2024.
//

import UIKit

class RoomPriceView: BaseViewControllerPlain {
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var nextBtn: PrimaryButton!
    @IBOutlet weak var moneyField: BigMoneyInputField!
    @IBOutlet weak var commissionView: UIView!
    @IBOutlet weak var commissionField: UILabel!
    
    
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    let discount: Double = 0.9
    var discountedAmount: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beaches Houses"
        setup()

    }
    
    func setup(){
        stepOneProgress.setProgress(1, animated: false)
        stepOneProgress.tintColor = .success
        stepTwoProgress.setProgress(0.35, animated: true)
        stepTwoProgress.tintColor = .B_B
        
        nextBtn.isEnabled = true
        moneyField.updateHeight(to: 70)
        moneyField.amountChanged = { [weak self] in
            if let amount = self?.moneyField.getDoubleValue() {
                self?.updateCommission(with: String(amount))
            }
        }
        
        commissionView.layer.borderWidth = 1
        commissionView.layer.borderColor = UIColor.background.cgColor
        
        commissionView.isHidden = true
        
    }
    
    func updateCommission(with enteredText: String) {
        guard let enteredAmount = moneyField.getDoubleValue(), enteredAmount > 0 else {
            commissionField.text = ""
            commissionView.isHidden = true
            return
        }
        
        print("Valid Entered Amount: \(enteredAmount)")
        
        discountedAmount = enteredAmount * discount
        
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
            existingRoom.pricePerNight = moneyField.getFloatValue() ?? 0
            existingRoom.discountPercent = 10
            
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
            existingRoom.pricePerNight = moneyField.getFloatValue() ?? 0
            existingRoom.discountPercent = 10
            
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

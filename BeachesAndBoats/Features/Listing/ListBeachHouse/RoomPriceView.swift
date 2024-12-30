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
        moneyField.onTextChanged = { [weak self] enteredText in
            self?.updateCommission(with: enteredText)
        }
        
        commissionView.layer.borderWidth = 1
        commissionView.layer.borderColor = UIColor.background.cgColor
        
        commissionView.isHidden = true
                    
    }
    
    func updateCommission(with enteredText: String) {
        // Remove the Naira symbol and commas if present
        let cleanText = enteredText.replacingOccurrences(of: "₦", with: "").replacingOccurrences(of: ",", with: "")
        
        // Convert the cleaned text to a Double
        guard let enteredAmount = Double(cleanText) else {
            commissionField.text = ""
            return
        }
        
        // Apply a 10% discount (adjust percentage as needed)
        discountedAmount = enteredAmount * discount
        
        // Update the commissionField to display the discounted amount with 2 decimal places
        commissionView.isHidden = false
        commissionField.text = String(format: "You earn ₦%", discountedAmount)
    }
            

            

    
    @IBAction func nextTapped(_ sender: Any) {
        if let beachData = beachData{
            
            let roomIndex = createBeachListing?.rooms.indices.last ?? -1 
            print("Current room index is \(roomIndex)")
//            guard let beachData = beachData, let roomIndex = currentRoomIndex else { return }
            
            var updatedRoomInfo = createBeachListing?.rooms ?? []
            if roomIndex < updatedRoomInfo.count {
                    // Append selected items to the amenities of the room at the specified index
                var existingRoom = updatedRoomInfo[roomIndex]
                
                existingRoom.pricePerNight = Double(moneyField.text) ?? 0
                existingRoom.discountPercent = Double(discount)
                        
                } else {
                    print("Error: Room at index \(roomIndex) does not exist in roominfo.")
                    return
                }
            
            if var createBeachListing = createBeachListing{
                createBeachListing.rooms = updatedRoomInfo
                print(createBeachListing)
                
                coordinator?.gotoUploadImageView(beachData: beachData, createBeachListingData: createBeachListing)
            }
            
        }
    }

}

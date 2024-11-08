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
            
            var roomIndex = createBeachListing?.roominfo.last?.id ?? 10000
            print("Current room index is \(roomIndex)")
//            guard let beachData = beachData, let roomIndex = currentRoomIndex else { return }
            
            var updatedRoomInfo = createBeachListing?.roominfo ?? []
            if roomIndex < updatedRoomInfo.count {
                    // Append selected items to the amenities of the room at the specified index
                var existingRoom = updatedRoomInfo[roomIndex]
                let updatedRoom = RoomData(
                    id: existingRoom.id,
                    name: existingRoom.name,
                    description: existingRoom.description,
                    amenities: existingRoom.amenities,
                    price_per_night: Double(moneyField.text) ?? 0,
                    discount: existingRoom.discount,
                    amount_to_earn: Double(discountedAmount),
                    room_images: existingRoom.room_images,
                    number_of_guests: existingRoom.number_of_guests,
                    number_of_rooms: existingRoom.number_of_rooms,
                    number_of_beds: existingRoom.number_of_beds
                    
                )
                updatedRoomInfo[roomIndex] = updatedRoom
                        
                } else {
                    print("Error: Room at index \(roomIndex) does not exist in roominfo.")
                    return
                }
            
            let request = CreateBeachListingRequest(category_id: createBeachListing?.category_id ?? "", sub_cat_id: createBeachListing?.sub_cat_id ?? "", guest_booking_id: createBeachListing?.guest_booking_id ?? "", name: createBeachListing?.name ?? "", description: createBeachListing?.description ?? "", country: createBeachListing?.country ?? "", state: createBeachListing?.state ?? "", city: createBeachListing?.city ?? "", street_address: createBeachListing?.street_address ?? "", from_when: "", to_when: "", amenities: createBeachListing?.amenities ?? [], preferred_languages: createBeachListing?.preferred_languages ?? [], brief_introduction: createBeachListing?.brief_introduction ?? "", house_rules: createBeachListing?.house_rules ?? [], check_in_start: createBeachListing?.check_in_start ?? "", check_in_end: createBeachListing?.check_in_end ?? "", check_out_start: createBeachListing?.check_out_start ?? "", check_out_end: createBeachListing?.check_out_end ?? "", roominfo: updatedRoomInfo, full_apartment_cost: 0, full_apartment_discount: 0, full_apartment_amount_to_earn: 0)
            
            
            coordinator?.gotoUploadImageView(beachData: beachData, createBeachListingData: request)
        }
    }

}

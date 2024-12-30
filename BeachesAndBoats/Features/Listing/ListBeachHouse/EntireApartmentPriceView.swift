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
    let discount: Double = 0.9
    var discountedAmount: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beaches Houses"
        setup()
        
    }

    func setup(){
        
        discountCheck.image = isDiscountChecked ? UIImage(named: "check_icon") : UIImage(named: "uncheck_icon")
        discountField.isHidden = !isDiscountChecked
        
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
            
            if var createBeachListing = createBeachListing{
                print("Final Request is: \(createBeachListing)")
                
            }
        }
    }

}

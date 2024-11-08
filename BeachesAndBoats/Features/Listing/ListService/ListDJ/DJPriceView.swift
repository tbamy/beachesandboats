//
//  DJPriceVIew.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/10/2024.
//

import UIKit

class DJPriceView: BaseViewControllerPlain {
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var nextBtn: PrimaryButton!
    @IBOutlet weak var moneyField: BigMoneyInputField!
    @IBOutlet weak var commissionView: UIView!
    @IBOutlet weak var commissionField: UILabel!
    
    
    var createServiceListing: CreateServiceListingRequest?
    let discount: Double = 0.9
    
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
//        moneyField.amountChanged = { [weak self] in
//            self?.updateCommission(with: self?.moneyField.text ?? "")
//        }
        
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
        let discountedAmount = enteredAmount * discount
        
        // Update the commissionField to display the discounted amount with 2 decimal places
        commissionView.isHidden = false
        commissionField.text = String(format: "You earn ₦%", discountedAmount)
    }
            

            

    
    @IBAction func nextTapped(_ sender: Any) {

        let request = CreateServiceListingRequest(name: createServiceListing?.name ?? "", description: createServiceListing?.description ?? "", profile_image: createServiceListing?.profile_image ?? Data(), from_when: createServiceListing?.from_when ?? "", to_when: createServiceListing?.to_when ?? "", dishes: [], price: moneyField.getIntValue() ?? 0, sample_images: [], type: "", gender: createServiceListing?.gender ?? "")
        
        coordinator?.gotoDJUploadInstrumentsView(createServiceListingData: request)
    }

}

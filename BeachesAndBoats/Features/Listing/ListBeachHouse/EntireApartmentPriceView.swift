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
    var discount: Double = 0
    var discountedAmount: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beaches Houses"
        setup()
        
    }

    func setup(){
        discountCheck.isUserInteractionEnabled = true
        discountCheck.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(discountCheckTapped)))
        discountCheck.image = isDiscountChecked ? UIImage(named: "check_icon") : UIImage(named: "uncheck_icon")
        discountField.isHidden = !isDiscountChecked
        
        stepOneProgress.setProgress(1, animated: false)
        stepOneProgress.tintColor = .success
        stepTwoProgress.setProgress(0.85, animated: true)
        stepTwoProgress.tintColor = .B_B
        
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
        // Validate the entered text
        print("Entered Text: \(enteredText)")
        
        guard let enteredAmount = moneyField.getDoubleValue(), enteredAmount > 0 else {
            print("Invalid or zero amount entered.")
            commissionField.text = ""
            commissionView.isHidden = true
            return
        }
        
        print("Valid Entered Amount: \(enteredAmount)")
        
        // Apply the 10% discount
//        discount = discountField.getDoubleValue() ?? 0.9
        if isDiscountChecked{
            discount = (discountField.getDoubleValue() ?? 0)  / 100
        }else{
            discount = 0.1
        }
        discountedAmount = enteredAmount - (enteredAmount * discount)
        
        // Update the commissionField to display the discounted amount
        commissionView.isHidden = false
        commissionField.text = String(format: "You earn ₦%.2f", discountedAmount)
        print("Discounted Amount: \(discountedAmount)")
        
    }

    
    @IBAction func nextTapped(_ sender: Any) {
        if var createBeachListing = createBeachListing, let beachData = beachData{
            createBeachListing.listingPrice = moneyField.getFloatValue() ?? 0
            createBeachListing.discountPercent = discountField.getIntValue() ?? 10
            
            if createBeachListing.bookingType?.isEmpty ?? true {
                createBeachListing.bookingType = "FULL"
            }
            print("Request is: \(createBeachListing)")
            
            coordinator?.gotoEntireApartmentPricePerDayView(beachData: beachData, createBeachListingData: createBeachListing)

            
        }
    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        if var createBeachListing = createBeachListing{
            createBeachListing.listingPrice = moneyField.getFloatValue() ?? 0
            
            if createBeachListing.bookingType?.isEmpty ?? true {
                createBeachListing.bookingType = "FULL"
            }
            
            AppStorage.beachListing = createBeachListing
            coordinator?.backToDashboard()
        }

    }

}

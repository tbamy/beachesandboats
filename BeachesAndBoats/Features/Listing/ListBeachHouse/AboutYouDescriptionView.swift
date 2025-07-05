//
//  AboutYouDescriptionView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/10/2024.
//

import UIKit

class AboutYouDescriptionView: BaseViewControllerPlain {
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var descriptionLabel: TextViewField!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beach Houses"
        setUp()
    }
    
    func setUp(){
        stepOneProgress.setProgress(0.80, animated: true)
        stepOneProgress.tintColor = .B_B
        stepTwoProgress.setProgress(0, animated: false)
        
//        if descriptionLabel.text.isEmpty{
//            descriptionLabel.error = "Enter a description"
//            nextBtn.isEnabled = false
//        }else{
//            nextBtn.isEnabled = true
//        }
        
        descriptionLabel.textChanged = { [weak self] textField, range, replacementString in
            guard let self = self else { return }
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: replacementString)
            
            nextBtn.isEnabled = updatedText.count >= 5
        }
    }

    @IBAction func nextTapped(_ sender: Any) {
        if let beachData = beachData{
            if var createBeachListing = createBeachListing{
                createBeachListing.aboutOwner = descriptionLabel.text
                print(createBeachListing)
                
                coordinator?.gotoHouseRulesView(beachData: beachData, createBeachListingData: createBeachListing)
            }
        }
    }
    
    
    @IBAction func saveAndExit(_ sender: Any) {
        if var createBeachListing = createBeachListing{
            createBeachListing.aboutOwner = descriptionLabel.text
            
            AppStorage.beachListing = createBeachListing
            coordinator?.backToDashboard()
        }

    }


}

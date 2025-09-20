//
//  PropertyNameView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/10/2024.
//

import UIKit

class PropertyNameView: BaseViewControllerPlain {

    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var nameLabel: InputField!
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
        stepOneProgress.setProgress(0.40, animated: true)
        stepOneProgress.tintColor = .B_B
        stepTwoProgress.setProgress(0, animated: false)
//        nextBtn.isEnabled = false
        descriptionLabel.numberOfCharacters = 255
        
        descriptionLabel.textChanged = { [weak self] textField, range, replacementString in
            guard let self = self else { return }
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: replacementString)
            
            nextBtn.isEnabled = updatedText.count >= 5
        }
        loadSavedData()
        
//        descriptionLabel.onTextChanged = { [weak self] text in
//            self?.checkTextFields()
//        }
        
        
//                
//        checkTextFields()
    }
    
    func checkTextFields() {
        let isNameFilled = !nameLabel.text.isEmpty
        let isDescriptionFilled = !descriptionLabel.text.isEmpty
        
        nextBtn.isEnabled = isNameFilled && isDescriptionFilled
    }
    
    func validate() -> Bool{
        let isNameFilled = nameLabel.validate(rules: [Rule(.isEmpty, "Name cannot be empty")])
        let isDescriptionFilled = descriptionLabel.validate(rules: [Rule(.isEmpty, "Enter a description")])
        
        return isNameFilled && isDescriptionFilled
    }


    @IBAction func nextTapped(_ sender: Any) {
        if validate(){
            if let beachData = beachData{
                if var createBeachListing = createBeachListing{
                    createBeachListing.name = nameLabel.text
                    createBeachListing.description = descriptionLabel.text
                    print(createBeachListing)
                    
                    coordinator?.gotoPropertyAddressView(beachData: beachData, createBeachListingData: createBeachListing)
                }
                
            }
        }
    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        if var createBeachListing = createBeachListing{
            createBeachListing.name = nameLabel.text
            createBeachListing.description = descriptionLabel.text
            
            AppStorage.beachListing = createBeachListing
            coordinator?.backToDashboard()
        }

    }
    
}

extension PropertyNameView {
    func loadSavedData() {
        guard let savedListing = AppStorage.beachListing else { return }
        
        // Populate name field
        if ((savedListing.name?.isEmpty) == nil) {
            nameLabel.text = savedListing.name ?? ""
        }
        
        // Populate description field
        if ((savedListing.description?.isEmpty) == nil) {
            descriptionLabel.text = savedListing.description ?? ""
        }
        
        // Update button state
        checkTextFields()
    }
}

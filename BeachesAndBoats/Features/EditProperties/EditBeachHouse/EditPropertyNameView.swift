//
//  EditPropertyNameView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 23/07/2025.
//

import UIKit

class EditPropertyNameView: BaseViewControllerPlain {

    var coordinator: HostingServiceMenuCoordinator?
    
    @IBOutlet weak var nameLabel: InputField!
    @IBOutlet weak var descriptionLabel: TextViewField!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Property"
        setUp()
    }
    
    func setUp(){
        
        print(createBeachListing)
        
        nameLabel.text = createBeachListing?.name ?? ""
        descriptionLabel.text = createBeachListing?.description ?? ""
        
        descriptionLabel.textChanged = { [weak self] textField, range, replacementString in
            guard let self = self else { return }
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: replacementString)
            
            nextBtn.isEnabled = updatedText.count >= 5
        }
        
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
                    
                    self.createBeachListing = createBeachListing
                    print(createBeachListing)
                    
                    coordinator?.pop()
                    
                }
                
            }
        }
    }
    
}


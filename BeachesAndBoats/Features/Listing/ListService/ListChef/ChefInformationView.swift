//
//  ChefInformationView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/10/2024.
//

import UIKit

class ChefInformationView: BaseViewControllerPlain {

    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var nameLabel: InputField!
    @IBOutlet weak var descriptionLabel: TextViewField!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var createServiceListing: CreateServiceListingRequest?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chefs"
        setUp()
    }
    
    func setUp(){
        stepOneProgress.setProgress(0.40, animated: true)
        stepOneProgress.tintColor = .B_B
        stepTwoProgress.setProgress(0, animated: false)
        
//        nameLabel.onTextChanged = { [weak self] text in
//            self?.checkTextFields()
//        }
//
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
    
    func validate(){
        
    }
    
    


    @IBAction func nextTapped(_ sender: Any) {

        let request = CreateServiceListingRequest(roleType: HostType.chef.rawValue, name: nameLabel.text, description: descriptionLabel.text, categoryId: "", availableFrom: "", availableTo: "", images: [], startingPrice: 0, dishes: [], gender: "")
        
        print(request)
        
        coordinator?.gotoChefUploadProfileImageView(createServiceListingData: request)
        
    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        let request = CreateServiceListingRequest(roleType: HostType.chef.rawValue, name: nameLabel.text, description: descriptionLabel.text, categoryId: "", availableFrom: "", availableTo: "", images: [], startingPrice: 0, dishes: [], gender: "")
        
        AppStorage.serviceListing = request
        coordinator?.backToDashboard()
    }
    
}

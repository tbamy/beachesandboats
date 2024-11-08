//
//  BouncerInformationView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/10/2024.
//

import UIKit

class BouncerInformationView: BaseViewControllerPlain {

    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var nameLabel: InputField!
    @IBOutlet weak var descriptionLabel: TextViewField!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var createServiceListing: CreateServiceListingRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bouncers"
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
    
        let request = CreateServiceListingRequest(name: nameLabel.text, description: descriptionLabel.text, profile_image: Data(), from_when: "", to_when: "", dishes: [], price: 0, sample_images: [], type: "", gender: "")
        coordinator?.gotoBouncerGenderView(createServiceListingData: request)
    }
    
}

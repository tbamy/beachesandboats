//
//  BouncerGenderView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/10/2024.
//

import UIKit

class BouncerGenderView: BaseViewControllerPlain {
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var maleBtn: CheckboxButton!
    @IBOutlet weak var femaleBtn: CheckboxButton!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var createServiceListing: CreateServiceListingRequest?
    
    var gender: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bouncers"
        setup()
    }
    
    func setup(){
        stepOneProgress.setProgress(0.60, animated: true)
        stepOneProgress.tintColor = .B_B
        stepTwoProgress.setProgress(0, animated: false)
        
        maleBtn.isUserInteractionEnabled = true
        femaleBtn.isUserInteractionEnabled = true
        
        maleBtn.stateChanged = { [weak self] isSelected in
            guard let self = self else { return }
            self.gender = "male"
            femaleBtn.isChecked = false
            nextBtn.isEnabled = true
        }
        
        femaleBtn.stateChanged = { [weak self] isSelected in
            guard let self = self else { return }
            self.gender = "female"
            maleBtn.isChecked = false
            nextBtn.isEnabled = true
        }
    }

    @IBAction func nextTapped(_ sender: Any) {
        if (gender != ""){
            
            if var createServiceListing = createServiceListing{
                createServiceListing.gender = gender
                
                print(createServiceListing)
                
                coordinator?.gotoBouncerUploadProfileImageView(createServiceListingData: createServiceListing)
            }
            
        }
        
    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        if var createServiceListing = createServiceListing{
            createServiceListing.gender = gender
            
            print(createServiceListing)
            
            AppStorage.serviceListing = createServiceListing
            coordinator?.backToDashboard()
        }
        
        
    }
    

}

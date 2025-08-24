//
//  DJInformationVIew.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/10/2024.
//

import UIKit
import RxSwift

class DJInformationVIew: BaseViewControllerPlain {

    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var nameLabel: InputField!
    @IBOutlet weak var descriptionLabel: TextViewField!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var createServiceListing: CreateServiceListingRequest?
    
    var vm = ChefDishesViewModel()
    var disposeBag = DisposeBag()
    var cat = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "DJs"
        setUp()
        LoadingModal.show()
        vm.getChefDishes()
        bindNetwork()
    }
    
    func setUp(){
        stepOneProgress.setProgress(0.40, animated: true)
        stepOneProgress.tintColor = .B_B
        stepTwoProgress.setProgress(0, animated: false)
        
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
    
    func bindNetwork(){
        vm.output.subscribe(onNext: { [weak self] response in
            LoadingModal.dismiss()
            
            switch response {
            case .getChefDishesSuccess(let response):
                self?.cat = response.data?.categories?.first?.id ?? ""
            case .getChefDishesError(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
            
            
        }).disposed(by: disposeBag)
    }
    
//    func validate(){
//        
//    }


    @IBAction func nextTapped(_ sender: Any) {
        
        let request = CreateServiceListingRequest(roleType: HostType.dj.rawValue, name: nameLabel.text, description: descriptionLabel.text, categoryId: cat, availableFrom: "", availableTo: "", images: [], startingPrice: 0, dishes: [], gender: "")
        
        print(request)
        
        coordinator?.gotoDJUploadProfileImageView(createServiceListingData: request)
    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        let request = CreateServiceListingRequest(roleType: HostType.dj.rawValue, name: nameLabel.text, description: descriptionLabel.text, categoryId: cat, availableFrom: "", availableTo: "", images: [], startingPrice: 0, dishes: [], gender: "")
        
        AppStorage.serviceListing = request
        coordinator?.backToDashboard()
    }
    
}

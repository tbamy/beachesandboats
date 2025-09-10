//
//  EditPropertyNameView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 23/07/2025.
//

import UIKit
import RxSwift

class EditPropertyNameView: BaseViewControllerPlain {

    var coordinator: HostingServiceMenuCoordinator?
    
    @IBOutlet weak var nameLabel: InputField!
    @IBOutlet weak var descriptionLabel: TextViewField!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    var id: String?
    
    var disposeBag = DisposeBag()
    var vm = EditBeachViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Property"
        
        bindNetwork()
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
        guard let id = id else { return }
        if validate(){
            if var createBeachListing = createBeachListing{
                createBeachListing.name = nameLabel.text
                createBeachListing.description = descriptionLabel.text
                
                self.createBeachListing = createBeachListing
                print(createBeachListing)
                
                LoadingModal.show(title: "Updating Record...")
                vm.editBeach(createBeachListing, id: id)
                
                
            }
        }
    }
    
    func bindNetwork(){
        vm.output.subscribe(onNext: {[weak self] response in
            LoadingModal.dismiss()
            
            switch response {
            case .editBeachSuccessful(let response):
                print(response)
                MiddleModal.show(title: response.message ?? "", type: .success, onConfirm: { self?.coordinator?.pop() })
                
            case .editBeachFailed(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
            
        }).disposed(by: disposeBag)
    }
    
}


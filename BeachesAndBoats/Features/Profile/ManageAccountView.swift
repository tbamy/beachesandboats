//
//  ManageAccountView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 13/10/2024.
//

import UIKit
import RxSwift

class ManageAccountView: BaseViewControllerPlain {
    var coordinator: AccountCoordinator?
    @IBOutlet weak var firstNameField: InputField!
    @IBOutlet weak var lastNameField: InputField!
    @IBOutlet weak var emailAddressField: InputField!
    @IBOutlet weak var phoneNumberField: InputField!
    @IBOutlet weak var saveBtn: PrimaryButton!
    
    let userData = UserSession.shared.loginRes?.data?.user
    
    let vm = UpdateProfileVM()
    let disposeBag = DisposeBag()
    let input = PublishSubject<UpdateProfileVM.Input>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Manage Account"
        setupCustomNavigationButton()
        setupDetails()
    }
    
    func setupDetails(){
        emailAddressField.isUserInteractionEnabled = false
        phoneNumberField.isUserInteractionEnabled = false
        
        if let userInfo = userData{
            firstNameField.text = userInfo.first_name ?? ""
            lastNameField.text = userInfo.last_name ?? ""
            emailAddressField.text = userInfo.email ?? ""
            phoneNumberField.text = userInfo.phone_number ?? ""
        }
    }

     @IBAction func saveTapped(_ sender: Any) {
         if validateFields(){
             let request = UpdateProfileRequest(first_name: firstNameField.text, last_name: lastNameField.text)
             input.onNext(.updateProfile(request))
             LoadingModal.show()
         }
     }
    

    func validateFields() -> Bool{
        if firstNameField.text.isEmpty {
            firstNameField.error = "Please enter your first name"
            return false
        }
        else
        if lastNameField.text.isEmpty {
            lastNameField.error = "Please enter your last name"
            return false
        }
        
        return true
    }
}

extension ManageAccountView{
    func setupCustomNavigationButton() {
        let customButton = UIButton(type: .custom)
        customButton.setTitle("Save", for: .normal)
        customButton.tintColor = .beachBlue
        customButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        let customBarButtonItem = UIBarButtonItem(customView: customButton)
        navigationItem.rightBarButtonItem = customBarButtonItem
    }
    
    func bind() {
        vm.transform(input: input)
        vm.output.subscribe(onNext: { [weak self] output in
            LoadingModal.dismiss()
            switch output {
            case .updateProfileSuccess(let response):
                self?.updateUserDetails(with: response)
            case .updateProfileFailed(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
        }).disposed(by: disposeBag)

    }
    
    func updateUserDetails(with: UpdateProfileResponse){
        UserSession.shared.userDetails = with.data
        Toast.show(message: with.message ?? "Profile Successfully Updated")
    }
}

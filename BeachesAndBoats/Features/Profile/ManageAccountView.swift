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
    
    var userData: DashboardUserData?
    
    let vm = UpdateProfileVM()
    let disposeBag = DisposeBag()
    let input = PublishSubject<UpdateProfileVM.Input>()
    
    let serviceRoles: [HostType] = [.chef, .dj, .bouncer]
    let hostRoles: [HostType] = [.primaryHost, .secondaryHost]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Manage Account"
        setupCustomNavigationButton()
        bind()
        setupDetails()
        input.onNext(.getDashboardUser)
        LoadingModal.show()
    }
    
    func setupDetails(){
        emailAddressField.isUserInteractionEnabled = false
        phoneNumberField.isUserInteractionEnabled = false
        
        if let userInfo = userData{
            firstNameField.text = userInfo.firstName
            lastNameField.text = userInfo.lastName
            emailAddressField.text = userInfo.email
            phoneNumberField.text = userInfo.phoneNumber
            
            let userRoles = userInfo.roles
            let hostRoleStrings = hostRoles.map { $0.rawValue }
            let hasHostRole = userRoles.contains { hostRoleStrings.contains($0) }
            
            let serviceRoleStrings = serviceRoles.map { $0.rawValue }
            let hasSeviceRole = userRoles.contains { serviceRoleStrings.contains($0)}
            
            print(userRoles)
            print(hasHostRole)
            print(hasSeviceRole)
            
            saveBtn.isHidden = !(hasHostRole || hasSeviceRole)
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
        
        vm.getUserOutput.subscribe(onNext: { [weak self] output in
            LoadingModal.dismiss()
            switch output {
            case .getDashboardUserSuccess(let response):
                self?.userData = response.data
                self?.setupDetails()
            case .getDashboardUserFailed(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
        }).disposed(by: disposeBag)

    }
    
    func updateUserDetails(with: UpdateProfileResponse){
        UserSession.shared.userDetails = with.data
        Toast.show(message: with.message ?? "Profile Successfully Updated")
    }
}

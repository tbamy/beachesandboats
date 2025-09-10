//
//  VerificationFormView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 10/10/2024.
//

import UIKit
import RxSwift

class VerificationFormView: BaseViewController {
    
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var firstNameField: InputField!
    @IBOutlet weak var middleNameField: InputField!
    @IBOutlet weak var lastNameField: InputField!
    @IBOutlet weak var emailField: InputField!
    @IBOutlet weak var phoneField: InputFieldWithLeftImg!
    @IBOutlet weak var uploadIdField: UploadButtonField!
    @IBOutlet weak var currentPictureField: UploadButtonField!
    
    
    let vm = KYCVerificationVM()
    let disposeBag = DisposeBag()
    let input = PublishSubject<KYCVerificationVM.Input>()
    
    var user = UserSession.shared.userDetails
    let serviceRoles: [HostType] = [.chef, .dj, .bouncer]
    let hostRoles: [HostType] = [.primaryHost, .secondaryHost]
    
    var idDocument: Data?
    var currentPicture: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        bind()
    }
    
    func setup(){
        phoneField.keyboardType = .phonePad
        uploadIdField.isOnlyImage = true
        currentPictureField.isOnlyImage = true
        
        uploadIdField.onSelected = { [weak self] (data, ext) in
            self?.idDocument = data
        }
        
        currentPictureField.onSelected = { [weak self] (data, ext) in
            self?.currentPicture = data
        }
    }
    
    func validateFields() -> Bool{
        let validateFirstNameField = firstNameField.validate(rules: [Rule(.isEmpty, "Enter First Name")])
//        let validatemiddleNameField = middleNameField.validate(rules: [Rule(.isEmpty, "Enter Middle Name")])
        let validateLastNameField = lastNameField.validate(rules: [Rule(.isEmpty, "Enter Last Name")])
        let validateEmailField = emailField.validate(rules: [Rule(.isEmpty, "Enter Emaile")])
        let validatePhoneField = phoneField.validate(rules: [Rule(.isEmpty, "Enter Phone Number")])
        
     
        return validateFirstNameField && validateLastNameField && validateEmailField && validatePhoneField
    }

    
    @IBAction func verifyAccountTapped(_ sender: Any) {
        if validateFields(){
            if let idDocument = idDocument, let currentPicture = currentPicture{
                let request = SendKYCRequest(first_name: firstNameField.text, last_name: lastNameField.text, middle_name: middleNameField.text, email: emailField.text, phone_number: phoneField.text, id_document: idDocument, second_document: currentPicture)
                
                LoadingModal.show()
                input.onNext(.kycVerification(request))
            }
        }
    }
    
    
    func bind(){
        vm.transform(input: input)

        vm.output.subscribe(onNext: {[weak self] event in
            guard let self = self else { return }
            LoadingModal.dismiss()
            switch event {
            case .kycVerificationSuccess(let response):
                UserSession.shared.userDetails?.verificationStatus = "pending"
                
                MiddleModal.show(title: "Success" , subtitle: response.message ?? "", type: .success, onConfirm: { self.navigateUser() } )

                
            case .kycVerificationFailed(let error):
                MiddleModal.show(title: error.message ?? "Error ocurred", type: .error)
            }
        }).disposed(by: disposeBag)
    }
    
    
    func navigateUser(){
        if let userRoles = user?.roles {
            let lowercasedUserRoles = userRoles.map { $0.lowercased() }
            
            let hostRoleStrings = hostRoles.map { $0.rawValue.lowercased() }
            let hasHostRole = lowercasedUserRoles.contains { hostRoleStrings.contains($0) }
            
            let serviceRoleStrings = serviceRoles.map { $0.rawValue.lowercased() }
            let hasServiceRole = lowercasedUserRoles.contains { serviceRoleStrings.contains($0) }
            
            if hasHostRole {
                coordinator?.backToHostingDashboard()
            } else if hasServiceRole {
                coordinator?.backToServiceDashboard()
            }else{
                coordinator?.backToDashboard()
            }
        }else{
            coordinator?.backToDashboard()
        }
    }
}

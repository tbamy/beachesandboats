//
//  ContactSupportView.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 04/01/2025.
//

import UIKit
import RxSwift

class ContactSupportView: BaseViewControllerPlain {
    
    @IBOutlet weak var callSupportStack: UIStackView!
    @IBOutlet weak var chatSupportStack: UIStackView!
    @IBOutlet weak var sendEmailStack: UIStackView!
    
    var coordinator: AccountCoordinator?
    
    let chatVm = StartConversationVM()
    let chatInput = PublishSubject<StartConversationVM.Input>()
    
    let vm = ContactSupportVM()
    let disposeBag = DisposeBag()
    let input = PublishSubject<ContactSupportVM.Input>()
    
    var supportEmail: String?
    var supportPhone: String?
    var supportPhoneCode: String?
    var supportId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contact customer support"

        bind()
        addGestureRecognizers()
        LoadingModal.show()
        input.onNext(.getCustomerSupportInfo)
    }
    
    func addGestureRecognizers(){
        callSupportStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(callSupport)))
        chatSupportStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chatSupport)))
        sendEmailStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendEmail)))
    }
    
    @objc func callSupport() {
        guard let phoneCode = supportPhoneCode, let phoneNumber = supportPhone else {
            Toast.show(message: "Support phone number is not available")
            return
        }
        
        let phoneURLString = "tel://\(phoneNumber)"
        if let phoneURL = URL(string: phoneURLString), UIApplication.shared.canOpenURL(phoneURL) {
            UIApplication.shared.open(phoneURL)
        } else {
            Toast.show(message: "Unable to make a call")
        }
    }

    
    @objc func chatSupport(){
//        Toast.show(message: "Coming soon")
        let personId = supportId ?? ""
        let conversationRequest = StartConversationRequest(personId: personId, bookingId: nil, propertyType: nil)
        print(conversationRequest)
            chatInput.onNext(.startConversation(conversationRequest))
            LoadingModal.show()
    }
    
    @objc func sendEmail() {
        guard let email = supportEmail, !email.isEmpty else {
            Toast.show(message: "Support email is not available")
            return
        }
        
        let subject = "Customer Support Enquiry"
        let body = "Hello,\n\nI need assistance with..."
        let emailString = "mailto:\(email)?subject=\(subject)&body=\(body)"
        
        if let emailURL = URL(string: emailString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""),
           UIApplication.shared.canOpenURL(emailURL) {
            UIApplication.shared.open(emailURL)
        } else {
            Toast.show(message: "Unable to open mail app")
        }
    }

    
    func bind() {
        vm.transform(input: input)
        vm.output.subscribe(onNext: { [weak self] output in
            LoadingModal.dismiss()
            switch output {
            case .getCustomerSupportInfoSuccess(let response):
                self?.updateInfo(with: response)
            case .getCustomerSupportInfoFailed(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
        }).disposed(by: disposeBag)
        
        chatVm.transform(input: chatInput)
        chatVm.output.subscribe(onNext: { [weak self] data in
            LoadingModal.dismiss()
            switch data {
            case .startConversationSuccess(let response):
                if let res = response.data{
                    self?.coordinator?.gotoChat(bookingId: "", otherUser: "Customer Support", conversationId: res.id, propertyType: "")
                }
            case .startConversationFailed(let error) :
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
        }).disposed(by: disposeBag)

    }
    
    func updateInfo(with: CustomerSupportInfoResponse){
        supportEmail = with.data?.email
        supportPhone = with.data?.phoneNumber
        supportPhoneCode = with.data?.phoneCode
        supportId = with.data?.id
    }

}

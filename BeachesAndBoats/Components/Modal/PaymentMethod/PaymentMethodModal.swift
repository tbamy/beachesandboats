//
//  PaymentMethodModal.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 13/10/2024.
//

import UIKit

class PaymentMethodModal: BaseXib {
    
    
    @IBOutlet weak var cardPaymentStack: UIStackView!
    @IBOutlet weak var paystackPaymentStack: UIStackView!
    @IBOutlet weak var close: UIImageView!
    
    let nibName = "PaymentMethodModal"
    
    var selectedItem: String?
    var callback: (String?) -> Void = { _ in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        cardPaymentStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cardTapped)))
        paystackPaymentStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(paypalTapped)))
        
        close.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss(_ :))))
    }
    
    @objc func handleDismiss(_ sender: UITapGestureRecognizer) {
        dismiss()
    }
    
    @objc func cardTapped(){
        selectedItem = "Card"
        callback(selectedItem)
        dismiss()
    }
    
    @objc func paypalTapped(){
        selectedItem = "Paypal"
        callback(selectedItem)
        dismiss()
    }
    
}

extension PaymentMethodModal{
    
    public static func show(callBack: @escaping (String?) -> Void) {
        let backDrop = UIView(frame: Helpers.screen)
        backDrop.backgroundColor = .gray.withAlphaComponent(0.5)
        
        let modal = PaymentMethodModal()
        modal.callback = callBack
        
        modal.backgroundColor = .background.lighter(by: 17)
        modal.layer.cornerRadius = 12
        modal.clipsToBounds = true
        backDrop.addSubview(modal)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.addSubview(backDrop)
        }
        let height = Helpers.screenHeight * 0.4
        modal.frame = CGRect(x: 0, y: Helpers.screenHeight, width: Helpers.screenWidth, height: height)
        backDrop.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            modal.frame.origin.y = Helpers.screenHeight - height
            backDrop.layoutIfNeeded()
        }, completion: nil)
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            self?.frame.origin.y = Helpers.screenHeight
            self?.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.superview?.removeFromSuperview()
        })
    }
}

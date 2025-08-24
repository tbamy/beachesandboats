//
//  CreateInvoiceModal.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 20/07/2025.
//

import UIKit

class CreateInvoiceModal: BaseXib {
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var summaryField: UITextView!
    @IBOutlet weak var amountField: BigMoneyInputField!
    @IBOutlet weak var closeIcon: UIImageView!
    
    var completion: ((CreateInvoiceModel) -> Void) = {_ in }
    private var selectedRating: Int = 0

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
//        submitBtn.isEnabled = false
        submitBtn.alpha = 0.5
        closeIcon.isUserInteractionEnabled = true
        closeIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss(_:))))
        
        amountField.amountChanged = { [weak self] in
            self?.submitBtn.isEnabled = true
        }
    }
    
    

    
    @objc func handleDismiss(_ sender: UITapGestureRecognizer) {
        dismiss()
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            self?.frame.origin.y = Helpers.screenHeight
            self?.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.superview?.removeFromSuperview()
        })
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        dismiss()
        let req = CreateInvoiceModel(note: summaryField.text, amount: amountField.getFloatValue() ?? 0)
        completion(req)
    }
    
    
    public static func show(on view: UIView, completion: @escaping (CreateInvoiceModel) -> Void) {
        
        let modal = CreateInvoiceModal()
        modal.completion = completion
        
        modal.backgroundColor = .background.lighter(by: 17)
        modal.layer.cornerRadius = 12
        modal.clipsToBounds = true
        
        let backDrop = UIView(frame: Helpers.screen)
        backDrop.backgroundColor = .gray.withAlphaComponent(0.9)
        backDrop.addSubview(modal)
        view.addSubview(backDrop)
        let height = Helpers.screenHeight * 0.9
        modal.frame = CGRect(x: 0, y: Helpers.screenHeight, width: Helpers.screenWidth, height: height)
        view.layoutIfNeeded()
        

        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            modal.frame.origin.y = Helpers.screenHeight  - height + modal.layer.cornerRadius
            view.layoutIfNeeded()
        }, completion: nil)
    }
}

struct CreateInvoiceModel: Codable{
    var note: String
    var amount: Float
}

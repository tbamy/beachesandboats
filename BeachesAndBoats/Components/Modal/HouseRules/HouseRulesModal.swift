//
//  HouseRulesModal.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 17/07/2025.
//

import UIKit

public class HouseRulesModal: BaseXib {

    @IBOutlet weak var close: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var proceedBtn: PrimaryButton!
    

    let nibName = "HouseRulesModal"
    
    var callback: () -> Void = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        proceedBtn.addTarget(self, action: #selector(proceedTapped), for: .touchUpInside)
        
        close.isUserInteractionEnabled = true
        close.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss(_ :))))
    }
    
    @objc func handleDismiss(_ sender: UITapGestureRecognizer) {
        dismiss()
    }
    
    @objc func proceedTapped(){
        callback()
        dismiss()
    }


}

extension HouseRulesModal{
    
    public static func show(on view: UIView, rules: String, callBack: @escaping () -> Void) {
        
        let modal = HouseRulesModal()
        modal.callback = callBack
        modal.textView.text = rules
        
        modal.backgroundColor = .background.lighter(by: 17)
        modal.layer.cornerRadius = 12
        modal.clipsToBounds = true

        let backDrop = UIView(frame: Helpers.screen)
        backDrop.backgroundColor = .gray.withAlphaComponent(0.5)
        backDrop.addSubview(modal)
        view.addSubview(backDrop)
        
        let height = Helpers.screenHeight * 0.35
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

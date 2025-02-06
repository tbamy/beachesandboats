//
//  SelectServiceModal.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 30/01/2025.
//

import UIKit

class SelectServiceModal: BaseXib {

    @IBOutlet weak var chefView: UIView!
    @IBOutlet weak var bouncerView: UIView!
    @IBOutlet weak var djView: UIView!
    
    let nibName = "SelectServiceModal"
    
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
        chefView.layer.cornerRadius = 8
        chefView.layer.borderWidth = 1
        chefView.layer.borderColor = UIColor.grey.cgColor
        
        bouncerView.layer.cornerRadius = 8
        bouncerView.layer.borderWidth = 1
        bouncerView.layer.borderColor = UIColor.grey.cgColor
        
        djView.layer.cornerRadius = 8
        djView.layer.borderWidth = 1
        djView.layer.borderColor = UIColor.grey.cgColor
        
        
        chefView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chefTapped)))
        bouncerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bouncerTapped)))
        djView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(djTapped)))
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleDismissal))
        swipeDown.direction = .down
        addGestureRecognizer(swipeDown)
    }
    
    @objc func chefTapped(){
        callback("CHEF")
        dismiss()
    }
    
    @objc func bouncerTapped(){
        callback("BOUNCER")
        dismiss()
    }
    
    @objc func djTapped(){
        callback("DJ")
        dismiss()
    }
    
    @objc func handleDismissal() {
        dismiss()
    }

}

extension SelectServiceModal{
    
    public static func show(callBack: @escaping (String?) -> Void) {
        let backDrop = UIView(frame: Helpers.screen)
        backDrop.backgroundColor = .gray.withAlphaComponent(0.5)
        
        let modal = SelectServiceModal()
        modal.callback = callBack
        
        modal.backgroundColor = .background.lighter(by: 17)
        modal.layer.cornerRadius = 12
        modal.clipsToBounds = true
        backDrop.addSubview(modal)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.addSubview(backDrop)
        }
        let height = Helpers.screenHeight * 0.45
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

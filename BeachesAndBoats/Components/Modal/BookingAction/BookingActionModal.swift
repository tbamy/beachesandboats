//
//  BookingActionModal.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 03/09/2025.
//

import UIKit

public class BookingActionModal: BaseXib {
    
    @IBOutlet weak var close: UIImageView!
    @IBOutlet weak var bookBtn: PrimaryButton!
    @IBOutlet weak var selectRoomBtn: SecondaryButton!
    

    let nibName = "BookingActionModal"
    
    var callback: (Int) -> Void = {_ in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        bookBtn.addTarget(self, action: #selector(bookTapped), for: .touchUpInside)
        selectRoomBtn.addTarget(self, action: #selector(selectRoomsTapped), for: .touchUpInside)
        
        close.isUserInteractionEnabled = true
        close.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss(_ :))))
    }
    
    @objc func handleDismiss(_ sender: UITapGestureRecognizer) {
        dismiss()
    }
    
    @objc func bookTapped(){
        callback(1)
        dismiss()
    }
    
    @objc func selectRoomsTapped(){
        callback(2)
        dismiss()
    }


}

extension BookingActionModal{
    
    public static func show(on view: UIView, callBack: @escaping (Int) -> Void) {
        
        let modal = BookingActionModal()
        modal.callback = callBack
        
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


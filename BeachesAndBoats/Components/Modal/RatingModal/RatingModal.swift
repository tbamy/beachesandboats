//
//  RatingModal.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 02/07/2025.
//

import UIKit

protocol SumbitBtnDelegate: AnyObject {
    func submitTapped(rating: Int, comment: String?)
}

class RatingModal: BaseXib {
    @IBOutlet var RattingBtns: [UIButton]!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var commentField: UITextView!
    @IBOutlet weak var closeIcon: UIImageView!
    
    weak var submitBtnDelegate: SumbitBtnDelegate?
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
        submitBtn.isEnabled = false
        submitBtn.alpha = 0.5
        closeIcon.isUserInteractionEnabled = true
        closeIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss(_:))))
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
    
    @IBAction func ratingBtnTapped(_ sender: UIButton) {
        guard let index = RattingBtns.firstIndex(of: sender) else { return }
        selectedRating = index + 1
        
        for (i, btn) in RattingBtns.enumerated() {
            let isSelected = i <= index
            btn.isSelected = isSelected
            btn.backgroundColor = isSelected ? UIColor.B_B : .clear
            btn.setImage(UIImage(named: isSelected ? "filledStar" : "emptyStar"), for: .normal)
            btn.setTitleColor(isSelected ? UIColor.white : UIColor.systemGray, for: .normal)
//            btn.layer.borderColor = UIColor.systemBlue.cgColor
//            btn.layer.borderWidth = 1
            btn.layer.cornerRadius = 5
        }
        
        submitBtn.isEnabled = true
        submitBtn.alpha = 1.0
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        dismiss()
        submitBtnDelegate?.submitTapped(rating: selectedRating, comment: commentField.text)
    }
    
    
    public static func show(on view: UIView, userComment: String, delegate: SumbitBtnDelegate?) {
        
        let modal = RatingModal()
        modal.submitBtnDelegate = delegate 
        
        modal.commentField.text = userComment
        
        modal.backgroundColor = .background.lighter(by: 17)
        modal.layer.cornerRadius = 12
        modal.clipsToBounds = true
        
        let backDrop = UIView(frame: Helpers.screen)
        backDrop.backgroundColor = .gray.withAlphaComponent(0.7)
        backDrop.addSubview(modal)
        view.addSubview(backDrop)
        let height = Helpers.screenHeight * 0.7
        modal.frame = CGRect(x: 0, y: Helpers.screenHeight, width: Helpers.screenWidth, height: height)
        view.layoutIfNeeded()
        

        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            modal.frame.origin.y = Helpers.screenHeight  - height + modal.layer.cornerRadius
            view.layoutIfNeeded()
        }, completion: nil)
    }
}

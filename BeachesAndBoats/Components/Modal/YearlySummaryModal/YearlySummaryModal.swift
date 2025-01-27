//
//  YearlySummaryModal.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 01/01/2025.
//

import UIKit

protocol YearlySummaryModalDelegate: AnyObject {
    func yearlySummaryModalDidTapExport(_ modal: YearlySummaryModal)
    func yearlySummaryModalDidTapDone(_ modal: YearlySummaryModal)
}

class YearlySummaryModal: BaseXib {

    @IBOutlet weak var grossEarningLbl: RegularLabel!
    @IBOutlet weak var yearAdjustmentLbl: RegularLabel!
    @IBOutlet weak var serviceFeeLbl: RegularLabel!
    @IBOutlet weak var yearTaxLbl: RegularLabel!
    @IBOutlet weak var exportBtn: PrimaryButton!
    @IBOutlet weak var doneBtn: PlainOutlineButton!
    @IBOutlet weak var closeIcon: UIImageView!
    @IBOutlet weak var yearBtn: YearPickerButton!
    
    weak var delegate: YearlySummaryModalDelegate?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    func setup() {
        closeIcon.isUserInteractionEnabled = true  // Enable interaction
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
    
//    public static func show(grossEarning: String, yearAdjustment: String, serviceFee: String, yearTax: String) {
//        let backDrop = UIView(frame: Helpers.screen)
//        backDrop.backgroundColor = .gray.withAlphaComponent(0.5)
//        
//        let modal = YearlySummaryModal()
//        
//        modal.grossEarningLbl.text = grossEarning
//        modal.yearAdjustmentLbl.text = yearAdjustment
//        modal.serviceFeeLbl.text = serviceFee
//        modal.yearTaxLbl.text = yearTax
//        
//        modal.backgroundColor = .background.lighter(by: 17)
//        modal.layer.cornerRadius = 12
//        modal.clipsToBounds = true
//        backDrop.addSubview(modal)
//        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
//            keyWindow.addSubview(backDrop)
//        }
//        let height = Helpers.screenHeight * 0.7
//        modal.frame = CGRect(x: 0, y: Helpers.screenHeight, width: Helpers.screenWidth, height: height)
//        backDrop.layoutIfNeeded()
//        
//        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
//            modal.frame.origin.y = Helpers.screenHeight - height
//            backDrop.layoutIfNeeded()
//        }, completion: nil)
//    }
    
    public static func show(grossEarning: String, yearAdjustment: String, serviceFee: String, yearTax: String, delegate: YearlySummaryModalDelegate?) {
        let backDrop = UIView(frame: Helpers.screen)
        backDrop.backgroundColor = .gray.withAlphaComponent(0.5)
        
        let modal = YearlySummaryModal()
        modal.delegate = delegate  // Set the delegate
        
        modal.grossEarningLbl.text = grossEarning
        modal.yearAdjustmentLbl.text = yearAdjustment
        modal.serviceFeeLbl.text = serviceFee
        modal.yearTaxLbl.text = yearTax
        
        modal.backgroundColor = .background.lighter(by: 17)
        modal.layer.cornerRadius = 12
        modal.clipsToBounds = true
        backDrop.addSubview(modal)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.addSubview(backDrop)
        }
        
        let height = Helpers.screenHeight * 0.7
        modal.frame = CGRect(x: 0, y: Helpers.screenHeight, width: Helpers.screenWidth, height: height)
        backDrop.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            modal.frame.origin.y = Helpers.screenHeight - height
            backDrop.layoutIfNeeded()
        }, completion: nil)
    }

    
    @IBAction func exportBtnTapped(_ sender: Any) {
        delegate?.yearlySummaryModalDidTapExport(self)
    }
    
    @IBAction func doneBtnTapped(_ sender: Any) {
        delegate?.yearlySummaryModalDidTapDone(self)
    }
}

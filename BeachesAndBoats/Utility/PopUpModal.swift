//
//  PopUpModal.swift
//  BeachesAndBoats
//
//  Created by WEMA on 15/05/2024.
//

import Foundation
import UIKit

@IBDesignable public class PopUpModal: BaseView {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var buttonTitle: UIButton!
    @IBOutlet weak var imageName: UIImageView!
    
    var model: PopUpModel = PopUpModel() {
        didSet {
            setup(model)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup(model)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup(model)
    }
    
    func setup(_ model: PopUpModel) {
        title.text = model.title
        subtitle.text = model.subtitle
        buttonTitle.setTitle(model.buttonText, for: .normal)
        imageName.image = UIImage(named: model.image ?? "empty")
    }
    
    @IBAction func onClicked(_ sender: Any) {
        model.onClick()
    }
    
    public static func showPopUp(title: String, subtitle: String?, buttonText: String, image: String, onClicked: @escaping () -> Void = {}) -> UIView {
        let backgroundView = PopUpModal(frame: CGRect(x: 0, y: 0, width: 500, height: 300))
        backgroundView.backgroundColor = .clear
        backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        let modal = PopUpModal()
        modal.model.title = title
        modal.model.subtitle = subtitle
        modal.model.onClick = onClicked
        modal.model.buttonText = buttonText
        modal.model.image = image
        
        backgroundView.addSubview(modal)
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.addSubview(backgroundView)
//        modal.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: modal.getHeight())
//        modal.subtitleHeight.isActive = false
//        backgroundView.layoutIfNeeded()
//        modal.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: modal.getHeight())
//        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
//            modal.frame.origin.y = UIScreen.main.bounds.height  - modal.getHeight() + modal.layer.cornerRadius
//            backgroundView.layoutIfNeeded()
//        }, completion: nil)
        
        return backgroundView
    }
    
    public static func show(
        title: String = "",
        subtitle: String = "",
        buttonText: String = "",
        image: String = "",
        onClick: @escaping () -> Void = {})
    {
        _ = showPopUp(title: title, subtitle: subtitle, buttonText: buttonText, image: image, onClicked: onClick)
    }
    
}

public struct PopUpModel {
    var image: String?
    var title: String?
    var subtitle: String?
    var buttonText: String?
    var onClick: () -> Void = {}
    
}

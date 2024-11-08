//
//  LoadingModal.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 03/08/2024.
//

import UIKit

public class LoadingModal: BaseXib {

    @IBOutlet weak var backDrop: UIView!
    @IBOutlet private weak var titleLabel: MediumLabel!
    
    public var title: String = "Loading..." {
        didSet {
            titleLabel.text = title
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        backDrop.backgroundColor = .clear
        
        backDrop.applyDarkEffect()
    }
    
    public static func show(title: String = "Loading...") {
        let modal = LoadingModal(frame: Helpers.screen)
        modal.title = title
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.addSubview(modal)
        }
    }
    
    public static func dismiss() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            
            let subviews = keyWindow.subviews
            for view in subviews {
                if view is LoadingModal {
                    view.removeFromSuperview()
               }
            }
        }
        
    }
}

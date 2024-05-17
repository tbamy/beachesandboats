//
//  BaseView.swift
//  BeachesAndBoats
//
//  Created by WEMA on 15/05/2024.
//

import Foundation
import UIKit

public class BaseView: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupXib()
    }
    
    
    func setupXib() {
        if let nibName = getNibName() {
            let bundle = Bundle(for: type(of: self))
            let nib = UINib(nibName: nibName, bundle: bundle)
            let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
            view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            backgroundColor = .clear
            view.backgroundColor = .clear
            addSubview(view)
            view.frame = self.bounds
        }
    }
    
    func updateHeight() {
        constraints.filter({$0.firstAnchor == heightAnchor }).forEach{ $0.isActive = false }
        setNeedsDisplay()
    }
    
    func getNibName() -> String? { String(describing: Self.self) }
    func getContentView() -> UIView? { nil }
    func sizeToContent()-> Bool { false }
}

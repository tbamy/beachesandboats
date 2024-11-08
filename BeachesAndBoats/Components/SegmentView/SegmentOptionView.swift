//
//  SegmentOptionView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/10/2024.
//

import Foundation
import UIKit

@IBDesignable public class SegmentOptionView: BaseXib {
    
    public var onSelect: () -> Void = {}
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLbl: SemiLabel!
    @IBOutlet weak var indicatorView: UIView!
    
    @IBInspectable public var title: String?{
        set{
            titleLbl.text = newValue
        }get{
            return titleLbl.text ?? ""
        }
    }
    
    @IBInspectable public var isSelected: Bool = false {
         didSet {
             if isSelected {
                 appearSelected()
             } else {
                 indicatorView.isHidden = true
                 titleLbl.tintColor = .grey
             }
         }
     }
    
    public override init(frame: CGRect) {
        super .init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
        setup()
    }
    
    func setup(){
        isUserInteractionEnabled = true
        let tapped = UITapGestureRecognizer(target: self, action: #selector(selected))
        addGestureRecognizer(tapped)
    }
    
    @objc func selected(){
        if(!isSelected){
            appearSelected()
            onSelect()
        }
    }
    
    public func appearSelected(){
        indicatorView.isHidden = false
        titleLbl.tintColor = .beachBlue
        indicatorView.backgroundColor = .beachBlue
    }
    
    
}

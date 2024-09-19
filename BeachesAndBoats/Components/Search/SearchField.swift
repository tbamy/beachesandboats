//
//  SearchField.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 03/09/2024.
//

import UIKit

@IBDesignable public class SearchField: BaseXib {
    
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        addShadow(to: view)
    }

}

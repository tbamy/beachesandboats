//
//  WalkthroughCell.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 12/05/2024.
//

import UIKit

class WalkthroughCell: UICollectionViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var slideImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        addGradient()
        
    }

    func setUp(data: WalkthroughModel){
        slideImg.image = UIImage(named: data.image)
        titleLabel.text = data.title
        contentLabel.text = data.content
    }
    
    func addGradient(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        
        let bottomColor = UIColor.black.cgColor
        let topColor = UIColor.white.cgColor
        
        gradientLayer.colors = [bottomColor, topColor]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        
        view.layer.insertSublayer(gradientLayer, at: 0)
//        view.layer.insertSublayer(gradientLayer, above: collectionView.layer)
        gradientLayer.frame = view.bounds
        
        
                
    }
}

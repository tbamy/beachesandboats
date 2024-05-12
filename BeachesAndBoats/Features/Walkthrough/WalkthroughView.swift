//
//  WalkthroughView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 12/05/2024.
//

import UIKit

class WalkthroughView: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var skipBtn: UILabel!
    @IBOutlet weak var nextBtn: UILabel!
    
    var coordinator: AppCoordinator?
    var slides: [WalkthroughModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGradient()
        
        slides = [
            .init(image: "slide1", title: "Unwind by the Waves, Your Vacation Starts Here", content: "Explore thousands of beach houses for you to unwind."),
            .init(image: "slide2", title: "Boats On-Demand, Dreams Onboard.", content: "Rent different types of boats at affordable prices and go on boat cruise with friends and family."),
            .init(image: "slide3", title: "Unveil the Beauty of Africa's Coasts", content: "Explore the breathtaking beauty of Africa's coastal destinations and embrace the joy of boating adventures.")
        ]
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "WalkthroughCell", bundle: nil), forCellWithReuseIdentifier: "WalkthroughCell")
        
        
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
                
    }

}

extension WalkthroughView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalkthroughCell", for: indexPath) as! WalkthroughCell
        
        cell.setUp(data: slides[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    
}


struct WalkthroughModel{
    let image: String
    let title: String
    let content: String
}


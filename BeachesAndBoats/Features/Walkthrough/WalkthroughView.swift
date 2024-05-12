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
    
    var currentPage = 0
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
    
        
        slides = [
            .init(image: "slide1", title: "Unwind by the Waves, Your Vacation Starts Here", content: "Explore thousands of beach houses for you to unwind."),
            .init(image: "slide2", title: "Boats On-Demand, Dreams Onboard.", content: "Rent different types of boats at affordable prices and go on boat cruise with friends and family."),
            .init(image: "slide3", title: "Unveil the Beauty of Africa's Coasts", content: "Explore the breathtaking beauty of Africa's coastal destinations and embrace the joy of boating adventures.")
        ]
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "WalkthroughCell", bundle: nil), forCellWithReuseIdentifier: "WalkthroughCell")
        
        let skipTapGesture = UITapGestureRecognizer(target: self, action: #selector(skipButtonTapped))
        skipBtn.isUserInteractionEnabled = true
        skipBtn.addGestureRecognizer(skipTapGesture)
        
        let nextTapGesture = UITapGestureRecognizer(target: self, action: #selector(nextButtonTapped))
        nextBtn.isUserInteractionEnabled = true
        nextBtn.addGestureRecognizer(nextTapGesture)
                
        
    }
    
    @objc func skipButtonTapped() {
        coordinator?.gotoLogin()
    }
    
    @objc func nextButtonTapped() {
        scrollToNextCell()
    }
    
    func scrollToNextCell() {
        currentPage += 1
        if currentPage >= slides.count {
            currentPage = slides.count - 1
        }
        let index = IndexPath(item: currentPage, section: 0)
        collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        updateButtonVisibility()
    }
    
    func updateButtonVisibility() {
        if currentPage == slides.count - 1 {
            skipBtn.isHidden = true
            coordinator?.gotoLogin()
        } else {
            skipBtn.isHidden = false
//            nextBtn.text = "Next"
        }
    }
    

    
    @objc func autoScrollAction() {
        
        currentPage += 1
        if currentPage > 2 {
            currentPage = 0
        }
        let index = IndexPath(item: currentPage, section: 0)
        collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        pageControl.currentPage = currentPage
    }
    
}


struct WalkthroughModel{
    let image: String
    let title: String
    let content: String
}


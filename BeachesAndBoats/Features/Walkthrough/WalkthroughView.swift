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
    
    var currentPage: Int = 0
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        // Setup slides
        slides = [
            .init(image: "slide1", title: "Unwind by the Waves, Your Vacation Starts Here", content: "Explore thousands of beach houses for you to unwind."),
            .init(image: "slide2", title: "Boats On-Demand, Dreams Onboard.", content: "Rent different types of boats at affordable prices and go on boat cruise with friends and family."),
            .init(image: "slide3", title: "Unveil the Beauty of Africa's Coasts", content: "Explore the breathtaking beauty of Africa's coastal destinations and embrace the joy of boating adventures.")
        ]
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Register cell
        collectionView.register(UINib(nibName: "WalkthroughCell", bundle: nil), forCellWithReuseIdentifier: "WalkthroughCell")
        
        // Setup tap gestures
        let skipTapGesture = UITapGestureRecognizer(target: self, action: #selector(skipButtonTapped))
        skipBtn.isUserInteractionEnabled = true
        skipBtn.addGestureRecognizer(skipTapGesture)
        
        let nextTapGesture = UITapGestureRecognizer(target: self, action: #selector(nextButtonTapped))
        nextBtn.isUserInteractionEnabled = true
        nextBtn.addGestureRecognizer(nextTapGesture)
        
        // Setup page control
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        updateButtonVisibility()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(nextButtonTapped), userInfo: nil, repeats: true)
//    }
    
    @objc func skipButtonTapped() {
//        coordinator?.gotoSignup()
//        coordinator?.gotoLogin()
        coordinator?.goToDashboard()
    }
    
    @objc func nextButtonTapped() {
        scrollToNextCell()
    }
    
    func scrollToNextCell() {
        if currentPage < slides.count - 1 {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
//            print("Scrolling to page: \(currentPage), IndexPath: \(indexPath)")
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.pageControl.currentPage = self.currentPage
            self.updateButtonVisibility()
            
        } else {
            coordinator?.gotoSignup()
        }
    }
            
    
    func updateButtonVisibility() {
        if currentPage == slides.count - 1 {
            nextBtn.text = "Finish"
        } else {
            nextBtn.text = "Next"
        }
    }
}

extension WalkthroughView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalkthroughCell", for: indexPath) as? WalkthroughCell else {
            return UICollectionViewCell()
        }
        cell.setUp(data: slides[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Return size matching the collection view’s bounds to ensure full-screen cells
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / pageWidth)
        pageControl.currentPage = currentPage
        updateButtonVisibility()
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / pageWidth)
        pageControl.currentPage = currentPage
        updateButtonVisibility()
    }

}

// Struct for walkthrough data
struct WalkthroughModel {
    let image: String
    let title: String
    let content: String
}


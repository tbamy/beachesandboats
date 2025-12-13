//
//  SinglePhotoView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 28/12/2024.
//

//import UIKit
//
//class SinglePhotoView: BaseViewControllerPlain {
//
//    @IBOutlet weak var photosCollectionView: UICollectionView!
//    @IBOutlet weak var photosCount: UILabel!
//    @IBOutlet weak var previousBtn: UIImageView!
//    @IBOutlet weak var nextBtn: UIImageView!
//    @IBOutlet weak var cancelBtn: UIImageView!
//    
//    
//    var images: [String] = []
//    var initialIndex: Int = 0
//    
//    var currentPage: Int = 0
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .black
//        setup()
//    }
//    
//    func setup(){
//        photosCollectionView.delegate = self
//        photosCollectionView.dataSource = self
//        photosCollectionView.backgroundColor = .clear
//        photosCollectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
//        
//        nextBtn.isUserInteractionEnabled = true
//        previousBtn.isUserInteractionEnabled = true
//        cancelBtn.isUserInteractionEnabled = true
//        
//        nextBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nextButtonTapped)))
//        previousBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(previousButtonTapped)))
//        cancelBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeGallery)))
//        updatePhotosCount()
//    }
//    
//    @objc private func closeGallery() {
//        dismiss(animated: true, completion: nil)
//    }
//    
//    @objc func nextButtonTapped() {
//        scrollToNextCell()
//    }
//    
//    @objc func previousButtonTapped() {
//        scrollToPreviousCell()
//    }
//    
//    func scrollToNextCell() {
//        guard currentPage > 0 else {
//            return
//        }
//        
//        currentPage += 1
//        let indexPath = IndexPath(item: currentPage, section: 0)
//        self.photosCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//            
//        updatePhotosCount()
//
//    }
//    
//    func scrollToPreviousCell() {
//        guard currentPage > 0 else {
//            return
//        }
//        
//        currentPage -= 1
//        let indexPath = IndexPath(item: currentPage, section: 0)
//        self.photosCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//        
//        updatePhotosCount()
//    }
//    
//    func updatePhotosCount() {
//        photosCount.text = "\(currentPage + 1) / \(images.count)"
//    }
//
//
//}
//
//
//extension SinglePhotoView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return images.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = photosCollectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
//        let cellAt = images[indexPath.item]
//        
//        let view = ImageCell(frame: cell.bounds)
//        view.identifier = "Image " + indexPath.description
//        view.img = cellAt
//        
//        cell.applyView(view: view)
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return collectionView.frame.size
//    }
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let pageWidth = scrollView.frame.width
//        currentPage = Int(scrollView.contentOffset.x / pageWidth)
//        photosCount.text = "\(currentPage + 1) / \(images.count)"
//    }
//
//    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        let pageWidth = scrollView.frame.width
//        currentPage = Int(scrollView.contentOffset.x / pageWidth)
//        photosCount.text = "\(currentPage + 1) / \(images.count)"
//    }
//    
//    
//}


import UIKit

class SinglePhotoView: BaseViewControllerPlain {

    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var photosCount: UILabel!
    @IBOutlet weak var previousBtn: UIImageView!
    @IBOutlet weak var nextBtn: UIImageView!
    @IBOutlet weak var cancelBtn: UIImageView!
    
    var images: [String] = []
    var initialIndex: Int = 0
    var currentPage: Int = 0
    
    // Flag to ensure we only scroll to initial index once
    private var hasLaidOutInitialIndex = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        // set current page to the passed initial index
        currentPage = initialIndex
        
        setup()
        setupCollectionViewLayout()
    }
    
    // This ensures we scroll to the correct photo when the view opens
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !hasLaidOutInitialIndex && !images.isEmpty {
            let indexPath = IndexPath(item: initialIndex, section: 0)
            photosCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            hasLaidOutInitialIndex = true
            updatePhotosCount()
        }
    }
    
    func setup(){
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        photosCollectionView.backgroundColor = .black // Better for photo viewers
        
        // Enable Paging so it snaps to the photo
        photosCollectionView.isPagingEnabled = true
        photosCollectionView.showsHorizontalScrollIndicator = false
        
        photosCollectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        
        setupButtons()
        updatePhotosCount()
    }
    
    func setupCollectionViewLayout() {
        if let layout = photosCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
    }
    
    func setupButtons() {
        nextBtn.isUserInteractionEnabled = true
        previousBtn.isUserInteractionEnabled = true
        cancelBtn.isUserInteractionEnabled = true
        
        nextBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nextButtonTapped)))
        previousBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(previousButtonTapped)))
        cancelBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeGallery)))
    }
    
    @objc private func closeGallery() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func nextButtonTapped() {
        scrollToNextCell()
    }
    
    @objc func previousButtonTapped() {
        scrollToPreviousCell()
    }
    
    func scrollToNextCell() {
        // FIX: Check if we are less than the total count, not > 0
        guard currentPage < images.count - 1 else { return }
        
        currentPage += 1
        let indexPath = IndexPath(item: currentPage, section: 0)
        photosCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        updatePhotosCount()
    }
    
    func scrollToPreviousCell() {
        // FIX: Check if we are greater than 0
        guard currentPage > 0 else { return }
        
        currentPage -= 1
        let indexPath = IndexPath(item: currentPage, section: 0)
        photosCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        updatePhotosCount()
    }
    
    func updatePhotosCount() {
        photosCount.text = "\(currentPage + 1) / \(images.count)"
    }
}

extension SinglePhotoView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photosCollectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
        
        // FIX: Remove previous subviews to prevent stacking images on reuse
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let cellAt = images[indexPath.item]
        
        let view = ImageCell(frame: cell.bounds)
        view.identifier = "Image " + indexPath.description
        view.img = cellAt
        
        // Ensure image scales correctly
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        
        cell.applyView(view: view)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Return the full size of the collection view
        return photosCollectionView.frame.size
    }
    
    // Updates the counter when the user swipes manually
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateCurrentPage(scrollView)
    }
    
    // Updates the counter when the user clicks buttons (programmatic scroll)
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updateCurrentPage(scrollView)
    }
    
    private func updateCurrentPage(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        // Protect against division by zero
        guard width > 0 else { return }
        
        currentPage = Int(scrollView.contentOffset.x / width)
        updatePhotosCount()
    }
}

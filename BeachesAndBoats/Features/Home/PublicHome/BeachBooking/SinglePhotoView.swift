//
//  SinglePhotoView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 28/12/2024.
//

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setup()
    }
    
    func setup(){
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        photosCollectionView.backgroundColor = .clear
        photosCollectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        
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
        guard currentPage > 0 else {
            return
        }
        
        currentPage += 1
        let indexPath = IndexPath(item: currentPage, section: 0)
        self.photosCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
        updatePhotosCount()

    }
    
    func scrollToPreviousCell() {
        guard currentPage > 0 else {
            return
        }
        
        currentPage -= 1
        let indexPath = IndexPath(item: currentPage, section: 0)
        self.photosCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        updatePhotosCount()
    }
    
    func updatePhotosCount() {
        photosCount.text = "\(currentPage + 1) / \(images.count)"
    }


}


extension SinglePhotoView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photosCollectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
        let cellAt = images[indexPath.item]
        
        let view = ImageCell(frame: cell.bounds)
        view.identifier = "Image " + indexPath.description
        view.img = cellAt
        
        cell.applyView(view: view)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / pageWidth)
        photosCount.text = "\(currentPage + 1) / \(images.count)"
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / pageWidth)
        photosCount.text = "\(currentPage + 1) / \(images.count)"
    }
    
    
}

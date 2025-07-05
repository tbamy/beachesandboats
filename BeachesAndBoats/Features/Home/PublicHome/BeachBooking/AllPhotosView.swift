//
//  AllPhotosView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 28/12/2024.
//

import UIKit

class AllPhotosView: BaseViewControllerPlain {
    
    var coordinator: ExploreCoordinator?
    
    @IBOutlet weak var photosCollectionView: UICollectionView!

    var images: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Photos"
        setupCustomNavigationButtons()
        setup()
        print("Total Images: \(images.count)")
    }
    
    func setup(){
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        photosCollectionView.backgroundColor = .clear
        photosCollectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
    }


}

extension AllPhotosView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
        return CGSize(width: (collectionView.bounds.width / 2) - 10, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let galleryVC = SinglePhotoView()
        galleryVC.images = images
        galleryVC.initialIndex = indexPath.item
        galleryVC.modalPresentationStyle = .fullScreen
        self.present(galleryVC, animated: true, completion: nil)
                
    }
    
    
}

extension AllPhotosView {
    func setupCustomNavigationButtons() {
        
        let addButton = UIButton(type: .custom)
        addButton.setImage(Assets.favorite.image, for: .normal)
//        addButton.addTarget(self, action: #selector(viewImages), for: .touchUpInside)
        let addBarButtonItem = UIBarButtonItem(customView: addButton)

        let settingsButton = UIButton(type: .custom)
        settingsButton.setImage(Assets.share .image, for: .normal)
//        settingsButton.addTarget(self, action: #selector(viewImages), for: .touchUpInside)
        let settingsBarButtonItem = UIBarButtonItem(customView: settingsButton)

        navigationItem.rightBarButtonItems = [addBarButtonItem, settingsBarButtonItem]
    }

}

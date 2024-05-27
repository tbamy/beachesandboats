//
//  HomePageViewController.swift
//  BeachesAndBoats
//
//  Created by WEMA on 26/05/2024.
//

import UIKit

class HomePageViewController: UIViewController {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var filterViewContainer: UIView!
    @IBOutlet weak var beachViewContainer: UIView!
    @IBOutlet weak var boatsViewContainer: UIView!
    @IBOutlet weak var servicesViewContainer: UIView!
    @IBOutlet weak var beachHouseImg: UIImageView!
    @IBOutlet weak var boatImg: UIImageView!
    @IBOutlet weak var serviceImg: UIImageView!
    @IBOutlet weak var subCategoryCollectionView: UICollectionView!
    @IBOutlet weak var topRatedCollectionView: UICollectionView!
    @IBOutlet weak var othersCollectionView: UICollectionView!
    
    var coordinator: AppCoordinator?
    var subCategoryCoordinator: [SubCategoryPropeties] = SubCateogryModel().populateData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewContainerSetup()
        collectionViewSetup()
    }
    
    func viewContainerSetup() {
        
        filterViewContainer.layer.borderWidth = 1
        filterViewContainer.layer.borderColor = UIColor.lightGray.cgColor
        filterViewContainer.layer.cornerRadius = 10
        
        beachHouseImg.layer.cornerRadius = 10
        boatImg.layer.cornerRadius = 10
        serviceImg.layer.cornerRadius = 10
        
        searchView.layer.cornerRadius = 10
        searchView.layer.shadowColor = UIColor.black.cgColor
        searchView.layer.shadowOpacity = 0.1
        searchView.layer.shadowOffset = CGSize(width: 2, height: 2)
        searchView.layer.shadowRadius = 10
    }
    
    func collectionViewSetup() {
        subCategoryCollectionView.delegate = self
        subCategoryCollectionView.dataSource = self
        subCategoryCollectionView.tag = 1
        subCategoryCollectionView.register(UINib(nibName: "subCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "subCategoryCollectionViewCell")
        
        topRatedCollectionView.delegate = self
        topRatedCollectionView.dataSource = self
        topRatedCollectionView.tag = 2
        
        othersCollectionView.delegate = self
        othersCollectionView.dataSource = self
        othersCollectionView.tag = 3
    }
}

extension HomePageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return subCategoryCoordinator.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            let cell = subCategoryCollectionView.dequeueReusableCell(withReuseIdentifier: "subCategoryCollectionViewCell", for: indexPath) as! subCategoryCollectionViewCell
            let cellAt = subCategoryCoordinator[indexPath.item]
            cell.setup(with: cellAt)
            return cell
        }
        return UICollectionViewCell()
    }
}

extension HomePageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthOfScreen: CGFloat = 150/*collectionView.bounds.width*/
        let heightOfScreen = collectionView.bounds.height
        return CGSize(width: widthOfScreen, height: heightOfScreen)
    }
}

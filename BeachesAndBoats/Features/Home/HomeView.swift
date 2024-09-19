//
//  HomeView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 03/09/2024.
//

import UIKit

class HomeView: BaseViewControllerPlain {

    var coordinator: AppCoordinator?
    var slides: [CategoriesModel] = []
    
    @IBOutlet weak var filterBtn: UIImageView!
    @IBOutlet weak var searchField: SearchField!
    @IBOutlet weak var mainCategoryCollectionView: UICollectionView!
    @IBOutlet weak var subcategoryCollectionView: UICollectionView!
    @IBOutlet weak var topRatedTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        
        addShadow(to: subcategoryCollectionView)
        
        
        slides = [
            .init(image: "", title: "Beach Houses"),
            .init(image: "", title: "Boats"),
            .init(image: "", title: "Services")
        ]
        
        mainCategoryCollectionView.delegate = self
        mainCategoryCollectionView.dataSource = self
        
        
        mainCategoryCollectionView.register(UINib(nibName: "CategoriesViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoriesViewCell")
    }

    func addShadow(to view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.masksToBounds = false
    }

}

extension HomeView: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesViewCell", for: indexPath) as! CategoriesViewCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        <#code#>
    }
    
    
}

struct CategoriesModel{
    var image: String
    var title: String
}

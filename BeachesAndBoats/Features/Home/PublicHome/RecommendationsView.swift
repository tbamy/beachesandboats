//
//  RecommendationsView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 31/01/2025.
//

import UIKit

class RecommendationsView: BaseViewControllerPlain {
    
    var coordinator: ExploreCoordinator?
    var data: FindServiceProviderResponse?
    var provider: String?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var recommendationCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recommendations"
        setup()
    }
    
    func setup(){
        
        switch provider {
        case "Chef":
            titleLabel.text = "Top Chef Recommendations"
            subtitleLabel.text = "Here are the recommended chefs based on your selections"
        case "Bouncer":
            titleLabel.text = "Top Bouncer Recommendations"
            subtitleLabel.text = "Here are the recommended bouncer based on your selections"
        case "Dj":
            titleLabel.text = "Top DJ Recommendations"
            subtitleLabel.text = "Here are the recommended DJs based on your selections"
        default:
            break
        }
        
        
        recommendationCollectionView.delegate = self
        recommendationCollectionView.dataSource = self
        recommendationCollectionView.backgroundColor = .clear
        recommendationCollectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
    }


}

extension RecommendationsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = recommendationCollectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
        let name = data?.data?[indexPath.item]
        
        let view = RecommendationsViewCell(frame: cell.bounds)
        view.model.image = name?.images?.first?.url ?? ""
        view.model.name = "\(provider ?? "") \(name?.name ?? "")"
        view.model.rating = name?.rating ?? 0
        view.model.price = name?.startingPrice ?? 0
        
        view.onViewBtnTapped = { [weak self] in
            guard let self = self, let name = name, let provider = self.provider else { return }
            self.coordinator?.gotoServiceProviderDetails(data: name, provider: provider)
        }
        
        cell.applyView(view: view)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = data?.data?[indexPath.item]
        if let item = item, let provider = provider{
            coordinator?.gotoServiceProviderDetails(data: item, provider: provider)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 5, height: 130)
    }
    
}

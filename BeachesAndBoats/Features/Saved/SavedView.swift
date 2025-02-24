//
//  SavedView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 03/10/2024.
//

import UIKit
import RxSwift

class SavedView: BaseViewControllerPlain {

    var coordinator: SavedCoordinator?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var emptyBooking: UIView!
    
    let vm = SavedFavouritesVM()
    let disposeBag = DisposeBag()
    let input = PublishSubject<SavedFavouritesVM.Input>()
    
    var savedFavourites: [SavedFavouritesData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Saved Favourites"
        setup()
        bind()
        
//        input.onNext(.getSavedFavourites)
        LoadingModal.show()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        input.onNext(.getSavedFavourites)
    }
    
    func setup(){
        emptyBooking.isHidden = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        
        collectionView.reloadData()
        updateCollectionViewHeight(collectionView, collectionViewHeightConstraint)
    }
    
    func updateCollectionViewHeight(_ collectionView: UICollectionView, _ collectionViewHeightConstraint: NSLayoutConstraint) {
        collectionView.layoutIfNeeded()
        let contentHeight = collectionView.contentSize.height
        collectionViewHeightConstraint.constant = contentHeight
        
        self.view.layoutIfNeeded()
    }

    
    func bind(){
        vm.transform(input: input)

        vm.output.subscribe(onNext: {[weak self] event in
            guard let self = self else { return }
            LoadingModal.dismiss()
            switch event {
            case .getSavedFavouritesSuccess(let response):
                self.savedFavourites = response.data ?? []
                if self.savedFavourites.isEmpty{
                    self.emptyBooking.isHidden = false
                    self.collectionView.isHidden = true
//                }else{
//                    self.emptyBooking.isHidden = false
//                    self.collectionView.isHidden = true
                }
                collectionView.reloadData()
            case .getSavedFavouritesFailed(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
        }).disposed(by: disposeBag)
    }

}

extension SavedView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedFavourites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
        let savedFavourites = savedFavourites[indexPath.item]
        let view = GeneralViewCell(frame: cell.bounds)
        view.identifier = "Saved " + indexPath.description
        if savedFavourites.favouritableType == "Boat" {
            view.model.titleLabel = savedFavourites.boat?.name ?? ""
            view.model.infoOneLabel = "\(savedFavourites.boat?.locations?.city ?? ""), \(savedFavourites.boat?.locations?.state ?? "") \(savedFavourites.boat?.locations?.country ?? "")"
            view.model.infoTwoLabel = "\(savedFavourites.boat?.availabilities?.availableFrom?.convertToShorterDateFormat() ?? "") - \(savedFavourites.boat?.availabilities?.availableTo?.convertToShorterDateFormat() ?? "")"
            view.model.priceLabel = "₦ \(savedFavourites.boat?.destinations?.first?.price ?? "")"
            view.model.ratingLabel = "\(savedFavourites.boat?.rating ?? 0)"
            view.model.bannerImg = savedFavourites.boat?.images?.first?.url ?? ""
            
        }else{
            view.isBeachHouseMode = true
            view.model.titleLabel = savedFavourites.beachHouse?.name ?? ""
            view.model.infoOneLabel = "\(savedFavourites.beachHouse?.locations?.city ?? ""), \(savedFavourites.beachHouse?.locations?.state ?? "") \(savedFavourites.beachHouse?.locations?.country ?? "")"
            view.model.infoTwoLabel = "\(savedFavourites.beachHouse?.availabilities.availableFrom?.convertToShorterDateFormat() ?? "") - \(savedFavourites.beachHouse?.availabilities.availableTo?.convertToShorterDateFormat() ?? "")"
            view.model.priceLabel = "₦ \(savedFavourites.beachHouse?.listingPrice ?? 0)"
            view.model.ratingLabel = "\(savedFavourites.beachHouse?.rating ?? 0)"
            view.model.bannerImg = savedFavourites.beachHouse?.image ?? ""
            
        }
        
        
        cell.applyView(view: view)
        cell.layer.backgroundColor = UIColor.white.cgColor
        cell.layer.cornerRadius = 15
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width - 10, height: 400)
       
    }
    
}



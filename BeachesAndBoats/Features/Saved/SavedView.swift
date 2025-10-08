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
        
        bind()
        setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        LoadingModal.show()
        fetchFavorites()
    }
    
    func fetchFavorites(){
        input.onNext(.getSavedFavourites)
    }
    
    func saveFavourite(itemId: String?, type: BookingType) {
        guard let id = itemId else { return }
        let request = AddFavouriteRequest(itemId: id, type: type.rawValue, note: "")
        input.onNext(.addFavourite(request))
        Toast.show(message: "Removing Favourite")
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
                setup()
                collectionView.reloadData()
                
            case .getSavedFavouritesFailed(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
                
            case .addFavouriteSuccess(let response):
                Toast.show(message: response.message ?? "Removing from Favourites")
                self.fetchFavorites()
            case .addFavouriteFailed(let error):
                Toast.show(message: error.message ?? "Error Removing from Favourites")
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
        view.isSaved = true
        
        if savedFavourites.favouritableType == "Boat" {
            view.isBoatMode = true
            view.isBeachHouseMode = false
            
            let destinations: [Destination] = savedFavourites.boat?.destinations ?? []
            var ribbonText = ""
            
            if destinations.contains(where: { $0.name == "Cruising"}) && destinations.count == 1{
                ribbonText = "Cruising"
            } else if destinations.contains(where: { $0.name == "Cruising"}) && destinations.count > 1{
                ribbonText = "Cruising + Travel destinations"
            } else {
                ribbonText = "Travel destinations"
            }
            view.model = GeneralViewCellModel(
                ribbonTagLabel: ribbonText,
                titleLabel: savedFavourites.boat?.name ?? "",
                priceLabel: "", // Hidden in boat mode
                ratingLabel: "\(savedFavourites.boat?.rating ?? 0)",
                infoOneLabel: "\(savedFavourites.boat?.locations?.jettyLocation ?? ""), \(savedFavourites.boat?.locations?.name ?? "")",
                infoTwoLabel: "\(savedFavourites.boat?.availabilities?.availableFrom?.convertToShorterDateFormat() ?? "") - \(savedFavourites.boat?.availabilities?.availableTo?.convertToShorterDateFormat() ?? "")",
                bannerImg: savedFavourites.boat?.images?.first?.url ?? ""
            )
            
            
            view.onSaveFavouriteTapped = { [weak self] in
                self?.saveFavourite(itemId: savedFavourites.boat?.id, type: .Boat)
            }
            
        }else{
            view.isBeachHouseMode = true
            view.isBoatMode = false
            
            let isEntireHouse: Bool = savedFavourites.beachHouse?.bookingType == "FULL"
            let isAny: Bool = savedFavourites.beachHouse?.bookingType == "ANY"
            let isSingle: Bool = savedFavourites.beachHouse?.bookingType == "SINGLE"
            
            var price = ""
            
            if isEntireHouse || isAny {
                price = "₦ \(savedFavourites.beachHouse?.listingPrice?.toAmount() ?? "0")"
            }else if isSingle {
                price = "₦ \(savedFavourites.beachHouse?.minRoomPricePerNight?.toAmount() ?? "0")"
            }
            
            // Configure the model
            view.model = GeneralViewCellModel(
                ribbonTagLabel: "",
                titleLabel: savedFavourites.beachHouse?.name ?? "",
                priceLabel: price,
                ratingLabel: "\(savedFavourites.beachHouse?.rating ?? 0)",
                infoOneLabel: "\(savedFavourites.beachHouse?.locations?.jettyLocation ?? ""), \(savedFavourites.beachHouse?.locations?.name ?? "")",
                infoTwoLabel: "\(savedFavourites.beachHouse?.availabilities.availableFrom?.convertToShorterDateFormat() ?? "") - \(savedFavourites.beachHouse?.availabilities.availableTo?.convertToShorterDateFormat() ?? "")",
                bannerImg: savedFavourites.beachHouse?.image ?? ""
            )
            
            
            view.onSaveFavouriteTapped = { [weak self] in
                self?.saveFavourite(itemId: savedFavourites.beachHouse?.id, type: .BeachHouse)
            }
        }
        
        
        cell.applyView(view: view)
        cell.layer.backgroundColor = UIColor.white.cgColor
        cell.layer.cornerRadius = 15
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let savedFavourites = savedFavourites[indexPath.item]
        
        if savedFavourites.favouritableType == "Boat" {
            coordinator?.gotoBoatDetails(id: savedFavourites.boat?.id ?? "")
        }else{
            coordinator?.gotoBeachDetails(id: savedFavourites.beachHouse?.id ?? "")
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width - 10, height: 400)
       
    }
    
}



//
//  TravelLocationView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/10/2024.
//

import UIKit

class TravelLocationView: BaseViewControllerPlain {
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var boatData: BoatDatas?
    var createBoatListing: CreateBoatListingRequest?
    var boatType: String?
    
    var selectedItems: [DestinationPrices] = []
    var moneyInput: MoneyEnteredModel?
    
    var destinationList: [DestinationsData]?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Boats"
        setup()
    }
    
    func setup(){
        stepOneProgress.setProgress(0.60, animated: true)
        stepOneProgress.tintColor = .B_B
        stepTwoProgress.setProgress(0, animated: false)
        
        destinationList = boatData?.destinations
        
        collectionView.backgroundColor = UIColor.background.lighter(by: 17)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
    }

    @IBAction func nextTapped(_ sender: Any) {
        if let boatData = boatData{
            let request = CreateBoatListingRequest(type: createBoatListing?.type ?? [], name: createBoatListing?.name ?? "", description: createBoatListing?.description ?? "", from_when: createBoatListing?.from_when ?? "", to_when: createBoatListing?.to_when ?? "", amenities: createBoatListing?.amenities ?? [], preferred_languages: createBoatListing?.preferred_languages ?? [], brief_introduction: createBoatListing?.brief_introduction ?? "", rules: createBoatListing?.rules ?? [], no_of_adults: createBoatListing?.no_of_adults ?? 0, no_of_children: createBoatListing?.no_of_children ?? 0, no_of_pets: createBoatListing?.no_of_pets ?? 0, country: createBoatListing?.country ?? "", state: createBoatListing?.state ?? "", city: createBoatListing?.city ?? "", street_address: createBoatListing?.street_address ?? "", destinations_prices: selectedItems, images: [])
            print(request)
            coordinator?.gotoBoatUploadImageView(boatData: boatData, createBoatListingData: request, boatType: boatType ?? "")
        }
    }
    

}

extension TravelLocationView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return destinationList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell

        cell.isUserInteractionEnabled = true
        let view = DestinationCheckboxView(frame: cell.bounds)
        view.identifier = "Destination Cell " + indexPath.description
        let item = destinationList?[indexPath.row]
        
        let itemId = item?.destination_id ?? ""
        
        if let existingIndex = selectedItems.firstIndex(where: { $0.id == itemId }) {
            view.model.state = true
        } else {
            view.model.state = false
        }
                
        
        view.model.title = item?.name ?? ""
        view.model.onMoneyEntered = { moneyEntered in
            self.moneyInput?.id = "\(itemId)"
            self.moneyInput?.amount = moneyEntered
        }
        
        view.isUserInteractionEnabled = false
        cell.applyView(view: view)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthOfScreen: CGFloat = collectionView.bounds.width
//        let heightOfScreen = collectionView.bounds.height
        return CGSize(width: widthOfScreen, height: 70)
       
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DynamicCollectionViewCell
        let view = DestinationCheckboxView(frame: cell.bounds)
        guard let item = destinationList?[indexPath.row] else { return }
        
        let itemId = item.destination_id
        
        if let existingIndex = selectedItems.firstIndex(where: { $0.id == itemId }) {
            // Item is already selected, so remove it from selectedItems
            selectedItems.remove(at: existingIndex)
            view.model.state = true
        } else {
            // Item is not selected, so add it to selectedItems
            let newMoneyEntered = DestinationPrices(id: itemId, price: moneyInput?.amount ?? 0)
            selectedItems.append(newMoneyEntered)
            view.model.state = false
        }
        
        view.model.title = item.name
        view.model.onMoneyEntered = { moneyEntered in
            self.moneyInput?.id = "\(itemId)"
            self.moneyInput?.amount = moneyEntered
        }
        
        collectionView.reloadItems(at: [indexPath])
            
        nextBtn.isEnabled = true
    }

    
}

struct MoneyEnteredModel{
    var id: String
    var amount: Int
}

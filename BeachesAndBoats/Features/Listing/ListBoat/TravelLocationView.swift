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
    
    var selectedItems: [Destination] = []
//    var moneyInput: MoneyEnteredModel?
    
    var destinationList: [Destinations]?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Boats"
        setup()
    }
    
    func setup(){
        stepOneProgress.setProgress(1, animated: false)
        stepOneProgress.tintColor = .success
        stepTwoProgress.setProgress(0.55, animated: true)
        stepTwoProgress.tintColor = .B_B
        
        destinationList = boatData?.destinations
        nextBtn.isEnabled = true
        
        collectionView.backgroundColor = UIColor.background.lighter(by: 17)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
    }

    @IBAction func nextTapped(_ sender: Any) {
        if let boatData = boatData{
            if var createBoatListing = createBoatListing{
                createBoatListing.destinations = selectedItems
                print(createBoatListing)
                
                
                coordinator?.gotoBoatUploadImageView(boatData: boatData, createBoatListingData: createBoatListing, boatType: boatType ?? "")
            }
            
        }
    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        if var createBoatListing = createBoatListing{
            createBoatListing.destinations = selectedItems
            
            AppStorage.boatListing = createBoatListing
            coordinator?.backToDashboard()
        }

    }
    

}

extension TravelLocationView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return destinationList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthOfScreen: CGFloat = collectionView.bounds.width
        //        let heightOfScreen = collectionView.bounds.height
        return CGSize(width: widthOfScreen, height: 70)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell

        let view = DestinationCheckboxView(frame: cell.bounds)
        view.identifier = "Destination Cell " + indexPath.description
        let item = destinationList?[indexPath.row]
        let itemId = item?.id ?? ""
        
        if let selectedItem = selectedItems.first(where: { $0.destinationId == itemId }) {
            view.model.state = true
            view.model.title = item?.name ?? ""
            view.moneyInput.text = "\(selectedItem.pricePerHour)"
        } else {
            view.model.state = false
            view.model.title = item?.name ?? ""
            view.moneyInput.text = ""
        }
        
        view.model.onMoneyEntered = { [weak self] moneyEntered in
            guard let self = self else { return }

            if let index = self.selectedItems.firstIndex(where: { $0.destinationId == itemId }) {
                // Update price if item is already selected
                self.selectedItems[index].pricePerHour = moneyEntered
                print("Updated price for \(itemId) to \(moneyEntered)")
            }

            self.nextBtn.isEnabled = !self.selectedItems.isEmpty
        }
                
        
        cell.applyView(view: view)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
        let view = DestinationCheckboxView(frame: cell.bounds)
        guard let item = destinationList?[indexPath.row] else { return }
        let itemId = item.id ?? ""

        if let index = selectedItems.firstIndex(where: { $0.destinationId == itemId }) {
            selectedItems.remove(at: index)
        } else {
            let defaultAmount: Double = 0
            let newMoneyEntered = Destination(destinationId: itemId, pricePerHour: defaultAmount)
            selectedItems.append(newMoneyEntered)
        }

        collectionView.reloadItems(at: [indexPath])
        nextBtn.isEnabled = !selectedItems.isEmpty
        print("Updated selected items: \(selectedItems)")
    }
    
    

    
    
    
}



//struct MoneyEnteredModel{
//    var id: String
//    var amount: Int
//}

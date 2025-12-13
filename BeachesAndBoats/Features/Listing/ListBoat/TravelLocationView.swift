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
    
    var selectedItems: [CreateDestination] = []
//    var moneyInput: MoneyEnteredModel?
    
    var destinationList: [BoatDestinations]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Boats"
        
        checkAndLoadSavedListing()
        setup()
    }
    
    private func checkAndLoadSavedListing() {
        if let savedListing = AppStorage.boatListing {
            print("=== LOADING SAVED BOAT LISTING ===")
            print("Destinations count: \(savedListing.destinations?.count ?? 0)")
            
            // Use the saved listing
//            createBoatListing = savedListing
            
            // Load saved destinations
            selectedItems = savedListing.destinations ?? []
            
            print("Loaded saved boat listing successfully")
            print("===============================")
        } else {
            print("No saved boat listing found, starting fresh")
        }
    }
    
    func setup(){
        stepOneProgress.setProgress(1, animated: false)
        stepOneProgress.tintColor = .success
        stepTwoProgress.setProgress(0.55, animated: true)
        stepTwoProgress.tintColor = .B_B
        
        destinationList = boatData?.destinations
        
        collectionView.backgroundColor = UIColor.background.lighter(by: 17)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        
        // Enable next button if we have saved destinations
        updateNextButtonState()
    }
    
    private func updateNextButtonState() {
        nextBtn.isEnabled = validateSelectedItems()
    }
    
    private func validateSelectedItems() -> Bool {
        return selectedItems.contains { ($0.pricePerHour ?? 0) > 0 }
    }
            

//    private func validateSelectedItems() -> Bool {
//        selectedItems = selectedItems.filter { ($0.pricePerHour ?? 0) > 0 }
//        return !selectedItems.isEmpty
//    }
    
    @IBAction func nextTapped(_ sender: Any) {
        guard validateSelectedItems() else {
            Toast.show(message: "Please select at least one destination with a valid price.")
            return
        }
        
        // Filter out invalid items only when moving to the next screen
        let validItems = selectedItems.filter { ($0.pricePerHour ?? 0) > 0 }
        print(validItems)
        
        if let boatData = boatData, var createBoatListing = createBoatListing {
            createBoatListing.destinations = validItems
            coordinator?.gotoBoatUploadImageView(boatData: boatData, createBoatListingData: createBoatListing, boatType: boatType ?? "")
        }
    }
           

//    @IBAction func nextTapped(_ sender: Any) {
//        guard validateSelectedItems() else {
//            Toast.show(message: "Please select at least one destination with a valid price greater than 0.")
//            return
//        }
//               
//        
//        if let boatData = boatData{
//            if var createBoatListing = createBoatListing{
//                createBoatListing.destinations = selectedItems
//                print(createBoatListing)
//                
//                
//                coordinator?.gotoBoatUploadImageView(boatData: boatData, createBoatListingData: createBoatListing, boatType: boatType ?? "")
//            }
//            
//        }
//    }
    
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
        
        let item = destinationList?[indexPath.row]
        let itemId = item?.id ?? ""
        
        let isSelected = selectedItems.contains(where: { $0.destinationId == itemId })
        
        if isSelected {
            return CGSize(width: widthOfScreen, height: 95)
        } else {
            return CGSize(width: widthOfScreen, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
        
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let view = DestinationCheckboxView(frame: cell.bounds)
        view.identifier = "Destination Cell " + indexPath.description
        let item = destinationList?[indexPath.row]
        let itemId = item?.id ?? ""
        
        view.model.title = item?.name ?? ""
        
        if let selectedItem = selectedItems.first(where: { $0.destinationId == itemId }) {
            view.model.state = true
//            view.moneyInput.text = "\(selectedItem.pricePerHour ?? 0)"
            let price = selectedItem.pricePerHour ?? 0
            view.moneyInput.textField.text = price > 0 ? "\(price)" : ""
//            view.moneyInput.text = price > 0 ? "\(price)" : ""
        } else {
            view.model.state = false
            view.moneyInput.text = ""
        }
        view.setup()
        
        view.checkBox.stateChanged = { [weak self] newState in
            guard let self = self else { return }
            
            if newState {
                // Select
                if !self.selectedItems.contains(where: { $0.destinationId == itemId }) {
                    let defaultAmount: Float = 0
                    let newItem = CreateDestination(destinationId: itemId, pricePerHour: defaultAmount)
                    self.selectedItems.append(newItem)
                }
            } else {
                // Deselect
                self.selectedItems.removeAll(where: { $0.destinationId == itemId })
            }
            
            // Toggle visibility of input without reloading the whole cell (keeps keyboard open if needed)
            view.model.state = newState
            view.updateInputFieldVisibility()
            self.collectionView.performBatchUpdates(nil)
            self.updateNextButtonState()
        }
                    
        view.model.onMoneyEntered = { [weak self] moneyEntered in
            guard let self = self else { return }

            if let index = self.selectedItems.firstIndex(where: { $0.destinationId == itemId }) {
                self.selectedItems[index].pricePerHour = moneyEntered
                print("Updated price for \(itemId) to \(moneyEntered)")
            }
            
            self.updateNextButtonState()
        }
                
        cell.applyView(view: view)
        return cell

    }
    
    
}

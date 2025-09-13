//
//  EditBoatAddressView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/09/2025.
//

import UIKit
import RxSwift

class EditBoatAddressView: BaseViewControllerPlain {

    var coordinator: HostingServiceMenuCoordinator?
    
    @IBOutlet weak var locationField: InputField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    var boatType: String?
    
    var boatData: BoatDatas?
    var createBoatListing: CreateBoatListingRequest?
    var locations: [PropertyLocation]?
    
    var disposeBag = DisposeBag()
    var vm = EditBoatViewModel()
    var id: String?
    
    private var selectedIndex: Int? = nil
    var boatLocation: String?
    var selectedBoatLocation: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Boats"
        
        checkAndLoadSavedListing()
        bindNetwork()
        setup()
        
    }
    
    func setup(){

        locations = boatData?.property_location
        
        locationField.textChanged = { [weak self] textField, range, replacementString in
            guard let self = self else { return }
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: replacementString)
        }
        
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        
        updateCollectionViewHeight(collectionView, collectionViewHeight)
        collectionView.reloadData()
        
        selectSavedBoatLocation()

    }
    
    private func checkAndLoadSavedListing() {
        if let savedListing = createBoatListing {
            print("=== LOADING SAVED BOAT LISTING ===: \(savedListing)")
            
            // Use the saved listing
//            createBoatListing = savedListing
            
            // Populate fields with saved data
            locationField.text = savedListing.jettyLocation ?? ""
            selectedBoatLocation = savedListing.locationName
            
            print("Loaded saved boat listing successfully")
            print("===============================")
        } else {
            print("No saved boat listing found, starting fresh")
        }
    }
    
    private func selectSavedBoatLocation() {
        guard let savedLocationId = selectedBoatLocation,
              let locations = locations else { return }
        
        // Find the index of the saved location
        for (index, location) in locations.enumerated() {
            if location.id == savedLocationId {
                selectedIndex = index
                boatLocation = location.name
                
                print("Found saved boat location: \(location.name ?? "") at index \(index)")
                
                // Reload collection view to show selection
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                return // Exit early
            }
        }
        
        // Fallback: No match found, clear selection
        print("No saved boat location match found.")
        selectedIndex = nil
        selectedBoatLocation = nil
        boatLocation = nil
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func updateCollectionViewHeight(_ collectionView: UICollectionView, _ heightConstraint: NSLayoutConstraint) {
        collectionView.layoutIfNeeded()
        heightConstraint.constant = collectionView.contentSize.height
        view.layoutIfNeeded()
    }

    
    @IBAction func saveAndExit(_ sender: Any) {
        guard let id = id, validateJettyLocation() else { return }
        
        if var createBoatListing = createBoatListing{
            createBoatListing.locationName = boatLocation
            createBoatListing.jettyLocation = locationField.text
            
            self.createBoatListing = createBoatListing
            print(createBoatListing)
            
            LoadingModal.show(title: "Updating Record...")
            vm.editBoat(createBoatListing, id: id)
            
        }


    }
    
    func bindNetwork(){
        vm.output.subscribe(onNext: {[weak self] response in
            LoadingModal.dismiss()
            
            switch response {
            case .editBoatSuccessful(let response):
                print(response)
                MiddleModal.show(title: response.message ?? "", type: .success, onConfirm: { self?.coordinator?.popToBoatOptionsScreen() })
                
            case .editBoatFailed(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
            
        }).disposed(by: disposeBag)
    }
}


extension EditBoatAddressView{
    func validateJettyLocation() -> Bool{
        let validate = locationField.validate(rules: [Rule(.isEmpty, "Enter your jetty location")])
        
        return validate
    }

    
}

extension EditBoatAddressView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locations?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell

        cell.isUserInteractionEnabled = true
        let view = SelectableCheckbox(frame: cell.bounds)
        view.checkButton.btnType = "radio"
        view.identifier = "BeachLocations Cell " + indexPath.description
        
        guard let item = locations?[indexPath.row] else {
            return cell
        }
        
        view.model.subtitle = item.name ?? ""
        
        // Set the state based on whether this item is selected
        view.model.state = (selectedIndex == indexPath.item)
        
        view.isUserInteractionEnabled = false
        cell.applyView(view: view)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthOfScreen: CGFloat = collectionView.bounds.width
//        let heightOfScreen = collectionView.bounds.height
        return CGSize(width: widthOfScreen, height: 35)
       
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previousIndex = selectedIndex
        
        // Update selection
        if selectedIndex == indexPath.item {
            selectedIndex = nil
            selectedBoatLocation = nil
            boatLocation = nil
        } else {
            selectedIndex = indexPath.item
            selectedBoatLocation = locations?[indexPath.item].id
            boatLocation = locations?[indexPath.item].name
        }
        
        // Update the previously selected cell (if any)
        if let previous = previousIndex,
           let previousCell = collectionView.cellForItem(at: IndexPath(item: previous, section: 0)) as? DynamicCollectionViewCell,
           let previousView = previousCell.subviews.first(where: { $0 is SelectableCheckbox }) as? SelectableCheckbox {
            previousView.model.state = false
        }
        
        // Update the currently selected cell
        if let currentCell = collectionView.cellForItem(at: indexPath) as? DynamicCollectionViewCell,
           let currentView = currentCell.subviews.first(where: { $0 is SelectableCheckbox }) as? SelectableCheckbox {
            currentView.model.state = (selectedIndex == indexPath.item)
        }
        
        print("Selected Index: \(selectedIndex ?? -1)")
    }
    
}


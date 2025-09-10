//
//  BoatAddressView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/10/2024.
//

import UIKit
import MapKit
import CoreLocation

class BoatAddressView: BaseViewControllerPlain {

    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var locationField: InputField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var boatType: String?
    
    var boatData: BoatDatas?
    var createBoatListing: CreateBoatListingRequest?
    var locations: [PropertyLocation]?
    
    private var selectedIndex: Int? = nil
    var boatLocation: String?
    var selectedBoatLocation: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Boats"
        setup()
        
    }
    
    func setup(){
        stepOneProgress.setProgress(0.1, animated: true)
        stepOneProgress.tintColor = .B_B
        stepTwoProgress.setProgress(0, animated: false)

        locations = boatData?.property_location
        
        locationField.textChanged = { [weak self] textField, range, replacementString in
            guard let self = self else { return }
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: replacementString)
            
            nextBtn.isEnabled = updatedText.count >= 5
        }
        
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        
        updateCollectionViewHeight(collectionView, collectionViewHeight)
        collectionView.reloadData()

    }
    
    private func updateCollectionViewHeight(_ collectionView: UICollectionView, _ heightConstraint: NSLayoutConstraint) {
        collectionView.layoutIfNeeded()
        heightConstraint.constant = collectionView.contentSize.height
        view.layoutIfNeeded()
    }


    
    @IBAction func nextTapped(_ sender: Any) {
        guard validateJettyLocation() else { return }
        if let boatData = boatData{
            if var createBoatListing = createBoatListing{
                createBoatListing.locationName = boatLocation
                createBoatListing.jettyLocation = locationField.text
                print(createBoatListing)
                
                coordinator?.gotoTravelLocationView(boatData: boatData, createBoatListingData: createBoatListing, boatType: boatType ?? "")
            }
         
            
            
        }
    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        if var createBoatListing = createBoatListing{

            createBoatListing.locationName = boatLocation
            createBoatListing.jettyLocation = locationField.text
            
            AppStorage.boatListing = createBoatListing
            coordinator?.backToDashboard()
        }

    }
}


extension BoatAddressView{
    func validateJettyLocation() -> Bool{
        let validate = locationField.validate(rules: [Rule(.isEmpty, "Enter your jetty location")])
        
        return validate
    }

    
}

extension BoatAddressView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
            nextBtn.isEnabled = false
        } else {
            selectedIndex = indexPath.item
            selectedBoatLocation = locations?[indexPath.item].id
            boatLocation = locations?[indexPath.item].name
            nextBtn.isEnabled = true
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

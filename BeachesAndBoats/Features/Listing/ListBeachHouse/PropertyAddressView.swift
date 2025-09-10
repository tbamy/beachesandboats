//
//  PropertyAddressView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/10/2024.
//

import UIKit

class PropertyAddressView: BaseViewControllerPlain {

    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var locationField: InputField!
    @IBOutlet weak var locationCollectionView: UICollectionView!
    @IBOutlet weak var locationCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var beachData: BeachDatas?
    var locations: [PropertyLocation]?
    var createBeachListing: CreateBeachListingRequest?
    private var selectedIndex: Int? = nil
    var beachLocation: String?
    var selectBeachLocation: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beach Houses"
        
        setup()
        
    }
    
    func setup(){
        stepOneProgress.setProgress(0.50, animated: true)
        stepOneProgress.tintColor = .B_B
        stepTwoProgress.setProgress(0, animated: false)
        
        locationCollectionView.backgroundColor = .clear
        locationCollectionView.delegate = self
        locationCollectionView.dataSource = self
        locationCollectionView.allowsMultipleSelection = true
        locationCollectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")

        print("Collection view frame: \(locationCollectionView.frame)")
//        print("Collection view height constraint: \(locationCollectionViewHeight.constant)")
        
        locations = beachData?.property_location
        print(locations)
        
//        locationCollectionViewHeight.constant = 200
        view.layoutIfNeeded()
        
        DispatchQueue.main.async {
            self.locationCollectionView.reloadData()
            self.updateCollectionViewHeight(self.locationCollectionView, self.locationCollectionViewHeight)
        }
        
        locationField.textChanged = { [weak self] textField, range, replacementString in
            guard let self = self else { return }
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: replacementString)
            
            nextBtn.isEnabled = updatedText.count >= 5
        }
    }

    private func updateCollectionViewHeight(_ collectionView: UICollectionView, _ heightConstraint: NSLayoutConstraint) {
        collectionView.layoutIfNeeded()
        heightConstraint.constant = collectionView.contentSize.height
        view.layoutIfNeeded()
    }

    
    @IBAction func nextTapped(_ sender: Any) {
        guard validateJettyLocation() else {
            Toast.show(message: "Scroll down to enter your Jetty Location")
            return }
        if let beachData = beachData{
            if var createBeachListing = createBeachListing{
                createBeachListing.locationName = beachLocation
                createBeachListing.jettyLocation = locationField.text
                print(createBeachListing)
                
                coordinator?.gotoPropertyAvailableDatesView(beachData: beachData, createBeachListingData: createBeachListing)
            }
         
            
            
        }
    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        if var createBeachListing = createBeachListing{

            createBeachListing.locationName = beachLocation
            createBeachListing.jettyLocation = locationField.text
            
            AppStorage.beachListing = createBeachListing
            coordinator?.backToDashboard()
        }

    }
}


extension PropertyAddressView{
    func validateJettyLocation() -> Bool{
        let validate = locationField.validate(rules: [Rule(.isEmpty, "Enter your jetty location")])
        
        return validate
    }

    
}

extension PropertyAddressView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(locations?.count)
        return locations?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell

        cell.isUserInteractionEnabled = true
        let view = SelectableCheckbox(frame: cell.bounds)
        view.checkButton.btnType = "radio"
        view.identifier = "BeachLocationsCell " + indexPath.description
        
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
            selectBeachLocation = nil
            beachLocation = nil
            nextBtn.isEnabled = false
        } else {
            selectedIndex = indexPath.item
            selectBeachLocation = locations?[indexPath.item].id
            beachLocation = locations?[indexPath.item].name
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


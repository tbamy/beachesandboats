//
//  EditPropertyAddressView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 23/07/2025.
//

import UIKit
import MapKit
import CoreLocation
import RxSwift

class EditPropertyAddressView: BaseViewControllerPlain {

    var coordinator: HostingServiceMenuCoordinator?
    
    @IBOutlet weak var locationField: InputField!
    @IBOutlet weak var locationCollectionView: UICollectionView!
    @IBOutlet weak var locationCollectionViewHeight: NSLayoutConstraint!
    
    
    var beachData: BeachDatas?
    var locations: [PropertyLocation]?
    var createBeachListing: CreateBeachListingRequest?
    var details: GetBeachData?
    private var selectedIndex: Int? = nil
    var beachLocation: String?
    var selectBeachLocation: String?
    
    var id: String?
    
    var disposeBag = DisposeBag()
    var vm = EditBeachViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Property"
        
        bindNetwork()
        setup()
        
    }
    
    func setup(){
        locations = beachData?.property_location
        selectBeachLocation = details?.locations?.name ?? ""
        
        locationField.text = details?.locations?.jettyLocation ?? ""
        
        locationCollectionView.backgroundColor = .clear
        locationCollectionView.delegate = self
        locationCollectionView.dataSource = self
        locationCollectionView.allowsMultipleSelection = true
        locationCollectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        
        updateCollectionViewHeight(locationCollectionView, locationCollectionViewHeight)
        locationCollectionView.reloadData()
        
        selectSavedBeachLocation()
    }
    
    private func updateCollectionViewHeight(_ collectionView: UICollectionView, _ heightConstraint: NSLayoutConstraint) {
        collectionView.layoutIfNeeded()
        heightConstraint.constant = collectionView.contentSize.height
        view.layoutIfNeeded()
    }

    private func selectSavedBeachLocation() {
        guard let savedLocationId = selectBeachLocation,
              let locations = locations else { return }
        
        // Find the index of the saved location
        for (index, location) in locations.enumerated() {
            if location.name == savedLocationId {
                selectedIndex = index
                beachLocation = location.name
                
                print("Found saved beach location: \(location.name ?? "") at index \(index)")
                
                // Reload collection view to show selection
                DispatchQueue.main.async {
                    self.locationCollectionView.reloadData()
                }
                return // Exit early
            }
        }
        
        // Fallback: No match found, clear selection
        print("No saved boat location match found.")
        selectedIndex = nil
        selectBeachLocation = nil
        beachLocation = nil
        DispatchQueue.main.async {
            self.locationCollectionView.reloadData()
        }
    }
            
    
    @IBAction func saveAndExit(_ sender: Any) {
        guard let id = id else { return }
        if validateJettyLocation(){
            if createBeachListing == nil {
                createBeachListing = CreateBeachListingRequest()
            }
            createBeachListing?.locationName = beachLocation
            createBeachListing?.jettyLocation = locationField.text
            
                print(createBeachListing)
                
                LoadingModal.show(title: "Updating Record...")
            if let createBeachListing = createBeachListing {
                vm.editBeach(createBeachListing, id: id)
            }
                
            }

    }
    
    func bindNetwork(){
        vm.output.subscribe(onNext: {[weak self] response in
            LoadingModal.dismiss()
            
            switch response {
            case .editBeachSuccessful(let response):
                print(response)
                MiddleModal.show(title: response.message ?? "", type: .success, onConfirm: { self?.coordinator?.popToOptionsScreen() })
                
            case .editBeachFailed(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
            
        }).disposed(by: disposeBag)
    }
}


extension EditPropertyAddressView{
    func validateJettyLocation() -> Bool{
        let validate = locationField.validate(rules: [Rule(.isEmpty, "Enter your jetty location")])
        
        return validate
    }

    
}

extension EditPropertyAddressView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
            selectBeachLocation = nil
            beachLocation = nil
        } else {
            selectedIndex = indexPath.item
            selectBeachLocation = locations?[indexPath.item].id
            beachLocation = locations?[indexPath.item].name
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


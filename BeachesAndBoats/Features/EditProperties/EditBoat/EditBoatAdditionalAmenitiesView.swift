//
//  EditBoatAdditionalAmenitiesView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/09/2025.
//

import UIKit
import RxSwift

class EditBoatAdditionalAmenitiesView: BaseViewControllerPlain {
    var coordinator: HostingServiceMenuCoordinator?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var boatData: BoatDatas?
    var createBoatListing: CreateBoatListingRequest?
    var boatType: String?
    
    var selectedAmenities: [String] = []
    
    var amenitiesList: [RoomAmenities]?
    
    var disposeBag = DisposeBag()
    var vm = EditBoatViewModel()
    var id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Boats"
        
        checkAndLoadSavedListing()
        bindNetwork()
        setup()
    }
    
    private func checkAndLoadSavedListing() {
        if let savedListing = createBoatListing {
            print("=== LOADING SAVED BOAT LISTING ===")
            print("Total amenities count: \(savedListing.amenities?.count ?? 0)")
            
            // Use the saved listing
//            createBoatListing = savedListing
            
            // Load saved amenities (will be filtered for Safety type in setup)
            if let savedAmenities = savedListing.amenities {
                selectedAmenities = savedAmenities
            }
            
            print("Loaded saved boat listing successfully")
            print("===============================")
        } else {
            print("No saved boat listing found, starting fresh")
        }
    }
    
    private func filterSavedAmenities() {
        // Filter saved amenities to only include those that are "Safety" type
        guard let amenitiesList = amenitiesList else { return }
        
        let safetyAmenityIds = amenitiesList.compactMap { $0.id }
        selectedAmenities = selectedAmenities.filter { safetyAmenityIds.contains($0) }
        

    }
    
    func setup(){
        
        amenitiesList = boatData?.amenities?.filter{ $0.amenityType == "Safety"}
        subtitleLabel.text = "Select the amenities available to guests in your \(boatType ?? "")."
        
        // Filter saved amenities after amenitiesList is populated
        if createBoatListing != nil {
            filterSavedAmenities()
        }
        
        collectionView.backgroundColor = UIColor.background.lighter(by: 17)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        guard let id = id else { return }
        
        if var createBoatListing = createBoatListing{
            let existingAmenities = createBoatListing.amenities ?? []
            let nonSafetyAmenities = existingAmenities.filter { amenityId in
                guard let amenitiesList = self.amenitiesList else { return true }
                return !amenitiesList.contains { $0.id == amenityId }
            }
            
            createBoatListing.amenities = nonSafetyAmenities + selectedAmenities
            
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


extension EditBoatAdditionalAmenitiesView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return amenitiesList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell

        cell.isUserInteractionEnabled = true
        let view = SelectableCheckbox(frame: cell.bounds)
        view.identifier = "Additional Amenities Cell " + indexPath.description
        let item = amenitiesList?[indexPath.row]
        
        let itemId = item?.id ?? ""
        if selectedAmenities.contains(itemId) {
            view.model.state = true
        } else {
            view.model.state = false
        }
        
        view.model.subtitle = item?.name ?? ""
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
        let cell = collectionView.cellForItem(at: indexPath) as! DynamicCollectionViewCell
        let view = SelectableCheckbox(frame: cell.bounds)
        guard let item = amenitiesList?[indexPath.row] else { return }
        
        let itemId = item.id ?? ""
        
        if selectedAmenities.contains(itemId) {
            selectedAmenities.removeAll { $0 == itemId }
            view.model.state = true
//            view.model.image = UIImage.uncheckIcon
        } else {
            selectedAmenities.append(itemId)
            view.model.state = false
//            view.model.image = UIImage.checkIcon
        }
        
        collectionView.reloadItems(at: [indexPath])
            
    }

    
}


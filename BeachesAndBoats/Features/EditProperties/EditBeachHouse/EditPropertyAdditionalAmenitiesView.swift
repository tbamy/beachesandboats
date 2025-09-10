//
//  EditPropertyAdditionalAmenitiesView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 23/07/2025.
//

import UIKit
import RxSwift

class EditPropertyAdditionalAmenitiesView: BaseViewControllerPlain {
    var coordinator: HostingServiceMenuCoordinator?
    
    
    @IBOutlet weak var safetyAmenitiesCollectionView: UICollectionView!
    @IBOutlet weak var otherAmenitiesCollectionView: UICollectionView!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var property: BeachHouseListing?
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    
    var selectedItems: [String] = []
    var id: String?
    
    var safetyAmenitiesList: [RoomAmenities]?
    var otherAmenitiesList: [RoomAmenities]?
    
    var disposeBag = DisposeBag()
    var vm = EditBeachViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Property"
        
        bindNetwork()
        setup()
    }
    
    func setup(){
        
        safetyAmenitiesList = beachData?.amenities?.filter{ $0.amenityType == "Safety"}
        otherAmenitiesList = beachData?.amenities?.filter{ $0.amenityType == "Others"}
        
        safetyAmenitiesCollectionView.backgroundColor = UIColor.background.lighter(by: 17)
        otherAmenitiesCollectionView.backgroundColor = UIColor.background.lighter(by: 17)
        
        safetyAmenitiesCollectionView.delegate = self
        safetyAmenitiesCollectionView.tag = 0
        safetyAmenitiesCollectionView.dataSource = self
        safetyAmenitiesCollectionView.allowsMultipleSelection = true
        safetyAmenitiesCollectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        
        otherAmenitiesCollectionView.delegate = self
        otherAmenitiesCollectionView.tag = 1
        otherAmenitiesCollectionView.dataSource = self
        otherAmenitiesCollectionView.allowsMultipleSelection = true
        otherAmenitiesCollectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        
        selectedItems = createBeachListing?.amenities ?? []
        
        safetyAmenitiesCollectionView.reloadData()
        otherAmenitiesCollectionView.reloadData()
        
        nextBtn.isEnabled = !selectedItems.isEmpty
    }

    @IBAction func nextTapped(_ sender: Any) {
        guard let id = id else { return }
        let amenities = (createBeachListing?.amenities ?? []) + selectedItems
        if var createBeachListing = createBeachListing{
            createBeachListing.amenities = amenities
            self.createBeachListing = createBeachListing
            print(createBeachListing)
            
            
            LoadingModal.show(title: "Updating Record...")
            vm.editBeach(createBeachListing, id: id)
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

extension EditPropertyAdditionalAmenitiesView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0{
            return safetyAmenitiesList?.count ?? 0
        }else{
            return otherAmenitiesList?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell

        cell.isUserInteractionEnabled = true
        let view = SelectableCheckbox(frame: cell.bounds)
        view.identifier = "Additional Amenities Cell " + indexPath.description
        
        if collectionView.tag == 0{
            let item = safetyAmenitiesList?[indexPath.row]
            let itemId = item?.id ?? ""
            if selectedItems.contains(itemId) {
                view.model.state = true
            } else {
                view.model.state = false
            }
            
            view.model.subtitle = item?.name ?? ""
            view.isUserInteractionEnabled = false
            cell.applyView(view: view)
        }else{
            let item = otherAmenitiesList?[indexPath.row]
            let itemId = item?.id ?? ""
            if selectedItems.contains(itemId) {
                view.model.state = true
            } else {
                view.model.state = false
            }
            
            view.model.subtitle = item?.name ?? ""
            view.isUserInteractionEnabled = false
            cell.applyView(view: view)
        }
        
        
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
        
        if collectionView.tag == 0{
            guard let item = safetyAmenitiesList?[indexPath.row] else { return }
            
            let itemId = item.id ?? ""
            
            if selectedItems.contains(itemId) {
                selectedItems.removeAll { $0 == itemId }
                view.model.state = false
            } else {
                selectedItems.append(itemId)
                view.model.state = true
            }
        }else{
            guard let item = otherAmenitiesList?[indexPath.row] else { return }
            
            let itemId = item.id ?? ""
            
            if selectedItems.contains(itemId) {
                selectedItems.removeAll { $0 == itemId }
                view.model.state = false
            } else {
                selectedItems.append(itemId)
                view.model.state = true
            }
        }
        
        collectionView.reloadItems(at: [indexPath])
            
        nextBtn.isEnabled = true
    }

    
}


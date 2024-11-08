//
//  BoatHouseTypeView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/10/2024.
//

import UIKit
import RxSwift

class BoatHouseTypeView: BaseViewControllerPlain {
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var disposeBag = DisposeBag()
    var vm = BoatDataViewModel()
    
    var boatData: BoatDatas?
    var createBoatListing: CreateBoatListingRequest?
    var selectedItems: [String] = []
    var boatType: String?
    
    var boatTypes: [BoatTypes]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Boats"
    
        vm.getBoatData()
        LoadingModal.show()
        bindNetwork()
        
        setup()
        
    }
    
    func setup(){
        stepOneProgress.setProgress(0.60, animated: true)
        stepOneProgress.tintColor = .B_B
        stepTwoProgress.setProgress(0, animated: false)
        
        collectionView.backgroundColor = UIColor.background.lighter(by: 17)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
    }
    
    func bindNetwork(){
        vm.output.subscribe(onNext: { [weak self] response in
            
            switch response {
            case .getBoatDataSuccess(let response):
                self?.boatTypes = response.data.types
                self?.boatData = response.data
//                print(self?.boatTypes)
                LoadingModal.dismiss()
                self?.collectionView.reloadData()
            case .getBoatDataError(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
        }).disposed(by: disposeBag)
    }

    @IBAction func nextTapped(_ sender: Any) {
        if let boatData = boatData{
            let request = CreateBoatListingRequest(type: selectedItems, name: "", description: "", from_when: "", to_when: "", amenities: [], preferred_languages: [], brief_introduction: "", rules: [], no_of_adults: 0, no_of_children: 0, no_of_pets: 0, country: "", state: "", city: "", street_address: "", destinations_prices: [], images: [])
            
            coordinator?.gotoBoatNameView(boatData: boatData, createBoatListingData: request, boatType: boatType ?? "")
        }
    }
    

}

extension BoatHouseTypeView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boatTypes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell

        cell.isUserInteractionEnabled = true
        let view = SelectableCheckbox(frame: cell.bounds)
        view.checkButton.btnType = "radio"
        view.identifier = "Amenities Cell " + indexPath.description
        let item = boatTypes?[indexPath.row]
        
        let itemId = item?.type_id ?? ""
        if selectedItems.contains(itemId) {
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
        guard let item = boatTypes?[indexPath.row] else { return }
        boatType = item.name
        let itemId = item.type_id
        
        if selectedItems.contains(itemId) {
            selectedItems.removeAll { $0 == itemId }
            view.model.state = true
//            view.model.image = UIImage.uncheckIcon
        } else {
            selectedItems.append(itemId)
            view.model.state = false
//            view.model.image = UIImage.checkIcon
        }
        
        collectionView.reloadItems(at: [indexPath])
            
        nextBtn.isEnabled = true
    }

    
}

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
    var cat: String = ""
    var selectedBoatType: String?
    var boatType: String?
//    private var selectedIndex: IndexPath?
    private var selectedIndex: Int? = nil
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
                self?.boatTypes = response.data?.categories?.first?.subCategories
                self?.cat = response.data?.categories?.first?.id ?? ""
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
            let request = CreateBoatListingRequest(name: "", description: "", aboutOwner: "", noOfAdults: 0, noOfChildren: 0, noOfPets: 0, categoryId: cat, subCategoryId: selectedBoatType ?? "", country: "", state: "", streetName: "", city: "", availableFrom: "", availableTo: "", amenities: [], languages: [], houseRules: [], destinations: [], images: [])
            
            coordinator?.gotoBoatNameView(boatData: boatData, createBoatListingData: request, boatType: boatType ?? "")
        }
    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        let request = CreateBoatListingRequest(name: "", description: "", aboutOwner: "", noOfAdults: 0, noOfChildren: 0, noOfPets: 0, categoryId: cat, subCategoryId: selectedBoatType ?? "", country: "", state: "", streetName: "", city: "", availableFrom: "", availableTo: "", amenities: [], languages: [], houseRules: [], destinations: [], images: [])
        
        AppStorage.boatListing = request
        coordinator?.backToDashboard()
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
        guard let previousIndex = selectedIndex else {
            selectedIndex = indexPath.item
            collectionView.reloadItems(at: [indexPath])
            return
        }

        if previousIndex == indexPath.item {
            selectedIndex = nil
            collectionView.reloadItems(at: [indexPath])
        } else {
            selectedIndex = indexPath.item
            collectionView.reloadItems(at: [IndexPath(item: previousIndex, section: 0), indexPath])
        }
        
        print("selected Index \(selectedIndex)")

        let selectedItem = boatTypes?[indexPath.row]
        selectedBoatType = selectedItem?.id
        boatType = selectedItem?.name

        nextBtn.isEnabled = true
    }


    
}

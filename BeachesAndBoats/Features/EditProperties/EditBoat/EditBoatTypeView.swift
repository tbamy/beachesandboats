//
//  EditBoatTypeView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 12/09/2025.
//

import UIKit
import RxSwift

class EditBoatTypeView: BaseViewControllerPlain {
    var coordinator: HostingServiceMenuCoordinator?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var disposeBag = DisposeBag()
    var vm = EditBoatViewModel()
    var id: String?
    
    var boatData: BoatDatas?
    var createBoatListing: CreateBoatListingRequest?
    var details: GetBoatData?
    var cat: String = ""
    var selectedBoatType: String?
    var boatType: String?
    
    private var selectedIndex: Int? = nil
    var boatTypes: [BoatTypes]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Boats"
    
        checkAndLoadSavedListing()
        bindNetwork()
        
        setup()
        
    }
    
    private func checkAndLoadSavedListing() {
        if let savedListing = details {
            
            selectedBoatType = savedListing.subCategory?.id
            
        }
    }
    
    func setup(){
        boatTypes = boatData?.categories?.first?.sub_categories
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        collectionView.reloadData()
        selectSavedBoatType()
    }
    
    private func selectSavedBoatType() {
        guard let savedSubCategoryId = selectedBoatType,
              let boatTypes = boatTypes else { return }
        
        // Find the index of the saved subcategory
        for (index, boatType) in boatTypes.enumerated() {
            if boatType.id == savedSubCategoryId {
                selectedIndex = index
                self.boatType = boatType.name
                
                print("Found saved boat type: \(boatType.name ?? "") at index \(index)")
                
                // Reload collection view to show selection
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                break
            }
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

    
    @IBAction func saveAndExit(_ sender: Any) {
        guard let id = id else { return }
        
        if createBoatListing == nil{
            createBoatListing = CreateBoatListingRequest()
        }
            createBoatListing?.subCategoryId = selectedBoatType ?? ""
            
            print(createBoatListing)
            
        if let createBoatListing = createBoatListing{
            LoadingModal.show(title: "Updating Record...")
            vm.editBoat(createBoatListing, id: id)
            
        }
    }
    

}

extension EditBoatTypeView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boatTypes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell

        cell.isUserInteractionEnabled = true
        let view = SelectableCheckbox(frame: cell.bounds)
        view.checkButton.btnType = "radio"
        view.identifier = "BoatTypes Cell " + indexPath.description
        
        guard let item = boatTypes?[indexPath.row] else {
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
            selectedBoatType = nil
            boatType = nil
        } else {
            selectedIndex = indexPath.item
            selectedBoatType = boatTypes?[indexPath.item].id
            boatType = boatTypes?[indexPath.item].name
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


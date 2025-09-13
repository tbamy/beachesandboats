//
//  EditBoatTravelLocationView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/09/2025.
//

import UIKit
import RxSwift

class EditBoatTravelLocationView: BaseViewControllerPlain {
    var coordinator: HostingServiceMenuCoordinator?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var boatData: BoatDatas?
    var createBoatListing: CreateBoatListingRequest?
    var boatType: String?
    
    var disposeBag = DisposeBag()
    var vm = EditBoatViewModel()
    var id: String?
    
    var selectedItems: [CreateDestination] = []
//    var moneyInput: MoneyEnteredModel?
    
    var destinationList: [BoatDestinations]?
    
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
        destinationList = boatData?.destinations
        
        collectionView.backgroundColor = UIColor.background.lighter(by: 17)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
    }

    
    @IBAction func saveAndExit(_ sender: Any) {
        guard let id = id else { return }
        
        if var createBoatListing = createBoatListing{
            createBoatListing.destinations = selectedItems

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

extension EditBoatTravelLocationView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return destinationList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthOfScreen: CGFloat = collectionView.bounds.width
        //        let heightOfScreen = collectionView.bounds.height
        return CGSize(width: widthOfScreen, height: 70)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell

        let view = DestinationCheckboxView(frame: cell.bounds)
        view.identifier = "Destination Cell " + indexPath.description
        let item = destinationList?[indexPath.row]
        let itemId = item?.id ?? ""
        
        if let selectedItem = selectedItems.first(where: { $0.destinationId == itemId }) {
            view.model.state = true
            view.model.title = item?.name ?? ""
            view.moneyInput.text = "\(selectedItem.pricePerHour ?? 0)"
        } else {
            view.model.state = false
            view.model.title = item?.name ?? ""
            view.moneyInput.text = ""
        }
        
        view.model.onMoneyEntered = { [weak self] moneyEntered in
            guard let self = self else { return }

            if let index = self.selectedItems.firstIndex(where: { $0.destinationId == itemId }) {
                // Update price if item is already selected
                self.selectedItems[index].pricePerHour = moneyEntered
                print("Updated price for \(itemId) to \(moneyEntered)")
            }

        }
                
        
        cell.applyView(view: view)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let item = destinationList?[indexPath.row] else { return }
        let itemId = item.id ?? ""

        if let index = selectedItems.firstIndex(where: { $0.destinationId == itemId }) {
            selectedItems.remove(at: index)
        } else {
            let defaultAmount: Float = 0
            let newMoneyEntered = CreateDestination(destinationId: itemId, pricePerHour: defaultAmount)
            selectedItems.append(newMoneyEntered)
        }

        collectionView.reloadItems(at: [indexPath])
        print("Updated selected items: \(selectedItems)")
    }
    
    

    
    
    
}

//
//  EditBoatRulesView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/09/2025.
//

import UIKit
import RxSwift

class EditBoatRulesView: BaseViewControllerPlain {
    var coordinator: HostingServiceMenuCoordinator?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var numberOfPassengers: IncreaseDecreaseField!
    
    var boatData: BoatDatas?
    var createBoatListing: CreateBoatListingRequest?
    var details: GetBoatData?
    var boatType: String?
    
    var disposeBag = DisposeBag()
    var vm = EditBoatViewModel()
    var id: String?
    
    var boatRulesList: [HouseRule]?
    var selectedRules: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Boats"
        
        checkAndLoadSavedListing()
        bindNetwork()
        setup()
    }
    
    private func checkAndLoadSavedListing() {
        if let savedListing = details {
            print("=== LOADING SAVED BOAT LISTING ===")
            print("House rules count: \(savedListing.houseRules?.count ?? 0)")
            
            selectedRules = details?.houseRules?.compactMap{ $0.id } ?? []
            numberOfPassengers.model = IncreaseDecreaseModel(id: "", type: "Number of passengers", subtitle: "", count: Int(savedListing.noOfPassengers ?? 1))
            
            print("Loaded saved boat listing successfully")
            print("===============================")
        } else {
            print("No saved boat listing found, starting fresh")
        }
    }
    
    func setup(){
        
        boatRulesList = boatData?.house_rules
        
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        
        let passengersCount = createBoatListing?.noOfPassengers ?? 1
        print(passengersCount)
        numberOfPassengers.model = IncreaseDecreaseModel(id: "", type: "Number of passengers", subtitle: "", count: passengersCount)
        
        // Setup count change handlers
//        numberOfPassengers.onValueChange = { [weak self] _ in
//            self?.validateCount()
//        }
        
        updateCollectionViewHeight(collectionView, collectionViewHeight)
        collectionView.reloadData()
    }
    
    private func updateCollectionViewHeight(_ collectionView: UICollectionView, _ heightConstraint: NSLayoutConstraint) {
        collectionView.layoutIfNeeded()
        heightConstraint.constant = collectionView.contentSize.height
        view.layoutIfNeeded()
    }
    
//    private func validateCount() {
//        let hasValidCount = numberOfPassengers.count > 0
//        nextBtn.isEnabled = hasValidCount
//    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        guard let id = id else { return }
        
        if createBoatListing == nil{
            createBoatListing = CreateBoatListingRequest()
        }
            createBoatListing?.houseRules = selectedRules
            createBoatListing?.noOfPassengers = numberOfPassengers.count
            
            guard numberOfPassengers.count > 0  else {
                Toast.show(message: "Please select at least one passenger.")
                return
            }
            
            print(createBoatListing)
            
        if let createBoatListing = createBoatListing{
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

extension EditBoatRulesView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boatRulesList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
        
        let view = ToggleSwitch(frame: cell.bounds)
        view.identifier = "BoatRulesCell " + indexPath.description
        let item = boatRulesList?[indexPath.row]
        
        // Set title and initial toggle state
        view.model.title = item?.name ?? ""
        let itemId = item?.id ?? ""
        view.isToggled = selectedRules.contains(itemId)
        
        // Setup toggle action to update selectedRules
        view.toggleSwitch.addTarget(self, action: #selector(toggleSwitchChanged(_:)), for: .valueChanged)
        view.toggleSwitch.tag = indexPath.row
        
        cell.applyView(view: view)
        return cell
    }
    
    @objc func toggleSwitchChanged(_ sender: UISwitch) {
        let index = sender.tag
        guard let itemId = boatRulesList?[index].id else { return }
        
        if sender.isOn {
            if !selectedRules.contains(itemId) {
                selectedRules.append(itemId)
            }
        } else {
            selectedRules.removeAll { $0 == itemId }
        }
        
        let passengersCount = createBoatListing?.noOfPassengers ?? 1
        let hasValidCount = passengersCount > 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthOfScreen: CGFloat = collectionView.bounds.width
        return CGSize(width: widthOfScreen, height: 60)
    }
}

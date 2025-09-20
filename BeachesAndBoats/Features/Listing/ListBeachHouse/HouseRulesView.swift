//
//  HouseRulesView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/10/2024.
//

import UIKit

class HouseRulesView: BaseViewControllerPlain {
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var additionalRulesField: TextViewField!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    
    var houseRulesList: [HouseRule]?
    var selectedItems: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beach Houses"
        setup()
    }
    
    func setup(){
        additionalRulesField.numberOfCharacters = 255
        stepOneProgress.setProgress(0.90, animated: true)
        stepOneProgress.tintColor = .B_B
        stepTwoProgress.setProgress(0, animated: false)
        
        houseRulesList = beachData?.house_rules
        print(houseRulesList)
        
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        updateCollectionViewHeight(collectionView, collectionViewHeight)
        loadSavedData()
        collectionView.reloadData()
        
        nextBtn.isEnabled = !selectedItems.isEmpty
                
//        additionalRulesField.textChanged = { [weak self] textField, range, replacementString in
//            guard let self = self else { return }
//            let currentText = textField.text ?? ""
//            guard let stringRange = Range(range, in: currentText) else { return }
//            let updatedText = currentText.replacingCharacters(in: stringRange, with: replacementString)
//            
//            nextBtn.isEnabled = !selectedItems.isEmpty && additionalRulesField.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
//        }
    }
    
    private func updateCollectionViewHeight(_ collectionView: UICollectionView, _ heightConstraint: NSLayoutConstraint) {
        collectionView.layoutIfNeeded()
        heightConstraint.constant = collectionView.contentSize.height
        view.layoutIfNeeded()
    }

    @IBAction func nextTapped(_ sender: Any) {
        if let beachData = beachData{
            if var createBeachListing = createBeachListing{
                createBeachListing.houseRules = selectedItems
                createBeachListing.additionalHouseRules = additionalRulesField.text
                print(createBeachListing)
                
                coordinator?.gotoCheckInAndOutRulesView(beachData: beachData, createBeachListingData: createBeachListing)
            }
        }
    }
    
    
    @IBAction func saveAndExit(_ sender: Any) {
        if var createBeachListing = createBeachListing{
            createBeachListing.houseRules = selectedItems
            createBeachListing.additionalHouseRules = additionalRulesField.text
            
            AppStorage.beachListing = createBeachListing
            coordinator?.backToDashboard()
        }

    }


}

extension HouseRulesView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return houseRulesList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell

        cell.isUserInteractionEnabled = true
        let view = ToggleSwitch(frame: cell.bounds)
        view.identifier = "House Rules Cell " + indexPath.description
        let item = houseRulesList?[indexPath.row]
        view.model.title = item?.name ?? ""
//        print("Rule: \(item?.description)")
        let itemId = item?.id ?? ""
        view.isToggled = selectedItems.contains(itemId)
        
        // Setup toggle action to update selectedRules
        view.toggleSwitch.addTarget(self, action: #selector(toggleSwitchChanged(_:)), for: .valueChanged)
        view.toggleSwitch.tag = indexPath.row
        
        cell.applyView(view: view)
        return cell
    }
    
    @objc func toggleSwitchChanged(_ sender: UISwitch) {
        let index = sender.tag
        guard let itemId = houseRulesList?[index].id else { return }
        
        if sender.isOn {
            if !selectedItems.contains(itemId) {
                selectedItems.append(itemId)
            }
        } else {
            selectedItems.removeAll { $0 == itemId }
        }
        
        nextBtn.isEnabled = !selectedItems.isEmpty
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthOfScreen: CGFloat = collectionView.bounds.width
//        let heightOfScreen = collectionView.bounds.height
        return CGSize(width: widthOfScreen, height: 60)
       
    }


    
}


extension HouseRulesView {
    func loadSavedData() {
        guard let savedListing = AppStorage.beachListing else { return }
        
        // Load previously selected house rules
        selectedItems = savedListing.houseRules ?? []
        nextBtn.isEnabled = !selectedItems.isEmpty
        
        // Load additional house rules text
        if let additionalRules = savedListing.additionalHouseRules, !additionalRules.isEmpty {
            additionalRulesField.text = additionalRules
        }
        
        // Reload collection view to show selected states and update switches
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
            self?.updateCollectionViewHeight(self?.collectionView ?? UICollectionView(), self?.collectionViewHeight ?? NSLayoutConstraint())
        }
    }
}

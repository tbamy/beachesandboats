//
//  BoatAboutYouLanguageView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/10/2024.
//

import UIKit

class BoatAboutYouLanguageView: BaseViewControllerPlain {
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var boatData: BoatDatas?
    var createBoatListing: CreateBoatListingRequest?
    var boatType: String?
    
    var languageList: [Languages]?
    var selectedLanguages: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Boats"
        setup()
    }
    
    func setup(){
        stepOneProgress.setProgress(0.75, animated: true)
        stepOneProgress.tintColor = .B_B
        stepTwoProgress.setProgress(0, animated: false)
        
        languageList = boatData?.languages
        
        collectionView.backgroundColor = UIColor.background.lighter(by: 17)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
    }

    @IBAction func nextTapped(_ sender: Any) {
 
        if let boatData = boatData{
            if var createBoatListing = createBoatListing{
                createBoatListing.languages = selectedLanguages
                
                print(createBoatListing)
                
                coordinator?.gotoBoatAboutYouDescriptionView(boatData: boatData, createBoatListingData: createBoatListing, boatType: boatType ?? "")
            }
            
        }
    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        if var createBoatListing = createBoatListing{
            createBoatListing.languages = selectedLanguages
            
            AppStorage.boatListing = createBoatListing
            coordinator?.backToDashboard()
        }
        
    }


}

extension BoatAboutYouLanguageView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return languageList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell

        cell.isUserInteractionEnabled = true
        let view = SelectableCheckbox(frame: cell.bounds)
        view.identifier = "Languages Cell " + indexPath.description
        let item = languageList?[indexPath.row]
        
        let itemId = item?.id ?? ""
        if selectedLanguages.contains(itemId) {
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
        return CGSize(width: widthOfScreen, height: 28)
       
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DynamicCollectionViewCell
        let view = SelectableCheckbox(frame: cell.bounds)
        guard let item = languageList?[indexPath.row] else { return }
        
        let itemId = item.id ?? ""
        
        if selectedLanguages.contains(itemId) {
            selectedLanguages.removeAll { $0 == itemId }
            view.model.state = false
        } else {
            selectedLanguages.append(itemId)
            view.model.state = true
        }
        
        collectionView.reloadItems(at: [indexPath])
            
        nextBtn.isEnabled = true
    }

    
}

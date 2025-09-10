//
//  HouseTypeListView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/10/2024.
//

import UIKit

class HouseTypeListView: BaseViewControllerPlain {

    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var houseLists: [BeachSubCategory] = []
    var beachData: BeachDatas?
    var cat: String?
    var selectedName: String?
    var hostType: HostType?
    
    var createBeachListing: CreateBeachListingRequest?
    
    var selectedHouse: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beach Houses"

        setUp()
    }
    

    func setUp(){
        stepOneProgress.setProgress(0.25, animated: true)
        stepOneProgress.tintColor = .B_B
        stepTwoProgress.setProgress(0, animated: false)
        
        titleLabel.text = "What category best describes your \(selectedName ?? "Property")?"
        
        if let categories = beachData?.categories {
            houseLists = categories.first?.sub_categories ?? []
            print(categories)
            
            print(categories.first?.sub_categories)
        }
        
        print(houseLists)
        
        nextBtn.isEnabled = false
        collectionView.backgroundColor = UIColor.background.lighter(by: 17)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        if let beachData = beachData{
            let isPrivateStay = cat == "" ? 1 : 0
            let request = CreateBeachListingRequest(name: "", description: "", aboutOwner: "", checkInFrom: "", checkInTo: "", checkOutFrom: "", checkOutTo: "", categoryId: cat ?? "", subCategoryId: selectedHouse, bookingType: "", isPrivateStay: isPrivateStay, availableFrom: "", availableTo: "", amenities: [], languages: [], houseRules: [], rooms: [], roleType: hostType?.rawValue ?? "", listingPrice: 0, discountPercent: 0, pricePerDay: 0, dayDiscountPercent: 0)
            
            coordinator?.gotoHouseSizeListView(beachData: beachData, createBeachListingData: request, selectedName: selectedName ?? "Property")
        }
    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        let isPrivateStay = cat == "" ? 1 : 0
        let request = CreateBeachListingRequest(name: "", description: "", aboutOwner: "", checkInFrom: "", checkInTo: "", checkOutFrom: "", checkOutTo: "", categoryId: cat ?? "", subCategoryId: selectedHouse, bookingType: "", isPrivateStay: isPrivateStay, availableFrom: "", availableTo: "", amenities: [], languages: [], houseRules: [], rooms: [], roleType: hostType?.rawValue ?? "", listingPrice: 0, discountPercent: 0, pricePerDay: 0, dayDiscountPercent: 0)
            
            AppStorage.beachListing = request
            coordinator?.backToDashboard()
        

    }

}

extension HouseTypeListView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return houseLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell

        cell.isUserInteractionEnabled = true
        let view = SelectableView(frame: cell.bounds)
        view.identifier = "House Type Cell " + indexPath.description
        view.titleAndSubtitleOnlyMode = true
        view.backgroundColor = .white
        let item = houseLists[indexPath.row]
        view.model.title = item.name ?? ""
        view.model.subtitle = item.description ?? ""
        view.isUserInteractionEnabled = false
        cell.applyView(view: view)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthOfScreen: CGFloat = collectionView.bounds.width
//        let heightOfScreen = collectionView.bounds.height
        return CGSize(width: widthOfScreen, height: 115)
       
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        guard let subviews = cell?.subviews else { return }
        for view in subviews {
            if view is SelectableView {
                let v = view as! SelectableView
                v.model.state = true
            }
        }
        selectedHouse = houseLists[indexPath.row].id ?? ""
        nextBtn.isEnabled = true
    }

    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        guard let subviews = cell?.subviews else { return }
        for view in subviews {
            if view is SelectableView {
                let v = view as! SelectableView
                v.model.state = false
            }
        }
        nextBtn.isEnabled = false
    }
    
    
}


//struct houseLists{
//    var title: String
//    var subtitle: String
//}

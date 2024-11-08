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
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var houseLists: [BeachSubCategory]?
    var beachData: BeachDatas?
    var cat: String?
    
    
    var createBeachListing: CreateBeachListingRequest?
    
    var selectedHouse: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beaches Houses"

        setUp()
    }
    

    func setUp(){
        stepOneProgress.setProgress(0.25, animated: true)
        stepOneProgress.tintColor = .B_B
        stepTwoProgress.setProgress(0, animated: false)
        
        houseLists = beachData?.subCategories.filter({ $0.categoryID == cat}) ?? []
        nextBtn.isEnabled = false
        collectionView.backgroundColor = UIColor.background.lighter(by: 17)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        if let beachData = beachData{
            let request = CreateBeachListingRequest(category_id: cat ?? "", sub_cat_id: selectedHouse, guest_booking_id: "", name: "", description: "", country: "", state: "", city: "", street_address: "", from_when: "", to_when: "", amenities: [], preferred_languages: [""], brief_introduction: "", house_rules: [], check_in_start: "", check_in_end: "", check_out_start: "", check_out_end: "", roominfo: [], full_apartment_cost: 0, full_apartment_discount: 0, full_apartment_amount_to_earn: 0)
            
            if cat == "HC21849"{
                coordinator?.gotoPropertyNameView(beachData: beachData, createBeachListingData: request)
            }else{
                coordinator?.gotoHouseSizeListView(beachData: beachData, createBeachListingData: request)
            }
        }
    }

}

extension HouseTypeListView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return houseLists?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell

        cell.isUserInteractionEnabled = true
        let view = SelectableView(frame: cell.bounds)
        view.identifier = "House Type Cell " + indexPath.description
        view.titleAndSubtitleOnlyMode = true
        view.backgroundColor = .white
        let item = houseLists?[indexPath.row]
        view.model.title = item?.name ?? ""
        view.model.subtitle = item?.description ?? ""
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
        selectedHouse = houseLists?[indexPath.row].subCatID ?? ""
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

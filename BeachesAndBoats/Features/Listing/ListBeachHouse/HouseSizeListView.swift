//
//  HouseSizeListView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/10/2024.
//

import UIKit

class HouseSizeListView: BaseViewControllerPlain {

    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    var houseSizeLists: [HouseListModel] = []
    var selectedHouse: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beaches Houses"
        setUp()
    }
    
    func setUp(){
        stepOneProgress.setProgress(0.35, animated: true)
        stepOneProgress.tintColor = .B_B
        stepTwoProgress.setProgress(0, animated: false)
        
        houseSizeLists = [
            .init(name: "Entire beach house", image: "", description: "Guest enjoy exclusive access to the entire premises, without the need to share the space with the host or any other guests.", type: .full),
            .init(name: "A private room", image: "", description: "Guests can book private individual rooms, with common areas like sitting room and kitchen shared by the host and other guests.", type: .single),
            .init(name: "Entire house or a private room", image: "", description: "Guest can book either the whole house to themselves or book private room with shared areas with other guests or host.", type: .any)
                        ]

        nextBtn.isEnabled = false
        collectionView.backgroundColor = UIColor.background.lighter(by: 17)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")

    }

    @IBAction func nextTapped(_ sender: Any) {
        if let beachData = beachData{
            if var createBeachListing = createBeachListing{
                createBeachListing.bookingType = selectedHouse
                
                print(createBeachListing)
                
                coordinator?.gotoPropertyNameView(beachData: beachData, createBeachListingData: createBeachListing)
            }
            
            
        }
    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        if var createBeachListing = createBeachListing{
            createBeachListing.bookingType = selectedHouse
            
            AppStorage.beachListing = createBeachListing
            coordinator?.backToDashboard()
        }

    }
}

extension HouseSizeListView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return houseSizeLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell

        cell.isUserInteractionEnabled = true
        let view = SelectableView(frame: cell.bounds)
        view.identifier = "House Size Cell " + indexPath.description
        view.titleAndSubtitleWithImageOnlyMode = true
        view.displayImage = .property
        view.backgroundColor = .white
        let item = houseSizeLists[indexPath.row]
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
        selectedHouse = houseSizeLists[indexPath.row].type?.rawValue ?? ""
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


struct HouseListModel{
    let name, image, description: String?
    let type: HouseBookingType?
}

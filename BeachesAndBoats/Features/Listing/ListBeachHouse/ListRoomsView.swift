//
//  ListRoomsView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 02/10/2024.
//

import UIKit

class ListRoomsView: BaseViewControllerPlain {
    
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var nextBtn: PrimaryButton!
    @IBOutlet weak var roomName: InputField!
    @IBOutlet weak var roomDescription: TextViewField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var roomCount: NumberField!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var peopleCount: NumberField!
    @IBOutlet weak var privateRoomYes: CheckboxButton!
    @IBOutlet weak var privateRoomNo: CheckboxButton!
    
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    
    var bedTypes: [BedTypes] = []
    var selectedBedTypes: [BedType] = []
    var privateStatus: Bool?
    
    var allRoomData : [Room] = []
    var currentRoomIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beaches Houses"
        
        setup()
        
    }
    
    func setup(){
        stepOneProgress.setProgress(1, animated: false)
        stepOneProgress.tintColor = .success
        stepTwoProgress.setProgress(0.1, animated: true)
        stepTwoProgress.tintColor = .B_B
        
        privateRoomNo.isUserInteractionEnabled = true
        privateRoomYes.isUserInteractionEnabled = true
        
        privateRoomNo.stateChanged = { [weak self] isSelected in
            guard let self = self else { return }
            self.privateStatus = isSelected
            privateRoomYes.isChecked = false
        }
        
        privateRoomYes.stateChanged = { [weak self] isSelected in
            guard let self = self else { return }
            self.privateStatus = isSelected
            privateRoomNo.isChecked = false
        }
        
        updateCollectionViewHeight(collectionView, collectionViewHeight)
        
        collectionView.backgroundColor = UIColor.background.lighter(by: 17)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        
        
        
    }

    func updateCollectionViewHeight(_ collectionView: UICollectionView, _ collectionViewHeightConstraint: NSLayoutConstraint) {
        collectionView.layoutIfNeeded()
        let contentHeight = collectionView.contentSize.height
        collectionViewHeightConstraint.constant = contentHeight
        
        self.view.layoutIfNeeded()
    }
    
    
    func getSelectedBedTypes() -> [BedType] {
        var selectedBedTypes: [BedType] = []

        for cell in collectionView.visibleCells {
            if let dynamicCell = cell as? DynamicCollectionViewCell,
               let increaseDecreaseField = dynamicCell.contentView.subviews.first(where: { $0 is IncreaseDecreaseField }) as? IncreaseDecreaseField,
               let model = increaseDecreaseField.model,
               let indexPath = collectionView.indexPath(for: dynamicCell) { // Get the indexPath of the cell
                
                if indexPath.row < bedTypes.count {
                    let bedType = bedTypes[indexPath.row]
                    if model.count > 0 { // Only include bed types with count > 0
                        let selectedBedType = BedType(id: bedType.id ?? "", quantity: model.count)
                        selectedBedTypes.append(selectedBedType)
                    }
                }
            }
        }

        return selectedBedTypes
    }




    
    @IBAction func nextTapped(_ sender: Any) {
        if let beachData = beachData{
            let roomId = allRoomData.count
            let selectedBedTypes = getSelectedBedTypes()
            let newRoomData = Room(name: roomName.text, description: roomDescription.text, quantity: Int(roomCount.text) ?? 0, roomAmenities: [], pricePerNight: 0, discountPercent: 0, bedTypes: selectedBedTypes, hasPrivateBathroom: privateStatus ?? false, noOfOccupant: Int(peopleCount.text) ?? 0, images: [])
            
            allRoomData.append(newRoomData)
            
            if var createBeachListing = createBeachListing{
                createBeachListing.rooms = allRoomData
                print(createBeachListing)
                
                coordinator?.gotoRoomAmenitiesView(beachData: beachData, createBeachListingData: createBeachListing)
            }
        }
    }

}

extension ListRoomsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bedTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell

        cell.isUserInteractionEnabled = true
        let view = IncreaseDecreaseField(frame: cell.bounds)
        let item = bedTypes[indexPath.row]
        
        let itemId = item.id ?? ""
        
        view.model = IncreaseDecreaseModel(
                type: item.name ?? "",
                subtitle: item.description ?? "",
                count: 0
            )
        view.tag = indexPath.row
        
        view.isUserInteractionEnabled = false
        cell.applyView(view: view)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthOfScreen: CGFloat = collectionView.bounds.width
//        let heightOfScreen = collectionView.bounds.height
        return CGSize(width: widthOfScreen, height: 28)
       
    }
    

    
}

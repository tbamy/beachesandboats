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
    var privateStatus: Int?
    
    var allRoomData : [Room] = []
    var currentRoomIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beaches Houses"
        setup()
    }
    
    func setup() {
        stepOneProgress.setProgress(1, animated: false)
        stepOneProgress.tintColor = .success
        stepTwoProgress.setProgress(0.1, animated: true)
        stepTwoProgress.tintColor = .B_B
        
        privateRoomNo.stateChanged = { [weak self] isSelected in
            guard let self = self else { return }
//            self.privateStatus = isSelected
            if isSelected{
                self.privateStatus = 1
            }else{
                self.privateStatus = 0
            }
            self.privateRoomYes.isChecked = false
        }
        
        privateRoomYes.stateChanged = { [weak self] isSelected in
            guard let self = self else { return }
//            self.privateStatus = isSelected
            if isSelected{
                self.privateStatus = 1
            }else{
                self.privateStatus = 0
            }
            self.privateRoomNo.isChecked = false
        }
        
        collectionView.backgroundColor = UIColor.background.lighter(by: 17)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        
        allRoomData = createBeachListing?.rooms ?? []
        bedTypes = beachData?.bed_types ?? []
        collectionView.reloadData()
        updateCollectionViewHeight(collectionView, collectionViewHeight)
    }

    func updateCollectionViewHeight(_ collectionView: UICollectionView, _ collectionViewHeightConstraint: NSLayoutConstraint) {
        collectionView.layoutIfNeeded()
        let contentHeight = collectionView.contentSize.height
        collectionViewHeightConstraint.constant = contentHeight
        self.view.layoutIfNeeded()
    }

    
    @IBAction func nextTapped(_ sender: Any) {
        if let beachData = beachData {
            
            let newRoomData = Room(
                name: roomName.text,
                description: roomDescription.text,
                quantity: Int(roomCount.text) ?? 0,
                roomAmenities: [],
                pricePerNight: 0,
                discountPercent: 0,
                bedTypes: selectedBedTypes,
                hasPrivateBathroom: privateStatus ?? 0,
                noOfOccupant: Int(peopleCount.text) ?? 0,
                images: []
            )
            
            allRoomData.append(newRoomData)
            
            if var createBeachListing = createBeachListing {
                createBeachListing.rooms = allRoomData
                print(createBeachListing)
                
                coordinator?.gotoRoomAmenitiesView(beachData: beachData, createBeachListingData: createBeachListing)
            }
        }
    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        let newRoomData = Room(
            name: roomName.text,
            description: roomDescription.text,
            quantity: Int(roomCount.text) ?? 0,
            roomAmenities: [],
            pricePerNight: 0,
            discountPercent: 0,
            bedTypes: selectedBedTypes,
            hasPrivateBathroom: privateStatus ?? 0,
            noOfOccupant: Int(peopleCount.text) ?? 0,
            images: []
        )
        
        allRoomData.append(newRoomData)
        
        if var createBeachListing = createBeachListing {
            createBeachListing.rooms = allRoomData
            
            AppStorage.beachListing = createBeachListing
            coordinator?.backToDashboard()
        }

    }
}

extension ListRoomsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bedTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell

        // Ensure index is within bounds
        if indexPath.row >= 0 && indexPath.row < bedTypes.count {
            let bedTypeModel = bedTypes[indexPath.row]
            let increaseDecreaseField = IncreaseDecreaseField()
            increaseDecreaseField.model = IncreaseDecreaseModel(id: bedTypeModel.id ?? "", type: bedTypeModel.name ?? "", subtitle: bedTypeModel.description ?? "", count: 0)

            // Handle updates using the closure
            increaseDecreaseField.onValueChange = { [weak self] updatedModel in
                guard let self = self else { return }
                if let index = self.selectedBedTypes.firstIndex(where: { $0.id == updatedModel.id }) {
                    // Update existing entry
                    self.selectedBedTypes[index].quantity = updatedModel.count
                } else if updatedModel.count > 0 {
                    // Add new entry
                    self.selectedBedTypes.append(BedType(id: updatedModel.id, quantity: updatedModel.count))
                }
                // Remove entries with zero count
                self.selectedBedTypes.removeAll { $0.quantity == 0 }
            }

            cell.applyView(view: increaseDecreaseField)
        }

        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthOfScreen: CGFloat = collectionView.bounds.width
        return CGSize(width: widthOfScreen, height: 56)
    }
}

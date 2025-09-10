//
//  EditListRoomsView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 23/07/2025.
//

import UIKit

class EditListRoomsView: BaseViewControllerPlain {
    
    var coordinator: HostingServiceMenuCoordinator?
    
    @IBOutlet weak var nextBtn: PrimaryButton!
    @IBOutlet weak var roomName: InputField!
    @IBOutlet weak var roomDescription: TextViewField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var roomCount: NumberField!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var peopleCount: NumberField!
    @IBOutlet weak var privateRoomYes: CheckboxButton!
    @IBOutlet weak var privateRoomNo: CheckboxButton!
    
    var property: BeachHouseListing?
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    var id: String?
    
    var bedTypes: [BedTypes] = []
    var selectedBedTypes: [BedType] = []
    var privateStatus: Int?
    
    var allRoomData : [Room] = []
    var room: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Property"
        setup()
    }
    
    func setup() {
        guard let roomNameToFind = room,
              let rooms = createBeachListing?.rooms,
              let index = rooms.firstIndex(where: { $0.name == roomNameToFind }) else {
            return
        }

        let room = rooms[index]
        
        roomName.text = room.name ?? ""
        roomDescription.text = room.description ?? ""
        roomCount.text = "\(room.quantity ?? 0)"
        peopleCount.text = "\(room.noOfOccupant ?? 0)"
        privateRoomYes.isChecked = (room.hasPrivateBathroom ?? 0) == 1
        privateRoomNo.isChecked = (room.hasPrivateBathroom ?? 0) == 0
        selectedBedTypes = room.bedTypes ?? []
        
        
        
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
        
        
//        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 40, bottom: 10, right: 20)
//            flowLayout.minimumLineSpacing = 10
//            flowLayout.minimumInteritemSpacing = 10
//        }
    }

    func updateCollectionViewHeight(_ collectionView: UICollectionView, _ collectionViewHeightConstraint: NSLayoutConstraint) {
        collectionView.layoutIfNeeded()
        let contentHeight = collectionView.contentSize.height
        collectionViewHeightConstraint.constant = contentHeight
        self.view.layoutIfNeeded()
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        guard let id = id, let beachData = beachData, let createBeachListing = createBeachListing,
              let roomNameToFind = room, let rooms = createBeachListing.rooms,
              let roomIndex = rooms.firstIndex(where: { $0.name == roomNameToFind }) else {
            print("Error: Invalid data or room not found")
            return
        }
        
        guard selectedBedTypes.count > 0 else {
            Toast.show(message: "Please select at least one bed type.")
            return
        }
        
        // Get the existing room to preserve its data
        var existingRoom = rooms[roomIndex]
        
        // Update only the fields that are edited in this view
        existingRoom.name = roomName.text
        existingRoom.description = roomDescription.text
        existingRoom.quantity = Int(roomCount.text) ?? 0
        existingRoom.noOfOccupant = Int(peopleCount.text) ?? 0
        existingRoom.hasPrivateBathroom = privateStatus ?? 0
        existingRoom.bedTypes = selectedBedTypes
        
        // Update the rooms array
        var updatedRoomInfo = rooms
        updatedRoomInfo[roomIndex] = existingRoom
        
        // Update createBeachListing with the modified rooms
        var updatedBeachListing = createBeachListing
        updatedBeachListing.rooms = updatedRoomInfo
        
        print("Updated Room: \(existingRoom)")
        print("Updated CreateBeachListing: \(updatedBeachListing)")
        
        coordinator?.gotoEditRoomAmenitiesView(beachData: beachData, request: updatedBeachListing, room: room, id: id)
    }

    @IBAction func saveAndExit(_ sender: Any) {
        guard let createBeachListing = createBeachListing,
              let roomNameToFind = room, let rooms = createBeachListing.rooms,
              let roomIndex = rooms.firstIndex(where: { $0.name == roomNameToFind }) else {
            print("Error: Invalid data or room not found")
            return
        }
        
        guard selectedBedTypes.count > 0 else {
            Toast.show(message: "Please select at least one bed type.")
            return
        }
        
        // Get the existing room to preserve its data
        var existingRoom = rooms[roomIndex]
        
        // Update only the fields that are edited in this view
        existingRoom.name = roomName.text
        existingRoom.description = roomDescription.text
        existingRoom.quantity = Int(roomCount.text) ?? 0
        existingRoom.noOfOccupant = Int(peopleCount.text) ?? 0
        existingRoom.hasPrivateBathroom = privateStatus ?? 0
        existingRoom.bedTypes = selectedBedTypes
        
        // Update the rooms array
        var updatedRoomInfo = rooms
        updatedRoomInfo[roomIndex] = existingRoom
        
        // Update createBeachListing with the modified rooms
        var updatedBeachListing = createBeachListing
        updatedBeachListing.rooms = updatedRoomInfo
        self.createBeachListing = updatedBeachListing
        
        print("Updated Room: \(existingRoom)")
        print("Updated CreateBeachListing: \(updatedBeachListing)")
        
        coordinator?.popToRoomsListScreen()
    }

    
//    @IBAction func nextTapped(_ sender: Any) {
//        guard let id = id else { return }
//        if let beachData = beachData {
//            guard selectedBedTypes.count > 0 else {
//                Toast.show(message: "Please select at least one bed type.")
//                return
//            }
//            let newRoomData = Room(
//                name: roomName.text,
//                description: roomDescription.text,
//                quantity: Int(roomCount.text) ?? 0,
//                roomAmenities: [],
//                pricePerNight: 0,
//                discountPercent: 0,
//                pricePerDay: 0,
//                dayDiscountPercent: 0,
//                bedTypes: selectedBedTypes,
//                hasPrivateBathroom: privateStatus ?? 0,
//                noOfOccupant: Int(peopleCount.text) ?? 0,
//                images: []
//            )
//            
//            allRoomData.append(newRoomData)
//            
//            if var createBeachListing = createBeachListing {
//                createBeachListing.rooms = allRoomData
//                print(createBeachListing)
//                
//                coordinator?.gotoEditRoomAmenitiesView(beachData: beachData, request: createBeachListing, room: room, id: id)
//            }
//        }
//    }
//    
//    @IBAction func saveAndExit(_ sender: Any) {
//        let newRoomData = Room(
//            name: roomName.text,
//            description: roomDescription.text,
//            quantity: Int(roomCount.text) ?? 0,
//            roomAmenities: [],
//            pricePerNight: 0,
//            discountPercent: 0,
//            pricePerDay: 0,
//            dayDiscountPercent: 0,
//            bedTypes: selectedBedTypes,
//            hasPrivateBathroom: privateStatus ?? 0,
//            noOfOccupant: Int(peopleCount.text) ?? 0,
//            images: []
//        )
//        
//        allRoomData.append(newRoomData)
//        
//        if var createBeachListing = createBeachListing {
//            createBeachListing.rooms = allRoomData
//            
//            self.createBeachListing = createBeachListing
//            
//            print(createBeachListing)
//            
//            coordinator?.popToRoomsListScreen()
//        }
//
//    }
}

extension EditListRoomsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
                    self.selectedBedTypes[index].quantity = "\(updatedModel.count)"
                } else if updatedModel.count > 0 {
                    // Add new entry
                    self.selectedBedTypes.append(BedType(id: updatedModel.id, name: updatedModel.type, description: updatedModel.subtitle, quantity: "\(updatedModel.count)"))
                }
                // Remove entries with zero count
                self.selectedBedTypes.removeAll { $0.quantity == "0" }
            }

            cell.applyView(view: increaseDecreaseField)
        }

        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalHorizontalInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let widthOfScreen: CGFloat = collectionView.bounds.width - totalHorizontalInsets
        return CGSize(width: widthOfScreen - 40, height: 56)
    }
}

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
    
    var room: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beach Houses"
        setup()
    }
    
    func setup() {
        stepOneProgress.setProgress(1, animated: false)
        stepOneProgress.tintColor = .success
        stepTwoProgress.setProgress(0.1, animated: true)
        stepTwoProgress.tintColor = .B_B
        
        if let index = room,
           index >= 0,
           let rooms = createBeachListing?.rooms {
            
            let room = rooms[index]
            
            roomName.text = room.name ?? ""
            roomDescription.text = room.description ?? ""
            roomCount.text = "\(room.quantity ?? 1)"
            peopleCount.text = "\(room.noOfOccupant ?? 1)"
            privateRoomYes.isChecked = (room.hasPrivateBathroom ?? 0) == 1
            privateRoomNo.isChecked = (room.hasPrivateBathroom ?? 0) == 0
            selectedBedTypes = room.bedTypes ?? []
        }


        
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
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 40, bottom: 10, right: 20)
            flowLayout.minimumLineSpacing = 10
            flowLayout.minimumInteritemSpacing = 10
        }
    }

    func updateCollectionViewHeight(_ collectionView: UICollectionView, _ collectionViewHeightConstraint: NSLayoutConstraint) {
        collectionView.layoutIfNeeded()
        let contentHeight = collectionView.contentSize.height
        collectionViewHeightConstraint.constant = contentHeight
        self.view.layoutIfNeeded()
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        if let beachData = beachData {
            guard selectedBedTypes.count > 0 else {
                Toast.show(message: "Please select at least one bed type.")
                return
            }
            
            if var createBeachListing = createBeachListing {
                // Check if we're editing an existing room or creating a new one
                if let roomIndex = room, roomIndex >= 0, roomIndex < (createBeachListing.rooms?.count ?? 0) {
                    // EDITING MODE: Update only the fields modified on this screen
                    // Get the existing room data
                    var existingRoom = createBeachListing.rooms![roomIndex]
                    
                    // Update only the fields that are modified on this screen
                    existingRoom.name = roomName.text
                    existingRoom.description = roomDescription.text
                    existingRoom.quantity = Int(roomCount.text) ?? 0
                    existingRoom.bedTypes = selectedBedTypes
                    existingRoom.hasPrivateBathroom = privateStatus ?? 0
                    existingRoom.noOfOccupant = Int(peopleCount.text) ?? 0
                    
                    // PRESERVE all other existing data:
                    // - roomAmenities (set in RoomAmenitiesView)
                    // - pricePerNight (set in RoomPriceView)
                    // - discountPercent (set in RoomPriceView)
                    // - pricePerDay (set in RoomPricePerDayView)
                    // - dayDiscountPercent (set in RoomPricePerDayView)
                    // - images (set in UploadImageView)
                    
                    // Replace the room in the array
                    createBeachListing.rooms![roomIndex] = existingRoom
                    
                    print("EDITING MODE - Updated existing room at index \(roomIndex)")
                    print("Preserved amenities: \(existingRoom.roomAmenities?.count ?? 0)")
                    print("Preserved price per night: \(existingRoom.pricePerNight ?? 0)")
                    print("Preserved images: \(existingRoom.images?.count ?? 0)")
                } else {
                    // CREATING MODE: Create a new room with default values for unset fields
                    let newRoomData = Room(
                        name: roomName.text,
                        description: roomDescription.text,
                        quantity: Int(roomCount.text) ?? 0,
                        roomAmenities: [], // Will be set in next screens
                        pricePerNight: 0, // Will be set in RoomPriceView
                        discountPercent: 0, // Will be set in RoomPriceView
                        pricePerDay: 0, // Will be set in RoomPricePerDayView
                        dayDiscountPercent: 0, // Will be set in RoomPricePerDayView
                        bedTypes: selectedBedTypes,
                        hasPrivateBathroom: privateStatus ?? 0,
                        noOfOccupant: Int(peopleCount.text) ?? 0,
                        images: [] // Will be set in UploadImageView
                    )
                    
                    // Creating new room - append it
                    if createBeachListing.rooms == nil {
                        createBeachListing.rooms = []
                    }
                    createBeachListing.rooms?.append(newRoomData)
                    print("CREATING MODE - Added new room to list")
                }
                
                print("Total rooms: \(createBeachListing.rooms?.count ?? 0)")
                coordinator?.gotoRoomAmenitiesView(beachData: beachData, createBeachListingData: createBeachListing, room: room)
            }
        }
    }

    // MARK: - Also fix the saveAndExit method with the same logic
    @IBAction func saveAndExit(_ sender: Any) {
        if var createBeachListing = createBeachListing {
            // Check if we're editing an existing room or creating a new one
            if let roomIndex = room, roomIndex >= 0, roomIndex < (createBeachListing.rooms?.count ?? 0) {
                // EDITING MODE: Update only the fields modified on this screen
                var existingRoom = createBeachListing.rooms![roomIndex]
                
                // Update only the fields that are modified on this screen
                existingRoom.name = roomName.text
                existingRoom.description = roomDescription.text
                existingRoom.quantity = Int(roomCount.text) ?? 0
                existingRoom.bedTypes = selectedBedTypes
                existingRoom.hasPrivateBathroom = privateStatus ?? 0
                existingRoom.noOfOccupant = Int(peopleCount.text) ?? 0
                
                // Replace the room in the array (preserving all other fields)
                createBeachListing.rooms![roomIndex] = existingRoom
                
                print("EDITING MODE - Saved existing room at index \(roomIndex)")
            } else {
                // CREATING MODE: Create a new room
                let newRoomData = Room(
                    name: roomName.text,
                    description: roomDescription.text,
                    quantity: Int(roomCount.text) ?? 0,
                    roomAmenities: [],
                    pricePerNight: 0,
                    discountPercent: 0,
                    pricePerDay: 0,
                    dayDiscountPercent: 0,
                    bedTypes: selectedBedTypes,
                    hasPrivateBathroom: privateStatus ?? 0,
                    noOfOccupant: Int(peopleCount.text) ?? 0,
                    images: []
                )
                
                if createBeachListing.rooms == nil {
                    createBeachListing.rooms = []
                }
                createBeachListing.rooms?.append(newRoomData)
                print("CREATING MODE - Saved new room")
            }
            
            AppStorage.beachListing = createBeachListing
            coordinator?.backToDashboard()
        }
    }
    
//    @IBAction func nextTapped(_ sender: Any) {
//        if let beachData = beachData {
//            guard selectedBedTypes.count > 0 else {
//                Toast.show(message: "Please select at least one bed type.")
//                return
//            }
//            
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
//            if var createBeachListing = createBeachListing {
//                // Check if we're editing an existing room or creating a new one
//                if let roomIndex = room, roomIndex >= 0, roomIndex < (createBeachListing.rooms?.count ?? 0) {
//                    // Editing existing room - replace it
//                    createBeachListing.rooms?[roomIndex] = newRoomData
//                    print("Updated existing room at index \(roomIndex)")
//                } else {
//                    // Creating new room - append it
//                    if createBeachListing.rooms == nil {
//                        createBeachListing.rooms = []
//                    }
//                    createBeachListing.rooms?.append(newRoomData)
//                    print("Added new room to list")
//                }
//                
//                print(createBeachListing)
//                coordinator?.gotoRoomAmenitiesView(beachData: beachData, createBeachListingData: createBeachListing, room: room)
//            }
//        }
//    }
//
//    // Also update the saveAndExit function:
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
//        if var createBeachListing = createBeachListing {
//            // Check if we're editing an existing room or creating a new one
//            if let roomIndex = room, roomIndex >= 0, roomIndex < (createBeachListing.rooms?.count ?? 0) {
//                // Editing existing room - replace it
//                createBeachListing.rooms?[roomIndex] = newRoomData
//            } else {
//                // Creating new room - append it
//                if createBeachListing.rooms == nil {
//                    createBeachListing.rooms = []
//                }
//                createBeachListing.rooms?.append(newRoomData)
//            }
//            
//            AppStorage.beachListing = createBeachListing
//            coordinator?.backToDashboard()
//        }
//    }


    
//    @IBAction func nextTapped(_ sender: Any) {
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
//                coordinator?.gotoRoomAmenitiesView(beachData: beachData, createBeachListingData: createBeachListing, room: room)
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
//            AppStorage.beachListing = createBeachListing
//            coordinator?.backToDashboard()
//        }
//
//    }
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
        return CGSize(width: widthOfScreen, height: 56)
    }
}

//
//  RoomAmenitiesView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 08/10/2024.
//

import UIKit

class RoomAmenitiesView: BaseViewControllerPlain {
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    var selectedItems: [String] = []
    var room: Int?
    
    var amenitiesList: [RoomAmenities]?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beach Houses"
        setup()
    }
    
    func setup(){
        stepOneProgress.setProgress(1, animated: false)
        stepOneProgress.tintColor = .success
        stepTwoProgress.setProgress(0.25, animated: true)
        stepTwoProgress.tintColor = .B_B
        
        if let index = room,
           index >= 0,
           let rooms = createBeachListing?.rooms {
            
            let theroom = rooms[index]
            selectedItems = theroom.roomAmenities ?? []
            print(selectedItems)
        }
        
        amenitiesList = beachData?.room_amenities
        
        collectionView.backgroundColor = UIColor.background.lighter(by: 17)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        loadSavedData()
        collectionView.reloadData()
        
        nextBtn.isEnabled = !selectedItems.isEmpty
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        guard let beachData = beachData else { return }
        guard let createBeachListing = createBeachListing else { return }

        var updatedBeachListing = createBeachListing
        
        // Determine which room index to update
        let roomIndex: Int
        if let editingRoomIndex = room, editingRoomIndex >= 0 {
            // We're editing a specific room
            roomIndex = editingRoomIndex
        } else {
            // We're creating a new room, use the last index
            roomIndex = (createBeachListing.rooms?.count ?? 1) - 1
        }
        
        print("Updating room amenities at index: \(roomIndex)")
        
        // Safely update the room amenities
        if roomIndex >= 0 && roomIndex < (updatedBeachListing.rooms?.count ?? 0) {
            // PRESERVE existing room data, only update amenities
            var existingRoom = updatedBeachListing.rooms![roomIndex]
            existingRoom.roomAmenities = selectedItems
            updatedBeachListing.rooms![roomIndex] = existingRoom
            
            print("PRESERVED - Name: \(existingRoom.name ?? "")")
            print("PRESERVED - Price: \(existingRoom.pricePerNight ?? 0)")
            print("UPDATED - Amenities count: \(selectedItems.count)")
        } else {
            print("Error: Room at index \(roomIndex) does not exist in room info.")
            return
        }
        
        coordinator?.gotoRoomPriceView(beachData: beachData, createBeachListingData: updatedBeachListing, room: room)
    }

    @IBAction func saveAndExit(_ sender: Any) {
        guard let createBeachListing = createBeachListing else { return }

        var updatedBeachListing = createBeachListing
        
        // Determine which room index to update
        let roomIndex: Int
        if let editingRoomIndex = room, editingRoomIndex >= 0 {
            roomIndex = editingRoomIndex
        } else {
            roomIndex = (createBeachListing.rooms?.count ?? 1) - 1
        }
        
        // Safely update the room amenities
        if roomIndex >= 0 && roomIndex < (updatedBeachListing.rooms?.count ?? 0) {
            var existingRoom = updatedBeachListing.rooms![roomIndex]
            existingRoom.roomAmenities = selectedItems
            updatedBeachListing.rooms![roomIndex] = existingRoom
        }
        
        AppStorage.beachListing = updatedBeachListing
        coordinator?.backToDashboard()
    }
    
//    @IBAction func nextTapped(_ sender: Any) {
//        guard let beachData = beachData else { return }
//        guard let createBeachListing = createBeachListing else { return }
//
//        var updatedBeachListing = createBeachListing
//        
//        // Determine which room index to update
//        let roomIndex: Int
//        if let editingRoomIndex = room, editingRoomIndex >= 0 {
//            // We're editing a specific room
//            roomIndex = editingRoomIndex
//        } else {
//            // We're creating a new room, use the last index
//            roomIndex = (createBeachListing.rooms?.count ?? 1) - 1
//        }
//        
//        print("Updating room at index: \(roomIndex)")
//        
//        // Safely update the room amenities
//        if roomIndex >= 0 && roomIndex < (updatedBeachListing.rooms?.count ?? 0) {
//            updatedBeachListing.rooms?[roomIndex].roomAmenities = selectedItems
//            print("Selected Items: \(selectedItems)")
//            print("Updated Room: \(updatedBeachListing.rooms?[roomIndex] ?? Room())")
//        } else {
//            print("Error: Room at index \(roomIndex) does not exist in room info.")
//            return
//        }
//        
//        coordinator?.gotoRoomPriceView(beachData: beachData, createBeachListingData: updatedBeachListing, room: room)
//    }
//
//    // Also update saveAndExit in RoomAmenitiesView:
//    @IBAction func saveAndExit(_ sender: Any) {
//        guard let createBeachListing = createBeachListing else { return }
//
//        var updatedBeachListing = createBeachListing
//        
//        // Determine which room index to update
//        let roomIndex: Int
//        if let editingRoomIndex = room, editingRoomIndex >= 0 {
//            roomIndex = editingRoomIndex
//        } else {
//            roomIndex = (createBeachListing.rooms?.count ?? 1) - 1
//        }
//        
//        // Safely update the room amenities
//        if roomIndex >= 0 && roomIndex < (updatedBeachListing.rooms?.count ?? 0) {
//            updatedBeachListing.rooms?[roomIndex].roomAmenities = selectedItems
//        }
//        
//        AppStorage.beachListing = updatedBeachListing
//        coordinator?.backToDashboard()
//    }
    
    

//    @IBAction func nextTapped(_ sender: Any) {
//        guard let beachData = beachData else { return }
//        guard let createBeachListing = createBeachListing else { return }
//
//        // Get the last index of the rooms array
//        let roomIndex = createBeachListing.rooms?.indices.last ?? -1
//        print("Current room index is \(roomIndex)")
//
//        // Safely get a mutable copy of the rooms array
//        var updatedRoomInfo = createBeachListing.rooms
//        if roomIndex >= 0 && roomIndex < updatedRoomInfo?.count ?? 0 {
//            // Update the room amenities at the current room index
//            if var existingRoom = updatedRoomInfo?[roomIndex]{
//                existingRoom.roomAmenities = selectedItems
//                
//                // Reassign the updated room back to the array
//                updatedRoomInfo?[roomIndex] = existingRoom
//                
//                print("Selected Items: \(selectedItems)")
//                print("Updated Room: \(existingRoom)")
//            }
//        } else {
//            print("Error: Room at index \(roomIndex) does not exist in room info.")
//            return
//        }
//
//        // Create a mutable copy of the createBeachListing and update its rooms
//        var updatedBeachListing = createBeachListing
//        updatedBeachListing.rooms = updatedRoomInfo
//        
//        print("Updated CreateBeachListing: \(updatedBeachListing)")
//        
//        coordinator?.gotoRoomPriceView(beachData: beachData, createBeachListingData: updatedBeachListing, room: room)
//    }
//    
//    
//    
//    @IBAction func saveAndExit(_ sender: Any) {
//        guard let createBeachListing = createBeachListing else { return }
//
//        // Get the last index of the rooms array
//        let roomIndex = createBeachListing.rooms?.indices.last ?? -1
//        print("Current room index is \(roomIndex)")
//
//        // Safely get a mutable copy of the rooms array
//        var updatedRoomInfo = createBeachListing.rooms
//        if roomIndex >= 0 && roomIndex < updatedRoomInfo?.count ?? 0 {
//            // Update the room amenities at the current room index
//            if var existingRoom = updatedRoomInfo?[roomIndex]{
//                existingRoom.roomAmenities = selectedItems
//                
//                // Reassign the updated room back to the array
//                updatedRoomInfo?[roomIndex] = existingRoom
//                
//                print("Selected Items: \(selectedItems)")
//                print("Updated Room: \(existingRoom)")
//            }
//        } else {
//            print("Error: Room at index \(roomIndex) does not exist in room info.")
//            return
//        }
//
//        // Create a mutable copy of the createBeachListing and update its rooms
//        var updatedBeachListing = createBeachListing
//        updatedBeachListing.rooms = updatedRoomInfo
//            
//            AppStorage.beachListing = updatedBeachListing
//            coordinator?.backToDashboard()
//        
//
//    }

    

}

extension RoomAmenitiesView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return amenitiesList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell

        cell.isUserInteractionEnabled = true
        let view = SelectableCheckbox(frame: cell.bounds)
        view.identifier = "Amenities Cell " + indexPath.description
        let item = amenitiesList?[indexPath.row]
        
        let itemId = item?.id ?? ""
        if selectedItems.contains(itemId) {
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
        return CGSize(width: widthOfScreen, height: 35)
       
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DynamicCollectionViewCell
        let view = SelectableCheckbox(frame: cell.bounds)
        guard let item = amenitiesList?[indexPath.row] else { return }
        
        let itemId = item.id ?? ""
        
        if selectedItems.contains(itemId) {
            selectedItems.removeAll { $0 == itemId }
            view.model.state = true
//            view.model.image = UIImage.uncheckIcon
        } else {
            selectedItems.append(itemId)
            view.model.state = false
//            view.model.image = UIImage.checkIcon
        }
        
        collectionView.reloadItems(at: [indexPath])
        nextBtn.isEnabled = !selectedItems.isEmpty
//        collectionView.reloadItems(at: [indexPath])
//        nextBtn.isEnabled = true
        print("Currently selected amenities: \(selectedItems.count)")
    }

    
}


extension RoomAmenitiesView {
    func loadSavedData() {
        guard let savedListing = AppStorage.beachListing else { return }
        
        // If we're editing an existing room, load its amenities
        if let roomIndex = room, roomIndex >= 0, let rooms = savedListing.rooms, roomIndex < rooms.count {
            selectedItems = rooms[roomIndex].roomAmenities ?? []
            nextBtn.isEnabled = !selectedItems.isEmpty
            
            // Reload collection view to show selected states
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
}

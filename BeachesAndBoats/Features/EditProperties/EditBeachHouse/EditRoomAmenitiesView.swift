//
//  EditRoomAmenitiesView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 23/07/2025.
//

import UIKit

class EditRoomAmenitiesView: BaseViewControllerPlain {
    var coordinator: HostingServiceMenuCoordinator?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var property: BeachHouseListing?
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    var selectedItems: [String] = []
    var id: String?
    
    var room: String?
    
    var amenitiesList: [RoomAmenities]?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Property"
        setup()
    }
    
    func setup(){
        
        guard let roomNameToFind = room,
              let rooms = createBeachListing?.rooms,
              let index = rooms.firstIndex(where: { $0.name == roomNameToFind }) else {
            return
        }

        let room = rooms[index]

        amenitiesList = beachData?.room_amenities
        
        collectionView.backgroundColor = UIColor.background.lighter(by: 17)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        
        
        selectedItems = room.roomAmenities ?? []
        
        nextBtn.isEnabled = !selectedItems.isEmpty
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        guard let id = id, let beachData = beachData, let createBeachListing = createBeachListing,
              let roomNameToFind = room, let rooms = createBeachListing.rooms,
              let roomIndex = rooms.firstIndex(where: { $0.name == roomNameToFind }) else {
            print("Error: Invalid data or room not found")
            return
        }
        
        // Get the existing room to preserve its data
        var existingRoom = rooms[roomIndex]
        
        // Update only the roomAmenities field
        existingRoom.roomAmenities = selectedItems
        
        // Update the rooms array
        var updatedRoomInfo = rooms
        updatedRoomInfo[roomIndex] = existingRoom
        
        // Update createBeachListing with the modified rooms
        var updatedBeachListing = createBeachListing
        updatedBeachListing.rooms = updatedRoomInfo
        
        print("Updated Room: \(existingRoom)")
        print("Updated CreateBeachListing: \(updatedBeachListing)")
        
        coordinator?.gotoEditRoomPriceView(beachData: beachData, request: updatedBeachListing, room: room, id: id)
    }

    @IBAction func saveAndExit(_ sender: Any) {
        guard let createBeachListing = createBeachListing,
              let roomNameToFind = room, let rooms = createBeachListing.rooms,
              let roomIndex = rooms.firstIndex(where: { $0.name == roomNameToFind }) else {
            print("Error: Invalid data or room not found")
            return
        }
        
        // Get the existing room to preserve its data
        var existingRoom = rooms[roomIndex]
        
        // Update only the roomAmenities field
        existingRoom.roomAmenities = selectedItems
        
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
//        coordinator?.gotoEditRoomPriceView(beachData: beachData, request: updatedBeachListing, room: room, id: id)
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
//        self.createBeachListing = updatedBeachListing
//        
//        print(self.createBeachListing)
//        
//        coordinator?.popToRoomsListScreen()
//
//    }

    

}

extension EditRoomAmenitiesView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
            
        nextBtn.isEnabled = true
    }

    
}


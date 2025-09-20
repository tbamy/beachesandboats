//
//  EditRoomAmenitiesView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 23/07/2025.
//

//import UIKit
//
//class EditRoomAmenitiesView: BaseViewControllerPlain {
//    var coordinator: HostingServiceMenuCoordinator?
//    
//    @IBOutlet weak var collectionView: UICollectionView!
//    @IBOutlet weak var nextBtn: PrimaryButton!
//    
//    var property: BeachHouseListing?
//    var beachData: BeachDatas?
//    var createBeachListing: CreateBeachListingRequest?
//    var selectedItems: [String] = []
//    var id: String?
//    var details: GetBeachData?
//    
//    var room: String?
//    
//    var amenitiesList: [RoomAmenities]?
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Edit Property"
//        setup()
//    }
//    
//    func setup(){
//        
//        guard let roomNameToFind = room,
//              let rooms = createBeachListing?.rooms,
//              let index = rooms.firstIndex(where: { $0.name == roomNameToFind }) else {
//            return
//        }
//
//        let room = rooms[index]
//
//        amenitiesList = beachData?.room_amenities
//        
//        collectionView.backgroundColor = UIColor.background.lighter(by: 17)
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.allowsMultipleSelection = true
//        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
//        
//        
//        selectedItems = room.roomAmenities ?? []
//        
//        nextBtn.isEnabled = !selectedItems.isEmpty
//    }
//    
//    @IBAction func nextTapped(_ sender: Any) {
//        guard let id = id, let beachData = beachData, let createBeachListing = createBeachListing,
//              let roomNameToFind = room, let rooms = createBeachListing.rooms,
//              let roomIndex = rooms.firstIndex(where: { $0.name == roomNameToFind }) else {
//            print("Error: Invalid data or room not found")
//            return
//        }
//        
//        // Get the existing room to preserve its data
//        var existingRoom = rooms[roomIndex]
//        
//        // Update only the roomAmenities field
//        existingRoom.roomAmenities = selectedItems
//        
//        // Update the rooms array
//        var updatedRoomInfo = rooms
//        updatedRoomInfo[roomIndex] = existingRoom
//        
//        // Update createBeachListing with the modified rooms
//        var updatedBeachListing = createBeachListing
//        updatedBeachListing.rooms = updatedRoomInfo
//        
//        print("Updated Room: \(existingRoom)")
//        print("Updated CreateBeachListing: \(updatedBeachListing)")
//        
//        coordinator?.gotoEditRoomPriceView(beachData: beachData, request: updatedBeachListing, room: room, id: id, details: details)
//    }
//
//    @IBAction func saveAndExit(_ sender: Any) {
//        guard let createBeachListing = createBeachListing,
//              let roomNameToFind = room, let rooms = createBeachListing.rooms,
//              let roomIndex = rooms.firstIndex(where: { $0.name == roomNameToFind }) else {
//            print("Error: Invalid data or room not found")
//            return
//        }
//        
//        // Get the existing room to preserve its data
//        var existingRoom = rooms[roomIndex]
//        
//        // Update only the roomAmenities field
//        existingRoom.roomAmenities = selectedItems
//        
//        // Update the rooms array
//        var updatedRoomInfo = rooms
//        updatedRoomInfo[roomIndex] = existingRoom
//        
//        // Update createBeachListing with the modified rooms
//        var updatedBeachListing = createBeachListing
//        updatedBeachListing.rooms = updatedRoomInfo
//        self.createBeachListing = updatedBeachListing
//        
//        print("Updated Room: \(existingRoom)")
//        print("Updated CreateBeachListing: \(updatedBeachListing)")
//        
//        coordinator?.popToRoomsListScreen()
//    }
//
//    
//
//}
//
//extension EditRoomAmenitiesView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return amenitiesList?.count ?? 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
//
//        cell.isUserInteractionEnabled = true
//        let view = SelectableCheckbox(frame: cell.bounds)
//        view.identifier = "Amenities Cell " + indexPath.description
//        let item = amenitiesList?[indexPath.row]
//        
//        let itemId = item?.id ?? ""
//        if selectedItems.contains(itemId) {
//            view.model.state = true
//        } else {
//            view.model.state = false
//        }
//        
//        view.model.subtitle = item?.name ?? ""
//        view.isUserInteractionEnabled = false
//        cell.applyView(view: view)
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        let widthOfScreen: CGFloat = collectionView.bounds.width
////        let heightOfScreen = collectionView.bounds.height
//        return CGSize(width: widthOfScreen, height: 35)
//       
//    }
//    
//    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as! DynamicCollectionViewCell
//        let view = SelectableCheckbox(frame: cell.bounds)
//        guard let item = amenitiesList?[indexPath.row] else { return }
//        
//        let itemId = item.id ?? ""
//        
//        if selectedItems.contains(itemId) {
//            selectedItems.removeAll { $0 == itemId }
//            view.model.state = true
////            view.model.image = UIImage.uncheckIcon
//        } else {
//            selectedItems.append(itemId)
//            view.model.state = false
////            view.model.image = UIImage.checkIcon
//        }
//        
//        collectionView.reloadItems(at: [indexPath])
//            
//        nextBtn.isEnabled = true
//    }
//
//    
//}
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
    var details: GetBeachData?
    
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
        print("Room Amenities: \(room.roomAmenities ?? [])")
        print("Selected Items: \(selectedItems)")
        
        nextBtn.isEnabled = !selectedItems.isEmpty
        
        // Force reload to show pre-selected items
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
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
        
        coordinator?.gotoEditRoomPriceView(beachData: beachData, request: updatedBeachListing, room: room, id: id, details: details)
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
        
        // Set the correct state based on whether item is selected
        view.model.state = selectedItems.contains(itemId)
        view.model.subtitle = item?.name ?? ""
        view.isUserInteractionEnabled = false
        cell.applyView(view: view)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthOfScreen: CGFloat = collectionView.bounds.width
        return CGSize(width: widthOfScreen, height: 35)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = amenitiesList?[indexPath.row] else { return }
        
        let itemId = item.id ?? ""
        
        // Toggle selection
        if selectedItems.contains(itemId) {
            selectedItems.removeAll { $0 == itemId }
        } else {
            selectedItems.append(itemId)
        }
        
        // Reload the specific cell to update its visual state
        collectionView.reloadItems(at: [indexPath])
        
        // Update next button state
        nextBtn.isEnabled = !selectedItems.isEmpty
    }
}

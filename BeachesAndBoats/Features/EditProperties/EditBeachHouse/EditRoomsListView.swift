//
//  EditRoomsListView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 23/07/2025.
//

import UIKit

class EditRoomsListView: BaseViewControllerPlain {
    
    var coordinator: HostingServiceMenuCoordinator?
    
    @IBOutlet weak var nextBtn: PrimaryButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addNewBtn: UIButton!
    @IBOutlet weak var duplicateBtn: UIButton!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    var property: BeachHouseListing?
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    
    var roomsList: [Room] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Property"
        setup()
        
    }
    
    func setup(){
        
        collectionView.backgroundColor = UIColor.background.lighter(by: 17)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        
        roomsList = createBeachListing?.rooms ?? []
        collectionView.reloadData()
        updateCollectionViewHeight(collectionView, collectionViewHeightConstraint)
        
//        addNewBtn.isHidden = true
        duplicateBtn.isHidden = true
        
        addNewBtn.configureButtonTitle(title: "Add another room")
        addNewBtn.setTitleColor(.B_B, for: .normal)
        
        duplicateBtn.configureButtonTitle(title: "Duplicate room")
        duplicateBtn.setTitleColor(.B_B, for: .normal)
        
        duplicateBtn.isHidden = roomsList.count > 3
        
        addNewBtn.addTarget(self, action: #selector(addNewRoom), for: .touchUpInside)
        duplicateBtn.addTarget(self, action: #selector(duplicateRoom), for: .touchUpInside)
        
        nextBtn.isEnabled = !roomsList.isEmpty
    }
    
    func updateCollectionViewHeight(_ CollectionView: UICollectionView, _ CollectionViewHeightConstraint: NSLayoutConstraint) {
        CollectionView.layoutIfNeeded()
        let contentHeight = CollectionView.contentSize.height
        CollectionViewHeightConstraint.constant = contentHeight
        
        self.view.layoutIfNeeded()
    }
    
    @objc func addNewRoom(){
        if let beachData = beachData, var createBeachListing = createBeachListing{
            createBeachListing.rooms = roomsList
//            coordinator?.EditgotoListRoomsView(beachData: beachData, createBeachListingData: createBeachListing)
        }
    }
    
    @objc func duplicateRoom(){
        if var createBeachListing = createBeachListing{
            if let existingRoom = createBeachListing.rooms?.last{
                let roomDuplicate = Room(name: "\(existingRoom.name ?? "") Copy", description: existingRoom.description, quantity: existingRoom.quantity, roomAmenities: existingRoom.roomAmenities, pricePerNight: existingRoom.pricePerNight, discountPercent: existingRoom.discountPercent, pricePerDay: existingRoom.pricePerDay, dayDiscountPercent: existingRoom.dayDiscountPercent, bedTypes: existingRoom.bedTypes, hasPrivateBathroom: existingRoom.hasPrivateBathroom, noOfOccupant: existingRoom.noOfOccupant, images: existingRoom.images)
                
                createBeachListing.rooms?.append(roomDuplicate)
                roomsList = createBeachListing.rooms ?? []
                collectionView.reloadData()
                updateCollectionViewHeight(collectionView, collectionViewHeightConstraint)
                
                duplicateBtn.isHidden = roomsList.count > 3
            }
        }
    }

    @IBAction func nextTapped(_ sender: Any) {
        if let beachData = beachData, let createBeachListing = createBeachListing{
            self.createBeachListing = createBeachListing
            print(createBeachListing)
            
            coordinator?.popToOptionsScreen()
            }
            
    }

    
    func deleteItem(roomName: String) {
        if let index = roomsList.firstIndex(where: { $0.name == roomName }) {
            roomsList.remove(at: index)
            createBeachListing?.rooms = roomsList
            collectionView.reloadData()
            updateCollectionViewHeight(collectionView, collectionViewHeightConstraint)
        }
    }

    func editItem(roomName: String) {
        if let index = roomsList.firstIndex(where: { $0.name == roomName }) {
            if let beachData = beachData, var createBeachListing = createBeachListing {
                createBeachListing.rooms = roomsList
                coordinator?.gotoEditListRoomsView(beachData: beachData, request: createBeachListing, room: roomName)
            }
        }
    }


}

extension EditRoomsListView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roomsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell

        cell.isUserInteractionEnabled = true
        let view = RoomCard(frame: cell.bounds)
        view.identifier = "Rooms Cell " + indexPath.description
        let item = roomsList[indexPath.row]
        
        if let mainImage = item.images?.first{
            view.model.image = UIImage(data: mainImage)
        }
        
        view.model.numberOfBeds = item.quantity ?? 0
        view.model.numberOfGuests = item.noOfOccupant ?? 0
        view.model.numberOfRooms = item.quantity ?? 0
        view.model.roomName = item.name ?? ""
        view.model.roomPrice = "₦ \(item.pricePerNight ?? 0)"
        view.model.deleteTapped = { [weak self] in
            self?.deleteItem(roomName: item.name ?? "")
        }
        view.model.editTapped = { [weak self] in
            self?.editItem(roomName: item.name ?? "")
        }
        view.isUserInteractionEnabled = true
        cell.applyView(view: view)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthOfScreen: CGFloat = collectionView.bounds.width
//        let heightOfScreen = collectionView.bounds.height
        return CGSize(width: widthOfScreen, height: 170)
       
    }


    
}

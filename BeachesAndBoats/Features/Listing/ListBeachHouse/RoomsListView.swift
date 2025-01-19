//
//  RoomsListView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 09/10/2024.
//

import UIKit

class RoomsListView: BaseViewControllerPlain {
    
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var nextBtn: PrimaryButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addNewBtn: UIButton!
    @IBOutlet weak var duplicateBtn: UIButton!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    
    var roomsList: [Room] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beaches Houses"
        setup()
        
    }
    
    func setup(){
        stepOneProgress.setProgress(1, animated: false)
        stepOneProgress.tintColor = .success
        stepTwoProgress.setProgress(0.75, animated: true)
        stepTwoProgress.tintColor = .B_B
        
        nextBtn.isEnabled = true
        collectionView.backgroundColor = UIColor.background.lighter(by: 17)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        
        roomsList = createBeachListing?.rooms ?? []
        collectionView.reloadData()
        updateCollectionViewHeight(collectionView, collectionViewHeightConstraint)
        
        addNewBtn.configureButtonTitle(title: "Add another room")
        addNewBtn.setTitleColor(.B_B, for: .normal)
        
        duplicateBtn.configureButtonTitle(title: "Duplicate room")
        duplicateBtn.setTitleColor(.B_B, for: .normal)
        
        duplicateBtn.isHidden = roomsList.count > 1
        
        addNewBtn.addTarget(self, action: #selector(addNewRoom), for: .touchUpInside)
        duplicateBtn.addTarget(self, action: #selector(duplicateRoom), for: .touchUpInside)
        
        
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
            coordinator?.gotoListRoomsView(beachData: beachData, createBeachListingData: createBeachListing)
        }
    }
    
    @objc func duplicateRoom(){
        if var createBeachListing = createBeachListing{
            if let existingRoom = createBeachListing.rooms.first{
                let roomDuplicate = Room(name: "\(existingRoom.name) Copy", description: existingRoom.description, quantity: existingRoom.quantity, roomAmenities: existingRoom.roomAmenities, pricePerNight: existingRoom.pricePerNight, discountPercent: existingRoom.discountPercent, bedTypes: existingRoom.bedTypes, hasPrivateBathroom: existingRoom.hasPrivateBathroom, noOfOccupant: existingRoom.noOfOccupant, images: existingRoom.images)
                
                createBeachListing.rooms.append(roomDuplicate)
                roomsList = createBeachListing.rooms
                collectionView.reloadData()
                updateCollectionViewHeight(collectionView, collectionViewHeightConstraint)
                
                duplicateBtn.isHidden = roomsList.count > 1
            }
        }
    }

    @IBAction func nextTapped(_ sender: Any) {
        if let beachData = beachData{
            
            if let createBeachListing = createBeachListing{
                print(createBeachListing)
                
                coordinator?.gotoEntireApartmentPriceView(beachData: beachData, createBeachListingData: createBeachListing)
            }
            
        }
    }
    
    
    @IBAction func saveAndExit(_ sender: Any) {
        if var createBeachListing = createBeachListing{
            
            AppStorage.beachListing = createBeachListing
            coordinator?.backToDashboard()
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
//        if let index = roomsList.firstIndex(where: { $0.name == roomName }) {
//            if let beachData = beachData, var createBeachListing = createBeachListing {
//                createBeachListing.rooms = roomsList
//                coordinator?.gotoListRoomsView(beachData: beachData, createBeachListingData: createBeachListing)
//            }
//        }
    }


}

extension RoomsListView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
        
        view.model.numberOfBeds = item.quantity
        view.model.numberOfGuests = item.noOfOccupant
        view.model.numberOfRooms = item.quantity
        view.model.roomName = item.name
        view.model.roomPrice = "₦ \(item.pricePerNight)"
        view.model.deleteTapped = { [weak self] in
            self?.deleteItem(roomName: item.name)
        }
        view.model.editTapped = { [weak self] in
            self?.editItem(roomName: item.name)
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

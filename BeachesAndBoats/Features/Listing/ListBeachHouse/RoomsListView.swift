//
//  RoomsListView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 09/10/2024.
//

import UIKit
import RxSwift

class RoomsListView: BaseViewControllerPlain {
    
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var nextBtn: PrimaryButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addNewBtn: UIButton!
    @IBOutlet weak var duplicateBtn: UIButton!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    var disposeBag = DisposeBag()
    var vm = ListBeachViewModel()
    
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    
    var roomsList: [Room] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beaches Houses"
        
        bindNetwork()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("RoomsListView will appear - refreshing data")
        refreshRoomsData()
    }
    
    // IMPORTANT: Add this method to refresh data when returning from editing
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("RoomsListView did appear - refreshing data")
        refreshRoomsData()
    }
    
    func setup(){
        stepOneProgress.setProgress(1, animated: false)
        stepOneProgress.tintColor = .success
        stepTwoProgress.setProgress(0.75, animated: true)
        stepTwoProgress.tintColor = .B_B
        
        
        collectionView.backgroundColor = UIColor.background.lighter(by: 17)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        
        refreshRoomsData()
//        roomsList = createBeachListing?.rooms ?? []
//        collectionView.reloadData()
//        updateCollectionViewHeight(collectionView, collectionViewHeightConstraint)
        
        addNewBtn.configureButtonTitle(title: "Add another room")
        addNewBtn.setTitleColor(.B_B, for: .normal)
        
        duplicateBtn.configureButtonTitle(title: "Duplicate room")
        duplicateBtn.setTitleColor(.B_B, for: .normal)
        
//        duplicateBtn.isHidden = roomsList.count > 1
        
        addNewBtn.addTarget(self, action: #selector(addNewRoom), for: .touchUpInside)
        duplicateBtn.addTarget(self, action: #selector(duplicateRoom), for: .touchUpInside)
        
        nextBtn.isEnabled = !roomsList.isEmpty
        loadSavedData()
        collectionView.reloadData()
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
            self.createBeachListing = createBeachListing
            coordinator?.gotoListRoomsView(beachData: beachData, createBeachListingData: createBeachListing)
        }
    }
    
    
    @objc func duplicateRoom(){
        guard var createBeachListing = createBeachListing,
              let roomsToDuplicate = createBeachListing.rooms,
              !roomsToDuplicate.isEmpty else {
            return
        }
        
        // Use the first room (be consistent with your choice)
        let existingRoom = roomsToDuplicate.first!
        
        // Create a unique name for the duplicated room
        let duplicatedRoomName = generateUniqueName(baseName: existingRoom.name ?? "Room", existingRooms: roomsToDuplicate)
        
        let roomDuplicate = Room(
            name: duplicatedRoomName,
            description: existingRoom.description,
            quantity: existingRoom.quantity,
            roomAmenities: existingRoom.roomAmenities,
            pricePerNight: existingRoom.pricePerNight,
            discountPercent: existingRoom.discountPercent,
            pricePerDay: existingRoom.pricePerDay,
            dayDiscountPercent: existingRoom.dayDiscountPercent,
            bedTypes: existingRoom.bedTypes,
            hasPrivateBathroom: existingRoom.hasPrivateBathroom,
            noOfOccupant: existingRoom.noOfOccupant,
            images: existingRoom.images
        )
        
        // Update both arrays
        roomsList.append(roomDuplicate)
        createBeachListing.rooms = roomsList
        
        // Update the main createBeachListing property
        self.createBeachListing = createBeachListing
        
        print("Duplicated room: \(duplicatedRoomName)")
        
        // Refresh the UI
        refreshRoomsData()
    }

    
    private func refreshRoomsData() {
        print("=== REFRESHING ROOMS DATA ===")
        
        // Get the latest data from createBeachListing
        roomsList = createBeachListing?.rooms ?? []
        
        print("Number of rooms loaded: \(roomsList.count)")
        for (index, room) in roomsList.enumerated() {
            print("Room \(index): \(room.name ?? "Unnamed") - ₦\(room.pricePerNight ?? 0)")
        }
        
        // Update UI elements
        collectionView.reloadData()
        updateCollectionViewHeight(collectionView, collectionViewHeightConstraint)
        
        duplicateBtn.isHidden = roomsList.count > 1
        nextBtn.isEnabled = !roomsList.isEmpty
        
        print("UI updated with latest room data")
        print("============================")
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        if let beachData = beachData, var createBeachListing = createBeachListing{
            // Make sure we're passing the latest room data
            createBeachListing.rooms = roomsList
            self.createBeachListing = createBeachListing
            
            print("Proceeding to next step with \(roomsList.count) rooms")
            if createBeachListing.bookingType == "SINGLE" {
                LoadingModal.show(title: "Hold on while we list your Property")
                vm.createBeach(createBeachListing)
            }else {
                coordinator?.gotoEntireApartmentPriceView(beachData: beachData, createBeachListingData: createBeachListing)
            }
            
        }
    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        if var createBeachListing = createBeachListing{
            // Make sure we're saving the latest room data
            createBeachListing.rooms = roomsList
            
            AppStorage.beachListing = createBeachListing
            coordinator?.backToDashboard()
        }
    }

    
    
    
    func deleteItem(roomName: String) {
        if let index = roomsList.firstIndex(where: { $0.name == roomName }) {
            roomsList.remove(at: index)
            
            // Update the main createBeachListing
            createBeachListing?.rooms = roomsList
            
            print("Deleted room: \(roomName)")
            
            // Refresh the UI
            refreshRoomsData()
        }
    }
    
    func editItem(roomIndex: Int) {
        guard roomIndex >= 0, roomIndex < roomsList.count else {
            print("Invalid room index: \(roomIndex)")
            return
        }
        
        print("Editing room at index \(roomIndex): \(roomsList[roomIndex].name ?? "Unnamed")")
        
        if let beachData = beachData, var createBeachListing = createBeachListing {
            // Make sure we're passing the latest room data
            createBeachListing.rooms = roomsList
            self.createBeachListing = createBeachListing
            
            coordinator?.gotoListRoomsView(beachData: beachData, createBeachListingData: createBeachListing, room: roomIndex)
        }
    }

    
    func bindNetwork() {
        vm.output.subscribe(onNext: { [weak self] response in
            LoadingModal.dismiss()
            
            switch response {
            case .listBeachSuccessful(let response):
                print(response)
                MiddleModal.show(title: "Success!", subtitle: response.message ?? "", type: .success, onConfirm: { self?.coordinator?.gotoListingSuccessView(type: 2) })
            case .listBeachFailed(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
        }).disposed(by: disposeBag)
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
        
        if let bedTypes = item.bedTypes {
            view.model.numberOfBeds = bedTypes
                .compactMap { Int($0.quantity?.intValue ?? 0) }
                .reduce(0, +)
        } else {
            view.model.numberOfBeds = 0
        }
        view.model.numberOfGuests = item.noOfOccupant ?? 0
        view.model.numberOfRooms = item.quantity ?? 0
        view.model.roomName = item.name ?? ""
        view.model.roomPrice = "₦ \(item.pricePerNight ?? 0)"
        view.model.deleteTapped = { [weak self] in
            self?.deleteItem(roomName: item.name ?? "")
        }
        view.model.editTapped = { [weak self] in
            self?.editItem(roomIndex: indexPath.item)
        }
        view.isUserInteractionEnabled = true
        cell.applyView(view: view)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthOfScreen: CGFloat = collectionView.bounds.width
//        let heightOfScreen = collectionView.bounds.height
        return CGSize(width: widthOfScreen, height: 175)
       
    }

    private func generateUniqueName(baseName: String, existingRooms: [Room]) -> String {
        let existingNames = Set(existingRooms.compactMap { $0.name })
        
        // If the base name with " Copy" doesn't exist, use it
        let firstCopyName = "\(baseName) Copy"
        if !existingNames.contains(firstCopyName) {
            return firstCopyName
        }
        
        // Otherwise, find the next available number
        var counter = 2
        while existingNames.contains("\(baseName) Copy \(counter)") {
            counter += 1
        }
        
        return "\(baseName) Copy \(counter)"
    }
    
}


extension RoomsListView {
    func loadSavedData() {
        guard let savedListing = AppStorage.beachListing else { return }
        
        // Load existing rooms
        roomsList = savedListing.rooms ?? []
        
        // Update UI
        nextBtn.isEnabled = !roomsList.isEmpty
        duplicateBtn.isHidden = roomsList.count > 1
        
        // Refresh collection view
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
            if let self = self {
                self.updateCollectionViewHeight(self.collectionView, self.collectionViewHeightConstraint)
            }
        }
    }
}

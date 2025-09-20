//
//  EditRoomsListView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 23/07/2025.
//

import UIKit
import RxSwift

class EditRoomsListView: BaseViewControllerPlain {
    
    var coordinator: HostingServiceMenuCoordinator?
    
    @IBOutlet weak var nextBtn: PrimaryButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var property: BeachHouseListing?
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    var id: String?
    var details: GetBeachData?
    
    var roomsList: [Room] = []
    
    var disposeBag = DisposeBag()
    var vm = EditBeachViewModel()
    
    enum ImageDisplayItem {
        case url(String)
        case localImage(UIImage)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Property"
        
        bindNetwork()
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
        
        if roomsList.isEmpty {
            coordinator?.popToBoatOptionsScreen()
            Toast.show(message: "No rooms available")
        }

    }
    
    func updateCollectionViewHeight(_ CollectionView: UICollectionView, _ CollectionViewHeightConstraint: NSLayoutConstraint) {
        CollectionView.layoutIfNeeded()
        let contentHeight = CollectionView.contentSize.height
        CollectionViewHeightConstraint.constant = contentHeight
        
        self.view.layoutIfNeeded()
    }
    

    @IBAction func nextTapped(_ sender: Any) {
        guard let id = id else { return }
        if let createBeachListing = createBeachListing{
            self.createBeachListing = createBeachListing
            print(createBeachListing)
            
            LoadingModal.show(title: "Updating Record...")
            vm.editBeach(createBeachListing, id: id )

        }
    }

    
    func bindNetwork(){
        vm.output.subscribe(onNext: {[weak self] response in
            LoadingModal.dismiss()
            
            switch response {
            case .editBeachSuccessful(let response):
                print(response)
                MiddleModal.show(title: response.message ?? "", type: .success, onConfirm: { self?.coordinator?.pop() })
                
            case .editBeachFailed(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
            
        }).disposed(by: disposeBag)
    }

    func deleteRoom(id: String) {
        LoadingModal.show()
        vm.deleteBeachRoom(id: id)

        // Listen to deleteOutput (already in bindNetwork)
        vm.deleteRoomOutput.subscribe(onNext: { [weak self] response in
            LoadingModal.dismiss()
            switch response {
            case .deleteBeachRoomSuccessful(let response):
                Toast.show(message: response.message ?? "")
                
                if let index = self?.roomsList.firstIndex(where: { $0.id == id }) {
                    self?.roomsList.remove(at: index)
                    self?.createBeachListing?.rooms = self?.roomsList
                    self?.collectionView.reloadData()
                }
                
            case .deleteBeachRoomFailed(let error):
                Toast.show(message: error.message ?? "")
            }
        }).disposed(by: disposeBag)
    }

    
    func editItem(roomName: String) {
        if roomsList.firstIndex(where: { $0.name == roomName }) != nil {
            if let beachData = beachData, var createBeachListing = createBeachListing {
                createBeachListing.rooms = roomsList
                coordinator?.gotoEditListRoomsView(beachData: beachData, request: createBeachListing, room: roomName, id: id, details: details)
            }
        }
    }


}

extension EditRoomsListView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roomsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell

        cell.isUserInteractionEnabled = true
        let view = RoomCard(frame: cell.bounds)
        view.identifier = "Rooms Cell " + indexPath.description
        let item = roomsList[indexPath.row]
        
        // Find the corresponding BeachRoom in details.rooms to get the image URL
        if let beachRoom = details?.rooms?.first(where: { $0.id == item.id }) {
            if let imageUrlString = beachRoom.images?.first?.url, let url = URL(string: imageUrlString) {
                // Use the URL from BeachRoom.images
                view.model.imageURL = url
                view.model.image = nil
            } else {
                // No image available
                view.model.image = nil
                view.model.imageURL = nil
            }
        } else if let mainImageData = item.images?.first {
            // Fallback to local image data if available
            view.model.image = UIImage(data: mainImageData)
            view.model.imageURL = nil
        } else {
            // No image available
            view.model.image = nil
            view.model.imageURL = nil
        }
        
        view.model.numberOfBeds = item.quantity ?? 0
        view.model.numberOfGuests = item.noOfOccupant ?? 0
        view.model.numberOfRooms = item.quantity ?? 0
        view.model.roomName = item.name ?? ""
        view.model.roomPrice = "₦ \(item.pricePerNight ?? 0)"
        view.model.deleteTapped = { [weak self] in
            guard let self = self, let id = item.id else { return }
            self.deleteRoom(id: id)
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
        return CGSize(width: widthOfScreen, height: 170)
    }
}

//extension EditRoomsListView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return roomsList.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
//
//        cell.isUserInteractionEnabled = true
//        let view = RoomCard(frame: cell.bounds)
//        view.identifier = "Rooms Cell " + indexPath.description
//        let item = roomsList[indexPath.row]
//        
//        // Handle both URL and local image data
//        if let mainImageData = item.images?.first {
//            // Local image data - convert to UIImage
//            view.model.image = UIImage(data: mainImageData)
//            view.model.imageURL = nil // Clear URL if we have local data
//        } else if let imageUrlString = item.images?.first, !imageUrlString.isEmpty {
//            // Remote URL string - convert to URL
//            view.model.imageURL = URL(string: imageUrlString)
//            view.model.image = nil // Clear local image if we have URL
//        } else {
//            // No image available
//            view.model.image = nil
//            view.model.imageURL = nil
//        }
//        
//        view.model.numberOfBeds = item.quantity ?? 0
//        view.model.numberOfGuests = item.noOfOccupant ?? 0
//        view.model.numberOfRooms = item.quantity ?? 0
//        view.model.roomName = item.name ?? ""
//        view.model.roomPrice = "₦ \(item.pricePerNight ?? 0)"
//        view.model.deleteTapped = { [weak self] in
//            guard let self = self else { return }
//            if let id = item.id {
//                self.deleteRoom(id: id)
//            }
//        }
//        view.model.editTapped = { [weak self] in
//            self?.editItem(roomName: item.name ?? "")
//        }
//        view.isUserInteractionEnabled = true
//        cell.applyView(view: view)
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        let widthOfScreen: CGFloat = collectionView.bounds.width
////        let heightOfScreen = collectionView.bounds.height
//        return CGSize(width: widthOfScreen, height: 170)
//       
//    }
//    
//}

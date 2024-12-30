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
        stepTwoProgress.setProgress(0.25, animated: true)
        stepTwoProgress.tintColor = .B_B
        
        roomsList = createBeachListing?.rooms ?? []
        
        collectionView.backgroundColor = UIColor.background.lighter(by: 17)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
    }

    @IBAction func nextTapped(_ sender: Any) {
        if let beachData = beachData{
            
            if var createBeachListing = createBeachListing{
                print(createBeachListing)
                
                coordinator?.gotoEntireApartmentPriceView(beachData: beachData, createBeachListingData: createBeachListing)
            }
            
        }
    }
    
    
    func deleteItem(roomName: String) {
        if let index = roomsList.firstIndex(where: { $0.name == roomName }) {
            roomsList.remove(at: index)
        }
    }
    
    func editItem(roomName: String){
        if let index = roomsList.firstIndex(where: {$0.name == roomName}) {
            if let beachData = beachData, let createBeachListing = createBeachListing{
                coordinator?.gotoListRoomsView(beachData: beachData, createBeachListingData: createBeachListing)
            }
        }
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
        
//        let itemId = item?. ?? ""
//        view.model = item
        if let mainImage = item.images?.first{
            view.model.image = UIImage(data: mainImage)
        }
        
        view.model.numberOfBeds = item.quantity
        view.model.numberOfGuests = item.noOfOccupant
        view.model.numberOfRooms = item.quantity
        view.model.roomName = item.name
        view.model.roomPrice = String(item.pricePerNight)
        view.model.deleteTapped = { [weak self] in
            self?.deleteItem(roomName: item.name)
        }
        view.model.editTapped = { [weak self] in
            self?.editItem(roomName: item.name)
        }
        view.isUserInteractionEnabled = false
        cell.applyView(view: view)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthOfScreen: CGFloat = collectionView.bounds.width
//        let heightOfScreen = collectionView.bounds.height
        return CGSize(width: widthOfScreen, height: 170)
       
    }
    
//    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as! DynamicCollectionViewCell
//        let view = SelectableCheckbox(frame: cell.bounds)
//        guard let item = amenitiesList?[indexPath.row] else { return }
//        
//        let itemId = item.amenityID
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

    
}

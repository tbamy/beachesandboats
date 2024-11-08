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
    
    var amenitiesList: [Amenity]?
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
        
        amenitiesList = beachData?.amenities.first{ $0.name == "Main"}?.amenities
        
        collectionView.backgroundColor = UIColor.background.lighter(by: 17)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
    }

    @IBAction func nextTapped(_ sender: Any) {
        if let beachData = beachData{
            var roomIndex = createBeachListing?.roominfo.last?.id ?? 10000
            print("Current room index is \(roomIndex)")
//            guard let beachData = beachData, let roomIndex = currentRoomIndex else { return }
            
            var updatedRoomInfo = createBeachListing?.roominfo ?? []
            if roomIndex < updatedRoomInfo.count {
                    // Append selected items to the amenities of the room at the specified index
                var existingRoom = updatedRoomInfo[roomIndex]
                let updatedRoom = RoomData(
                    id: existingRoom.id,
                    name: existingRoom.name,
                    description: existingRoom.description,
                    amenities: existingRoom.amenities + selectedItems, // Append new amenities
                    price_per_night: existingRoom.price_per_night,
                    discount: existingRoom.discount,
                    amount_to_earn: existingRoom.amount_to_earn,
                    room_images: existingRoom.room_images,
                    number_of_guests: existingRoom.number_of_guests,
                    number_of_rooms: existingRoom.number_of_rooms,
                    number_of_beds: existingRoom.number_of_beds
                )
                updatedRoomInfo[roomIndex] = updatedRoom
                        
                } else {
                    print("Error: Room at index \(roomIndex) does not exist in roominfo.")
                    return
                }
       
            let request = CreateBeachListingRequest(category_id: createBeachListing?.category_id ?? "", sub_cat_id: createBeachListing?.sub_cat_id ?? "", guest_booking_id: createBeachListing?.guest_booking_id ?? "", name: createBeachListing?.name ?? "", description: createBeachListing?.description ?? "", country: createBeachListing?.country ?? "", state: createBeachListing?.state ?? "", city: createBeachListing?.city ?? "", street_address: createBeachListing?.street_address ?? "", from_when: "", to_when: "", amenities: createBeachListing?.amenities ?? [], preferred_languages: createBeachListing?.preferred_languages ?? [], brief_introduction: createBeachListing?.brief_introduction ?? "", house_rules: createBeachListing?.house_rules ?? [], check_in_start: createBeachListing?.check_in_start ?? "", check_in_end: createBeachListing?.check_in_end ?? "", check_out_start: createBeachListing?.check_out_start ?? "", check_out_end: createBeachListing?.check_out_end ?? "", roominfo: updatedRoomInfo, full_apartment_cost: 0, full_apartment_discount: 0, full_apartment_amount_to_earn: 0)
//
            coordinator?.gotoRoomPriceView(beachData: beachData, createBeachListingData: request)
        }
    }
    

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
        
        let itemId = item?.amenityID ?? ""
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
        
        let itemId = item.amenityID
        
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

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
    
    var roomsList: [RoomData] = []
    
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
        
        roomsList = createBeachListing?.roominfo ?? []
        
        collectionView.backgroundColor = UIColor.background.lighter(by: 17)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
    }

    @IBAction func nextTapped(_ sender: Any) {
        if let beachData = beachData{
            
            let request = CreateBeachListingRequest(category_id: createBeachListing?.category_id ?? "", sub_cat_id: createBeachListing?.sub_cat_id ?? "", guest_booking_id: createBeachListing?.guest_booking_id ?? "", name: createBeachListing?.name ?? "", description: createBeachListing?.description ?? "", country: createBeachListing?.country ?? "", state: createBeachListing?.state ?? "", city: createBeachListing?.city ?? "", street_address: createBeachListing?.street_address ?? "", from_when: "", to_when: "", amenities: createBeachListing?.amenities ?? [], preferred_languages: createBeachListing?.preferred_languages ?? [], brief_introduction: createBeachListing?.brief_introduction ?? "", house_rules: createBeachListing?.house_rules ?? [], check_in_start: createBeachListing?.check_in_start ?? "", check_in_end: createBeachListing?.check_in_end ?? "", check_out_start: createBeachListing?.check_out_start ?? "", check_out_end: createBeachListing?.check_out_end ?? "", roominfo: createBeachListing?.roominfo ?? [], full_apartment_cost: 0, full_apartment_discount: 0, full_apartment_amount_to_earn: 0)
            
//            let request = CreateBeachListingRequest(categoryId: createBeachListing?.categoryId ?? "", subCatId: createBeachListing?.subCatId ?? "", guestBookingId: createBeachListing?.guestBookingId ?? "", name: createBeachListing?.name ?? "", description: createBeachListing?.description ?? "", country: createBeachListing?.country ?? "", state: createBeachListing?.state ?? "", city: createBeachListing?.city ?? "", streetAddress: createBeachListing?.streetAddress ?? "", fromWhen: "", toWhen: "", amenities: createBeachListing?.amenities ?? [], preferredLanguages: createBeachListing?.preferredLanguages ?? [], briefIntroduction: createBeachListing?.briefIntroduction ?? "", houseRules: createBeachListing?.houseRules ?? [], checkInStart: createBeachListing?.checkInStart ?? "", checkInEnd: createBeachListing?.checkInEnd ?? "", checkOutStart: createBeachListing?.checkOutStart ?? "", checkOutEnd: createBeachListing?.checkOutEnd ?? "", roomName: createBeachListing?.roomName ?? "", roomDescription: createBeachListing?.roomDescription ?? "", roomAmenities: selectedItems, pricePerNight: 0, roomDiscount: 0, amountToEarn: 0, roomImages: [], fullApartmentCost: 0, fullApartmentDiscount: 0, fullApartmentAmountToEarn: 0)
//            
            coordinator?.gotoEntireApartmentPriceView(beachData: beachData, createBeachListingData: request)
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
        if let mainImage = item.room_images.first{
            view.model.image = UIImage(data: mainImage)
        }
        
        view.model.numberOfBeds = item.number_of_beds
        view.model.numberOfGuests = item.number_of_guests
        view.model.numberOfRooms = item.number_of_rooms
        view.model.roomName = item.name
        view.model.roomPrice = String(item.price_per_night)
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

//
//  UploadImageView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 08/10/2024.
//

import UIKit
import PhotosUI

class UploadImageView: BaseViewControllerPlain {
    
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var uploadBtn: UploadImageField!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    
    var images: [UIImage] = []{
        didSet {
            collectionView.reloadData()
        }
    }
    
    var roomImages: [Data] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupDragAndDrop()
    }


    func setupCollectionView() {
        stepOneProgress.setProgress(1, animated: false)
        stepOneProgress.tintColor = .success
        stepTwoProgress.setProgress(0.55, animated: true)
        stepTwoProgress.tintColor = .B_B
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
    }
    
    func setupDragAndDrop() {
        uploadBtn.onImageDropped = { [weak self] image in
            self?.images.append(image)
            self?.collectionView.reloadData()
        }
        
        // Handle button click for image picker
        uploadBtn.onImageUpload = { [weak self] in
            self?.addImageButtonTapped(UIButton())  // Reuse the existing function
        }
    }

    
    @IBAction func nextTapped(_ sender: Any) {
        if let beachData = beachData{
            for image in images {
                if let imageData = image.pngData() {
                    roomImages.append(imageData)
                }
            }
            
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
                    amenities: existingRoom.amenities,
                    price_per_night: existingRoom.price_per_night,
                    discount: existingRoom.discount,
                    amount_to_earn: existingRoom.amount_to_earn,
                    room_images: roomImages,
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

            coordinator?.gotoRoomsListView(beachData: beachData, createBeachListingData: request)
        }
    }
            
    func deleteImage(image: UIImage) {
        if let index = images.firstIndex(where: { $0 == image }) {
            images.remove(at: index)
        }
    }
            

}


// MARK: - UICollectionViewDataSource
extension UploadImageView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
        
        // Clear the previous image
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let image = images[indexPath.item]
        let imageView = ImageView(frame: cell.bounds)
        imageView.model.title = "Image Title \(image)"
        if indexPath.item == 0{
            imageView.isFirstImage = true
        }else{
            imageView.isFirstImage = false
        }
        imageView.contentMode = .scaleAspectFill
//        imageView.image = image
        imageView.model.image = image
        imageView.model.deleteTapped = { [weak self] in
            self?.deleteImage(image: image)
        }
        
        
        cell.contentView.addSubview(imageView)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension UploadImageView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0{
            let widthOfView = collectionView.bounds.width
            let heightOfView = collectionView.bounds.height
            return CGSize(width: widthOfView, height: heightOfView)
        }else{
            let widthOfView = collectionView.bounds.width / 2
            let heightOfView = collectionView.bounds.height
            return CGSize(width: widthOfView - 5, height: heightOfView)
        }
    }
}

extension UploadImageView: UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self?.images.append(image)
                        self?.collectionView.reloadData()
                    }
                }
            }
        }
    }
    

    @IBAction func addImageButtonTapped(_ sender: UIButton) {
        var config = PHPickerConfiguration()
        config.filter = .images  // Only images
        config.selectionLimit = 0  // 0 means no limit (allows multiple selections)
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
        


    // UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            images.append(selectedImage)
            collectionView.reloadData()
        }
        picker.dismiss(animated: true, completion: nil)
    }
}


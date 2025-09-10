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
    var room: Int?
    
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
        
        if let index = room,
           index >= 0,
           let rooms = createBeachListing?.rooms {
            
            let room = rooms[index]
            
            roomImages = room.images ?? []
        }

        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        collectionView.reloadData()
        
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
        guard let beachData = beachData else { return }
        guard let createBeachListing = createBeachListing else { return }
        
        if images.count < 5 {
            Toast.show(message: "Please upload at least 5 images")
            return
        }

        // Convert images to data (clear roomImages first to avoid duplicates)
        roomImages.removeAll()
        for image in images {
            if let imageData = image.pngData() {
                roomImages.append(imageData)
            }
        }
        
        var updatedBeachListing = createBeachListing
        
        if createBeachListing.bookingType == "FULL" {
            updatedBeachListing.images = roomImages
        } else {
            
            // Determine which room index to update
            let roomIndex: Int
            if let editingRoomIndex = room, editingRoomIndex >= 0 {
                roomIndex = editingRoomIndex
            } else {
                roomIndex = (createBeachListing.rooms?.count ?? 1) - 1
            }
            
            print("Updating room images at index: \(roomIndex)")
            
            // Safely update the room images
            if roomIndex >= 0 && roomIndex < (updatedBeachListing.rooms?.count ?? 0) {
                // PRESERVE existing room data, only update images
                var existingRoom = updatedBeachListing.rooms![roomIndex]
                existingRoom.images = roomImages
                updatedBeachListing.rooms![roomIndex] = existingRoom
                
                print("PRESERVED - Name: \(existingRoom.name ?? "")")
                print("PRESERVED - Price: \(existingRoom.pricePerNight ?? 0)")
                print("PRESERVED - Amenities: \(existingRoom.roomAmenities?.count ?? 0)")
                print("UPDATED - Images count: \(roomImages.count)")
            } else {
                print("Error: Room at index \(roomIndex) does not exist in room info.")
                return
            }
        }

        // Update the main createBeachListing property
        self.createBeachListing = updatedBeachListing
        
        print("Updated CreateBeachListing with preserved data")
        
        // check if it's entire apartment
        if createBeachListing.bookingType == "FULL" {
            coordinator?.gotoEntireApartmentPriceView(beachData: beachData, createBeachListingData: updatedBeachListing)
            
            // Check if we're editing or creating
        }else if let room = room, room >= 0 {
            // We're editing, go back to rooms list
            coordinator?.popToRoomsListScreen()
        } else {
            // We're creating, continue to rooms list
            coordinator?.gotoRoomsListView(beachData: beachData, createBeachListingData: updatedBeachListing)
        }
    }

    @IBAction func saveAndExit(_ sender: Any) {
        guard let createBeachListing = createBeachListing else { return }
        
        // Convert images to data (clear roomImages first to avoid duplicates)
        roomImages.removeAll()
        for image in images {
            if let imageData = image.pngData() {
                roomImages.append(imageData)
            }
        }

        var updatedBeachListing = createBeachListing
        
        // Determine which room index to update
        let roomIndex: Int
        if let editingRoomIndex = room, editingRoomIndex >= 0 {
            roomIndex = editingRoomIndex
        } else {
            roomIndex = (createBeachListing.rooms?.count ?? 1) - 1
        }

        // Safely update the room images
        if roomIndex >= 0 && roomIndex < (updatedBeachListing.rooms?.count ?? 0) {
            var existingRoom = updatedBeachListing.rooms![roomIndex]
            existingRoom.images = roomImages
            updatedBeachListing.rooms![roomIndex] = existingRoom
        }
        
        AppStorage.beachListing = updatedBeachListing
        coordinator?.backToDashboard()
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


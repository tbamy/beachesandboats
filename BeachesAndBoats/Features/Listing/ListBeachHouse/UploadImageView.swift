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
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var uploadLabel: UILabel!
    
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
        
        if let listing = createBeachListing, listing.bookingType == "FULL" {
            titleLabel.text = "What does this property look like?"
            subtitleLabel.text = "Upload pictures of this property"
            uploadLabel.text = "Upload a minimum of 5 photos for this property"
        }
        
        if let index = room,
           index >= 0,
           let rooms = createBeachListing?.rooms {
            
            let room = rooms[index]
            
            roomImages = room.images ?? []
        }

        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        
        loadSavedData()
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
    
    @IBAction func addImageButtonTapped(_ sender: UIButton) {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 5 - images.count // Limit to remaining allowed images
        
        if config.selectionLimit <= 0 {
            Toast.show(message: "You can only have a maximum of 5 images")
            return
        }
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }

    @IBAction func nextTapped(_ sender: Any) {
        guard let beachData = beachData else { return }
        guard let createBeachListing = createBeachListing else { return }
        
        if images.count < 5 {
            Toast.show(message: "Please upload at least 5 images")
            return
        }
        
        var updatedBeachListing = createBeachListing
        
        if createBeachListing.bookingType == "FULL" {
            updatedBeachListing.images = roomImages
        } else {
            let roomIndex: Int
            if let editingRoomIndex = room, editingRoomIndex >= 0 {
                roomIndex = editingRoomIndex
            } else {
                roomIndex = (createBeachListing.rooms?.count ?? 1) - 1
            }
            
            print("Updating room images at index: \(roomIndex)")
            
            if roomIndex >= 0 && roomIndex < (updatedBeachListing.rooms?.count ?? 0) {
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
        
        self.createBeachListing = updatedBeachListing
        
        print("Updated CreateBeachListing with preserved data")
        
        if createBeachListing.bookingType == "FULL" {
            coordinator?.gotoEntireApartmentPriceView(beachData: beachData, createBeachListingData: updatedBeachListing)
        } else if let room = room, room >= 0 {
            coordinator?.popToRoomsListScreen()
        } else {
            coordinator?.gotoRoomsListView(beachData: beachData, createBeachListingData: updatedBeachListing)
        }
    }

    @IBAction func saveAndExit(_ sender: Any) {
        guard let createBeachListing = createBeachListing else { return }
        
        
        var updatedBeachListing = createBeachListing
        
        let roomIndex: Int
        if let editingRoomIndex = room, editingRoomIndex >= 0 {
            roomIndex = editingRoomIndex
        } else {
            roomIndex = (createBeachListing.rooms?.count ?? 1) - 1
        }
        
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

extension UploadImageView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            images.append(selectedImage)
            collectionView.reloadData()
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
}




extension UploadImageView {
    func loadSavedData() {
        guard let savedListing = AppStorage.beachListing else { return }
        
        // For full apartment booking, load main listing images
        if savedListing.bookingType == "FULL" {
            if let imageDataArray = savedListing.images {
                images.removeAll()
                for imageData in imageDataArray {
                    if let image = UIImage(data: imageData) {
                        images.append(image)
                    }
                }
                nextBtn.isEnabled = images.count >= 5
            }
        }
        // For room-specific booking, load room images
        else if let roomIndex = room, roomIndex >= 0, let rooms = savedListing.rooms, roomIndex < rooms.count {
            let roomData = rooms[roomIndex]
            
            if let imageDataArray = roomData.images {
                images.removeAll()
                for imageData in imageDataArray {
                    if let image = UIImage(data: imageData) {
                        images.append(image)
                    }
                }
                nextBtn.isEnabled = images.count >= 5
            }
        }
        
        // Refresh collection view
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

extension UploadImageView: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        var newImages: [UIImage] = []
        let group = DispatchGroup()
        
        for result in results {
            group.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage {
                    newImages.append(image)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            let (validated, hasInvalid) = ImageValidator.validateImages(newImages, allowCompression: true)

            if hasInvalid {
                Toast.show(message: "Some images exceed the 2MB limit and were not added")
            }

            if !validated.isEmpty {
                self.images.append(contentsOf: validated.map { $0.image })   // for UI
                self.roomImages.append(contentsOf: validated.map { $0.data }) // for backend
                self.collectionView.reloadData()
            }
        }

    }
}

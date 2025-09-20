//
//  EditHouseUploadImageView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 13/09/2025.
//

import UIKit
import PhotosUI
import RxSwift
import SDWebImage

class EditHouseUploadImageView: BaseViewControllerPlain {
    
    var coordinator: HostingServiceMenuCoordinator?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var uploadBtn: UploadImageField!
    
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    var room: Int?
    var isEntireHouse: Bool = false
    var id: String?
    var roomId: String?
    var currentImages: [String] = []
    
    var disposeBag = DisposeBag()
    var vm = EditBeachViewModel()
    var deleteVM = DeleteImageVM()

    // Separate arrays for display and submission
    var displayImages: [ImageDisplayItem] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    var newSelectedImages: [UIImage] = [] // Only new images selected by user
    var roomImages: [Data] = []
    
    // Enum to handle different image sources
    enum ImageDisplayItem {
        case url(String)
        case localImage(UIImage)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        bindNetwork()
        setupDragAndDrop()
        loadExistingImages()
    }

    func loadExistingImages() {
        displayImages = currentImages.map { ImageDisplayItem.url($0) }
    }

    func setupCollectionView() {
        var roomCount = 0
        if let rooms = createBeachListing?.rooms {
            roomCount = rooms.count
        }
        
        isEntireHouse = createBeachListing?.bookingType == "FULL" || roomCount < 1
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        collectionView.reloadData()
    }
    
    func setupDragAndDrop() {
        uploadBtn.onImageDropped = { [weak self] image in
            self?.addNewImages([image])
        }
        
        // Handle button click for image picker
        uploadBtn.onImageUpload = { [weak self] in
            self?.addImageButtonTapped(UIButton())
        }
    }
    
    func addNewImages(_ newImages: [UIImage]) {
        // Check if adding new images would exceed the 5-image limit
        let currentCount = displayImages.count
        let newTotalCount = currentCount + newImages.count
        
        if newTotalCount > 5 {
            Toast.show(message: "You can only have a maximum of 5 images")
            return
        }
        
        // Append new images to both arrays
        newSelectedImages.append(contentsOf: newImages)
        displayImages.append(contentsOf: newImages.map { ImageDisplayItem.localImage($0) })
        
        print("Added \(newImages.count) new images. Total images: \(displayImages.count)")
    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        guard let beachData = beachData else { return }
        guard let createBeachListing = createBeachListing else { return }
        guard let id = id else { return }
        
        // Check if we have new images or existing images
        let totalImagesCount = displayImages.count
        
        if totalImagesCount < 5 {
            Toast.show(message: "Please upload at least 5 images")
            return
        }

        // Only convert NEW images to data for submission
        roomImages.removeAll()
        for image in newSelectedImages {
            if let imageData = image.pngData() {
                roomImages.append(imageData)
            }
        }
        
        var updatedBeachListing = createBeachListing
        
        if isEntireHouse {
            // Only set images if we have new ones, otherwise send empty array
            updatedBeachListing.images = newSelectedImages.isEmpty ? [] : roomImages
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
                // PRESERVE existing room data, only update images if we have new ones
                var existingRoom = updatedBeachListing.rooms![roomIndex]
                
                // Only update images if new ones were selected
                if !newSelectedImages.isEmpty {
                    existingRoom.images = roomImages
                    print("UPDATED - Images count: \(roomImages.count)")
                } else {
                    // Keep existing images as empty array to indicate no change needed
                    existingRoom.images = []
                    print("PRESERVED - No new images, keeping existing")
                }
                
                updatedBeachListing.rooms![roomIndex] = existingRoom
                
                print("PRESERVED - Name: \(existingRoom.name ?? "")")
                print("PRESERVED - Price: \(existingRoom.pricePerNight ?? 0)")
                print("PRESERVED - Amenities: \(existingRoom.roomAmenities?.count ?? 0)")
            } else {
                print("Error: Room at index \(roomIndex) does not exist in room info.")
                return
            }
        }

        // Update the main createBeachListing property
        self.createBeachListing = updatedBeachListing
        
        print("Updated CreateBeachListing")
        print("New images to submit: \(roomImages.count)")
        
        // Check if it's entire apartment
        if isEntireHouse {
            LoadingModal.show(title: "Updating Record...")
            vm.editBeach(createBeachListing, id: id)
        } else {
            // We're editing, go back to rooms list
            coordinator?.popToRoomsListScreen()
        }
    }
            
    func deleteImage(at index: Int) {
        guard index < displayImages.count else { return }
        
        let imageItem = displayImages[index]
        
        // Remove from display
        displayImages.remove(at: index)
        
        // If it's a local image, also remove from newSelectedImages
        if case .localImage(let image) = imageItem {
            if let localIndex = newSelectedImages.firstIndex(of: image) {
                newSelectedImages.remove(at: localIndex)
            }
        }
    }
    
    func bindNetwork(){
        vm.output.subscribe(onNext: {[weak self] response in
            LoadingModal.dismiss()
            
            switch response {
            case .editBeachSuccessful(let response):
                print(response)
                MiddleModal.show(title: response.message ?? "", type: .success, onConfirm: {
                    self?.coordinator?.popToRoomsListScreen()
                })
                
            case .editBeachFailed(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
            
        }).disposed(by: disposeBag)
        
        deleteVM.output.subscribe(onNext: {[weak self] response in
            LoadingModal.dismiss()
            
            switch response {
            case .deleteImageSuccessful(let response):
                print(response)
                // Find and remove the deleted image URL from displayImages
                if let urlToDelete = self?.deleteVM.lastDeletedImageUrl {
                    self?.displayImages.removeAll { item in
                        if case .url(let url) = item, url == urlToDelete {
                            return true
                        }
                        return false
                    }
                }
                Toast.show(message: response.message ?? "Image deleted successfully")
                
            case .deleteImageFailed(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
        }).disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDataSource
extension EditHouseUploadImageView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
        
        // Clear the previous image
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let imageItem = displayImages[indexPath.item]
        let imageView = ImageView(frame: cell.bounds)
        imageView.model.title = "Image \(indexPath.item + 1)"
        imageView.isFirstImage = indexPath.item == 0
        imageView.contentMode = .scaleAspectFill
        
        // Handle different image sources
        switch imageItem {
            case .url(let urlString):
                // Set URL in model for async loading inside ImageView
                if let url = URL(string: urlString) {
                    imageView.model.url = url
                    imageView.model.image = nil  // Clear any prior local image
                }
            case .localImage(let image):
                // Display local image
                imageView.model.image = image
                imageView.model.url = nil  // Clear any prior URL
        }
            
        
        // Handle deletion
        imageView.model.deleteTapped = { [weak self] in
            guard let self = self else { return }
            switch imageItem {
            case .url(let urlString):
                // Set URL in model for async loading inside ImageView
//                if let url = urlString {
                    let type = self.isEntireHouse ? "beach" : "room"
                    let deleteRequest = DeleteImagesRequest(property_type: type, property_id: self.roomId ?? "", images: [urlString])
                    // Store the URL being deleted for reference in the response handler
                    self.deleteVM.lastDeletedImageUrl = urlString
                    MiddleModal.show(title: "Are you sure?", subtitle: "Are you sure you want to permanently delete this image from your listing? This action cannot be undone.", type: .caution, primaryText: "Delete", secondaryText: "Cancel", onConfirm: {
                        LoadingModal.show()
                        self.deleteVM.deleteImage(request: deleteRequest)
                    })
//                }
            case .localImage(let image):
                self.deleteImage(at: indexPath.item)
            }
        }
        
        cell.contentView.addSubview(imageView)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension EditHouseUploadImageView: UICollectionViewDelegateFlowLayout {
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

extension EditHouseUploadImageView: UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
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
            // Append new images instead of replacing
            self.addNewImages(newImages)
        }
    }

    @IBAction func addImageButtonTapped(_ sender: UIButton) {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 5 - displayImages.count // Limit selection to remaining allowed images
        if config.selectionLimit <= 0 {
            Toast.show(message: "You can only have a maximum of 5 images")
            return
        }
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }

    // UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            // Append single new image
            self.addNewImages([selectedImage])
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

//import UIKit
//import PhotosUI
//import RxSwift
//import SDWebImage
//
//class EditHouseUploadImageView: BaseViewControllerPlain {
//    
//    var coordinator: HostingServiceMenuCoordinator?
//    
//    @IBOutlet weak var collectionView: UICollectionView!
//    @IBOutlet weak var uploadBtn: UploadImageField!
//    
//    var beachData: BeachDatas?
//    var createBeachListing: CreateBeachListingRequest?
//    var room: Int?
//    var isEntireHouse: Bool = false
//    var id: String?
//    var currentImages: [String] = []
//    
//    var disposeBag = DisposeBag()
//    var vm = EditBeachViewModel()
//    var deleteVM = DeleteImageVM()
//
//    // Separate arrays for display and submission
//    var displayImages: [ImageDisplayItem] = [] {
//        didSet {
//            collectionView.reloadData()
//        }
//    }
//    var newSelectedImages: [UIImage] = [] // Only new images selected by user
//    var roomImages: [Data] = []
//    
//    // Enum to handle different image sources
//    enum ImageDisplayItem {
//        case url(String)
//        case localImage(UIImage)
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupCollectionView()
//        bindNetwork()
//        setupDragAndDrop()
//        loadExistingImages()
//    }
//
//    func loadExistingImages() {
//        displayImages = currentImages.map { ImageDisplayItem.url($0) }
////        // Load existing images from the room or entire house
////        if isEntireHouse {
////            // Load entire house images from URLs
//////            if let imageUrls = currentImages {
////            displayImages = currentImages.map { ImageDisplayItem.url($0) }
//////            }
////        } else {
////            // Load room-specific images from URLs
////            if let roomIndex = room,
////               roomIndex >= 0,
////               let rooms = createBeachListing?.rooms,
////               roomIndex < rooms.count {
////                let roomData = rooms[roomIndex]
////                if let imageUrls = roomData.images {
////                    displayImages = imageUrls.map { ImageDisplayItem.url($0) }
////                }
////            }
////        }
//    }
//
//    func setupCollectionView() {
//        isEntireHouse = createBeachListing?.bookingType == "FULL"
//        
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
//        collectionView.reloadData()
//    }
//    
//    func setupDragAndDrop() {
//        uploadBtn.onImageDropped = { [weak self] image in
//            self?.replaceWithNewImages([image])
//        }
//        
//        // Handle button click for image picker
//        uploadBtn.onImageUpload = { [weak self] in
//            self?.addImageButtonTapped(UIButton())
//        }
//    }
//    
//    func replaceWithNewImages(_ newImages: [UIImage]) {
//        // Clear existing display and replace with new images
//        newSelectedImages = newImages
//        displayImages = newImages.map { ImageDisplayItem.localImage($0) }
//        
//        print("Replaced with \(newImages.count) new images")
//    }
//    
//    @IBAction func saveAndExit(_ sender: Any) {
//        guard let beachData = beachData else { return }
//        guard let createBeachListing = createBeachListing else { return }
//        guard let id = id else { return }
//        
//        // Check if we have new images or existing images
//        let totalImagesCount = displayImages.count
//        
//        if totalImagesCount < 5 {
//            Toast.show(message: "Please upload at least 5 images")
//            return
//        }
//
//        // Only convert NEW images to data for submission
//        roomImages.removeAll()
//        for image in newSelectedImages {
//            if let imageData = image.pngData() {
//                roomImages.append(imageData)
//            }
//        }
//        
//        var updatedBeachListing = createBeachListing
//        
//        if isEntireHouse {
//            // Only set images if we have new ones, otherwise send empty array or nil
//            updatedBeachListing.images = newSelectedImages.isEmpty ? [] : roomImages
//        } else {
//            // Determine which room index to update
//            let roomIndex: Int
//            if let editingRoomIndex = room, editingRoomIndex >= 0 {
//                roomIndex = editingRoomIndex
//            } else {
//                roomIndex = (createBeachListing.rooms?.count ?? 1) - 1
//            }
//            
//            print("Updating room images at index: \(roomIndex)")
//            
//            // Safely update the room images
//            if roomIndex >= 0 && roomIndex < (updatedBeachListing.rooms?.count ?? 0) {
//                // PRESERVE existing room data, only update images if we have new ones
//                var existingRoom = updatedBeachListing.rooms![roomIndex]
//                
//                // Only update images if new ones were selected
//                if !newSelectedImages.isEmpty {
//                    existingRoom.images = roomImages
//                    print("UPDATED - Images count: \(roomImages.count)")
//                } else {
//                    // Keep existing images as empty array to indicate no change needed
//                    existingRoom.images = []
//                    print("PRESERVED - No new images, keeping existing")
//                }
//                
//                updatedBeachListing.rooms![roomIndex] = existingRoom
//                
//                print("PRESERVED - Name: \(existingRoom.name ?? "")")
//                print("PRESERVED - Price: \(existingRoom.pricePerNight ?? 0)")
//                print("PRESERVED - Amenities: \(existingRoom.roomAmenities?.count ?? 0)")
//            } else {
//                print("Error: Room at index \(roomIndex) does not exist in room info.")
//                return
//            }
//        }
//
//        // Update the main createBeachListing property
//        self.createBeachListing = updatedBeachListing
//        
//        print("Updated CreateBeachListing")
//        print("New images to submit: \(roomImages.count)")
//        
//        // Check if it's entire apartment
//        if isEntireHouse {
//            LoadingModal.show(title: "Updating Record...")
//            vm.editBeach(createBeachListing, id: id)
//        } else if let room = room, room >= 0 {
//            // We're editing, go back to rooms list
//            coordinator?.popToRoomsListScreen()
//        }
//    }
//            
//    func deleteImage(at index: Int) {
//        guard index < displayImages.count else { return }
//        
//        let imageItem = displayImages[index]
//        
//        // Remove from display
//        displayImages.remove(at: index)
//        
//        // If it's a local image, also remove from newSelectedImages
//        if case .localImage(let image) = imageItem {
//            if let localIndex = newSelectedImages.firstIndex(of: image) {
//                newSelectedImages.remove(at: localIndex)
//            }
//        }
//    }
//    
//    func bindNetwork(){
//        vm.output.subscribe(onNext: {[weak self] response in
//            LoadingModal.dismiss()
//            
//            switch response {
//            case .editBeachSuccessful(let response):
//                print(response)
//                MiddleModal.show(title: response.message ?? "", type: .success, onConfirm: {
//                    self?.coordinator?.popToRoomsListScreen()
//                })
//                
//            case .editBeachFailed(let error):
//                MiddleModal.show(title: error.message ?? "", type: .error)
//            }
//            
//        }).disposed(by: disposeBag)
//        
//        deleteVM.output.subscribe(onNext: {[weak self] response in
//            LoadingModal.dismiss()
//            
//            switch response {
//            case .deleteImageSuccessful(let response):
//                print(response)
//                MiddleModal.show(title: response.message ?? "", type: .success, onConfirm: {
//                    self?.coordinator?.popToRoomsListScreen()
//                })
//                
//            case .deleteImageFailed(let error):
//                MiddleModal.show(title: error.message ?? "", type: .error)
//            }
//        }).disposed(by: disposeBag)
//    }
//}
//
//// MARK: - UICollectionViewDataSource
//extension EditHouseUploadImageView: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return displayImages.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
//        
//        // Clear the previous image
//        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
//
//        let imageItem = displayImages[indexPath.item]
//        let imageView = ImageView(frame: cell.bounds)
//        imageView.model.title = "Image \(indexPath.item + 1)"
//        imageView.isFirstImage = indexPath.item == 0
//        imageView.contentMode = .scaleAspectFill
//        
//        // Handle different image sources
//        switch imageItem {
//            case .url(let urlString):
//                // Set URL in model for async loading inside ImageView
//                if let url = URL(string: urlString) {
//                    imageView.model.url = url
//                    imageView.model.image = nil  // Clear any prior local image
//                }
//            case .localImage(let image):
//                // Display local image
//                imageView.model.image = image
//                imageView.model.url = nil  // Clear any prior URL
//        }
//            
//        
//        // Handle deletion
//        imageView.model.deleteTapped = { [weak self] in
//            guard let self = self else { return }
//            switch imageItem {
//            case .url(let urlString):
//                // Set URL in model for async loading inside ImageView
//                if let url = URL(string: urlString) {
//                    let type = self.isEntireHouse ? "bean" : "room"
//                    let deleteRequest = DeleteImagesRequest(property_type: type, property_id: self.id ?? "", images: [urlString])
//                    MiddleModal.show(title: "Are you sure?", subtitle: "Are you sure you want to permanently delete this image from your listing? This action cannot be undone.", type: .caution, primaryText: "Delete", secondaryText: "Cancel", onConfirm: {
//                        LoadingModal.show()
//                        self.deleteVM.deleteImage(request: deleteRequest)
//                    })
//                }
//            case .localImage(let image):
//                self.deleteImage(at: indexPath.item)
//            }
//        }
//        
//        cell.contentView.addSubview(imageView)
//        return cell
//    }
//}
//
//// MARK: - UICollectionViewDelegateFlowLayout
//extension EditHouseUploadImageView: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if indexPath.item == 0{
//            let widthOfView = collectionView.bounds.width
//            let heightOfView = collectionView.bounds.height
//            return CGSize(width: widthOfView, height: heightOfView)
//        }else{
//            let widthOfView = collectionView.bounds.width / 2
//            let heightOfView = collectionView.bounds.height
//            return CGSize(width: widthOfView - 5, height: heightOfView)
//        }
//    }
//}
//
//extension EditHouseUploadImageView: UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        picker.dismiss(animated: true)
//        
//        var newImages: [UIImage] = []
//        let group = DispatchGroup()
//        
//        for result in results {
//            group.enter()
//            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
//                if let image = object as? UIImage {
//                    newImages.append(image)
//                }
//                group.leave()
//            }
//        }
//        
//        group.notify(queue: .main) {
//            // Replace all existing images with new selection
//            self.replaceWithNewImages(newImages)
//        }
//    }
//
//    @IBAction func addImageButtonTapped(_ sender: UIButton) {
//        var config = PHPickerConfiguration()
//        config.filter = .images
//        config.selectionLimit = 0 // Allow multiple selections
//        
//        let picker = PHPickerViewController(configuration: config)
//        picker.delegate = self
//        present(picker, animated: true)
//    }
//
//    // UIImagePickerControllerDelegate
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let selectedImage = info[.originalImage] as? UIImage {
//            // Replace with single new image
//            replaceWithNewImages([selectedImage])
//        }
//        picker.dismiss(animated: true, completion: nil)
//    }
//}


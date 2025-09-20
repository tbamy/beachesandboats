//
//  EditBoatUploadImageView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/09/2025.
//

import UIKit
import PhotosUI
import RxSwift
import SDWebImage

class EditBoatUploadImageView: BaseViewControllerPlain {
    
    var coordinator: HostingServiceMenuCoordinator?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var uploadBtn: UploadImageField!
    @IBOutlet weak var nextBtn: PrimaryButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    var disposeBag = DisposeBag()
    var vm = ListBoatViewModel()
    var deleteVM = DeleteImageVM()
    var id: String?
    var details: GetBoatData?
    
    var boatData: BoatDatas?
    var createBoatListing: CreateBoatListingRequest?
    var boatType: String?
    
    // Separate arrays for display and submission
    var displayImages: [ImageDisplayItem] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    var newSelectedImages: [UIImage] = [] // Only new images selected by user
    var boatImages: [Data] = []
    
    // Enum to handle different image sources
    enum ImageDisplayItem {
        case url(String)
        case localImage(UIImage)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Boats"
        
        loadExistingImages()
        setupCollectionView()
        setupDragAndDrop()
        bindNetwork()
    }
    
    private func loadExistingImages() {
        // Load existing images from boatData URLs
        if let existingImageUrls = details?.images {
            let theImages = existingImageUrls.map({ $0.url ?? "" })
            displayImages = theImages.map { ImageDisplayItem.url($0) }
            print("Loaded \(existingImageUrls.count) existing images from URLs")
        }
        
        // Also check for any saved listing images (local)
        if let savedListing = createBoatListing,
           let savedImageData = savedListing.images {
            for imageData in savedImageData {
                if let image = UIImage(data: imageData) {
                    displayImages.append(.localImage(image))
                    newSelectedImages.append(image)
                }
            }
            print("Loaded \(savedImageData.count) saved local images")
        }
        
        print("Total display images: \(displayImages.count)")
    }

    func setupCollectionView() {
        titleLabel.text = "What does your \(boatType ?? "") look like?"
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
    }
    
    func updateCollectionViewHeight(_ collectionView: UICollectionView, _ collectionViewHeightConstraint: NSLayoutConstraint) {
        DispatchQueue.main.async {
            collectionView.layoutIfNeeded()
            let contentHeight = collectionView.contentSize.height
            collectionViewHeightConstraint.constant = contentHeight
            self.view.layoutIfNeeded()
        }
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

    func bindNetwork(){
        vm.output.subscribe(onNext: {[weak self] response in
            LoadingModal.dismiss()
            
            switch response {
            case .listBoatSuccessful(let response):
                print(response)
                MiddleModal.show(title: "Success!", subtitle: response.message ?? "", type: .success, onConfirm: { self?.coordinator?.popToBoatOptionsScreen() })
            case .listBoatFailed(let error):
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
    
    @IBAction func nextTapped(_ sender: Any) {
        guard let _ = boatData else { return }
        
        // Check total images (existing URLs + new local images)
        let totalImagesCount = displayImages.count
        
        if totalImagesCount < 5 {
            Toast.show(message: "Please upload at least 5 images")
            return
        }
        
        // Only convert NEW images to data for submission
        boatImages.removeAll()
        for image in newSelectedImages {
            if let imageData = image.pngData() {
                boatImages.append(imageData)
            }
        }
        
        if var createBoatListing = createBoatListing {
            // Only set images if we have new ones, otherwise send empty array
            createBoatListing.images = newSelectedImages.isEmpty ? [] : boatImages
            
            print("Submitting boat listing:")
            print("- New images to upload: \(boatImages.count)")
            print("- Total images displayed: \(totalImagesCount)")
            
            print(createBoatListing)
            LoadingModal.show(title: "Updating...")
            vm.createBoat(createBoatListing)
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
}

// MARK: - UICollectionViewDataSource
extension EditBoatUploadImageView: UICollectionViewDataSource {
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
                imageView.model.image = nil
            }
        case .localImage(let image):
            // Display local image
            imageView.model.image = image
            imageView.model.url = nil
        }
            
        
        // Handle deletion
        imageView.model.deleteTapped = { [weak self] in
            switch imageItem {
            case .url(let urlString):
                // Set URL in model for async loading inside ImageView
                if let url = URL(string: urlString) {
                    let deleteRequest = DeleteImagesRequest(property_type: "boat", property_id: self?.id ?? "", images: [urlString])
                    // Store the URL being deleted for reference in the response handler
                    self?.deleteVM.lastDeletedImageUrl = urlString
                    MiddleModal.show(title: "Delete Image", subtitle: "Are you sure you want to delete this image?", type: .caution, primaryText: "Yes", secondaryText: "No", onConfirm: {
                        LoadingModal.show()
                        self?.deleteVM.deleteImage(request: deleteRequest)
                    })
                }
            case .localImage(let image):
                self?.deleteImage(at: indexPath.item)
            }
        }
        
        cell.contentView.addSubview(imageView)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension EditBoatUploadImageView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0{
            let widthOfView = collectionView.bounds.width
            let heightOfView = collectionView.bounds.height
            return CGSize(width: widthOfView, height: heightOfView)
        }else{
            let widthOfView = collectionView.bounds.width / 2
            let heightOfView = collectionView.bounds.height / 2
            return CGSize(width: widthOfView - 5, height: heightOfView)
        }
    }
}

extension EditBoatUploadImageView: UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
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
//class EditBoatUploadImageView: BaseViewControllerPlain {
//    
//    var coordinator: HostingServiceMenuCoordinator?
//    
//    @IBOutlet weak var collectionView: UICollectionView!
//    @IBOutlet weak var uploadBtn: UploadImageField!
//    @IBOutlet weak var nextBtn: PrimaryButton!
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var subtitleLabel: UILabel!
//    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
//    
//    var disposeBag = DisposeBag()
//    var vm = ListBoatViewModel()
//    var deleteVM = DeleteImageVM()
//    var id: String?
//    var details: GetBoatData?
//    
//    var boatData: BoatDatas?
//    var createBoatListing: CreateBoatListingRequest?
//    var boatType: String?
//    
//    // Separate arrays for display and submission
//    var displayImages: [ImageDisplayItem] = [] {
//        didSet {
//            collectionView.reloadData()
//        }
//    }
//    var newSelectedImages: [UIImage] = [] // Only new images selected by user
//    var boatImages: [Data] = []
//    
//    // Enum to handle different image sources
//    enum ImageDisplayItem {
//        case url(String)
//        case localImage(UIImage)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Boats"
//        
//        loadExistingImages()
//        setupCollectionView()
//        setupDragAndDrop()
//        bindNetwork()
//    }
//    
//    private func loadExistingImages() {
//        // Load existing images from boatData URLs
//        if let existingImageUrls = details?.images {
//            let theImages = existingImageUrls.map({ $0.url ?? "" })
//            displayImages = theImages.map { ImageDisplayItem.url($0) }
//            print("Loaded \(existingImageUrls.count) existing images from URLs")
//        }
//        
//        // Also check for any saved listing images (local)
//        if let savedListing = createBoatListing,
//           let savedImageData = savedListing.images {
//            for imageData in savedImageData {
//                if let image = UIImage(data: imageData) {
//                    displayImages.append(.localImage(image))
//                    newSelectedImages.append(image)
//                }
//            }
//            print("Loaded \(savedImageData.count) saved local images")
//        }
//        
//        print("Total display images: \(displayImages.count)")
//    }
//
//    func setupCollectionView() {
//        titleLabel.text = "What does your \(boatType ?? "") look like?"
//        
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
//    }
//    
//    func updateCollectionViewHeight(_ collectionView: UICollectionView, _ collectionViewHeightConstraint: NSLayoutConstraint) {
//        DispatchQueue.main.async {
//            collectionView.layoutIfNeeded()
//            let contentHeight = collectionView.contentSize.height
//            collectionViewHeightConstraint.constant = contentHeight
//            self.view.layoutIfNeeded()
//        }
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
//    func bindNetwork(){
//        vm.output.subscribe(onNext: {[weak self] response in
//            LoadingModal.dismiss()
//            
//            switch response {
//            case .listBoatSuccessful(let response):
//                print(response)
//                MiddleModal.show(title: "Success!", subtitle: response.message ?? "", type: .success, onConfirm: { self?.coordinator?.popToBoatOptionsScreen() })
//            case .listBoatFailed(let error):
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
//    
//    @IBAction func nextTapped(_ sender: Any) {
//        guard let _ = boatData else { return }
//        
//        // Check total images (existing URLs + new local images)
//        let totalImagesCount = displayImages.count
//        
//        if totalImagesCount < 5 {
//            Toast.show(message: "Please upload at least 5 images")
//            return
//        }
//        
//        // Only convert NEW images to data for submission
//        boatImages.removeAll()
//        for image in newSelectedImages {
//            if let imageData = image.pngData() {
//                boatImages.append(imageData)
//            }
//        }
//        
//        if var createBoatListing = createBoatListing {
//            // Only set images if we have new ones, otherwise send empty array
//            createBoatListing.images = newSelectedImages.isEmpty ? [] : boatImages
//            
//            print("Submitting boat listing:")
//            print("- New images to upload: \(boatImages.count)")
//            print("- Total images displayed: \(totalImagesCount)")
//            
//            print(createBoatListing)
//            LoadingModal.show(title: "Updating...")
//            vm.createBoat(createBoatListing)
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
//}
//
//// MARK: - UICollectionViewDataSource
//extension EditBoatUploadImageView: UICollectionViewDataSource {
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
//        case .url(let urlString):
//            // Set URL in model for async loading inside ImageView
//            if let url = URL(string: urlString) {
//                imageView.model.url = url
//                imageView.model.image = nil
//            }
//        case .localImage(let image):
//            // Display local image
//            imageView.model.image = image
//            imageView.model.url = nil
//        }
//            
//        
//        // Handle deletion
//        imageView.model.deleteTapped = { [weak self] in
//            switch imageItem {
//            case .url(let urlString):
//                // Set URL in model for async loading inside ImageView
//                if let url = URL(string: urlString) {
//                    let deleteRequest = DeleteImagesRequest(property_type: "boat", property_id: self?.id ?? "", images: [urlString])
//                    MiddleModal.show(title: "Delete Image", subtitle: "Are you sure you want to delete this image?", type: .caution, primaryText: "Yes", secondaryText: "No", onConfirm: {
//                        LoadingModal.show()
//                        self?.deleteVM.deleteImage(request: deleteRequest)
//                    })
//                }
//            case .localImage(let image):
//                self?.deleteImage(at: indexPath.item)
//            }
//            
//            
//        }
//        
//        cell.contentView.addSubview(imageView)
//        return cell
//    }
//}
//
//// MARK: - UICollectionViewDelegateFlowLayout
//extension EditBoatUploadImageView: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if indexPath.item == 0{
//            let widthOfView = collectionView.bounds.width
//            let heightOfView = collectionView.bounds.height
//            return CGSize(width: widthOfView, height: heightOfView)
//        }else{
//            let widthOfView = collectionView.bounds.width / 2
//            let heightOfView = collectionView.bounds.height / 2
//            return CGSize(width: widthOfView - 5, height: heightOfView)
//        }
//    }
//}
//
//extension EditBoatUploadImageView: UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
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

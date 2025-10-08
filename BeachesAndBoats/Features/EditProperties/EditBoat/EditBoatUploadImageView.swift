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

//struct ValidatedImage {
//    let image: UIImage
//    let data: Data
//}

class EditBoatUploadImageView: BaseViewControllerPlain {
    
    var coordinator: HostingServiceMenuCoordinator?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var uploadBtn: UploadImageField!
    @IBOutlet weak var nextBtn: PrimaryButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    var disposeBag = DisposeBag()
    var vm = EditBoatViewModel()
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
    
    var validatedImages: [ValidatedImage] = []
    
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
        let currentCount = displayImages.count
        let newTotalCount = currentCount + newImages.count
        if newTotalCount > 5 {
            Toast.show(message: "You can only have a maximum of 5 images")
            return
        }

        // ✅ Validate
        let (validImages, hasInvalidImages) = ImageValidator.validateImages(newImages, allowCompression: true)

        if hasInvalidImages {
            Toast.show(message: "Some images exceed the 2MB size limit and were not added")
        }

        if validImages.isEmpty { return }

        // ✅ Append to arrays
        validatedImages.append(contentsOf: validImages)
        displayImages.append(contentsOf: validImages.map { .localImage($0.image) })

        print("Added \(validImages.count) new images. Total images: \(displayImages.count)")
    }


    @IBAction func nextTapped(_ sender: Any) {
        guard let id = id else { return }
        
        let totalImagesCount = displayImages.count
        if totalImagesCount < 5 {
            Toast.show(message: "Please upload at least 5 images")
            return
        }

        // ✅ Already compressed and validated
        let boatImages = validatedImages.map { $0.data }

        if createBoatListing == nil {
            createBoatListing = CreateBoatListingRequest()
        }
            createBoatListing?.images = boatImages
        print(createBoatListing)
        
        if let createBoatListing = createBoatListing{
            LoadingModal.show(title: "Updating...")
            vm.editBoat(createBoatListing, id: id)
        }

    }

    func bindNetwork(){
        vm.output.subscribe(onNext: {[weak self] response in
            LoadingModal.dismiss()
            
            switch response {
            case .editBoatSuccessful(let response):
                print(response)
                MiddleModal.show(title: "Success!", subtitle: response.message ?? "", type: .success, onConfirm: { self?.coordinator?.popToBoatOptionsScreen() })
            case .editBoatFailed(let error):
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

            
    func deleteImage(at index: Int) {
        guard index < displayImages.count else { return }
        
        let imageItem = displayImages[index]
        
        // Remove from display
        displayImages.remove(at: index)
        
        // If it's a local image, also remove from newSelectedImages
        if case .localImage(let image) = imageItem {
            if let index = validatedImages.firstIndex(where: { $0.image == image }) {
                validatedImages.remove(at: index)
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
                    MiddleModal.show(title: "Are you sure?", subtitle: "Are you sure you want to permanently delete this image from your listing? This action cannot be undone.", type: .caution, primaryText: "Delete", secondaryText: "Cancel", onConfirm: {
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

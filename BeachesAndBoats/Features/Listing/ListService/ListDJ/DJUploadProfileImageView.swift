//
//  DJUploadImageView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/10/2024.
//

import UIKit
import PhotosUI

class DJUploadProfileImageView: BaseViewControllerPlain {
    
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
//    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var ImgView: ImageView!
    @IBOutlet weak var uploadBtn: UploadImageField!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var createServiceListing: CreateServiceListingRequest?
    
    var image: UIImage?{
        didSet {
            ImgView.model.image = image
            ImgView.isHidden = false
        }
    }
    
//    var roomImages: [Data] = []
    
    var profileImage: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupDragAndDrop()
    }


    func setupView() {
        stepOneProgress.setProgress(1, animated: false)
        stepOneProgress.tintColor = .success
        stepTwoProgress.setProgress(0.55, animated: true)
        stepTwoProgress.tintColor = .B_B
        
//        ImgView.model.image = image
        ImgView.isHidden = true
        
        ImgView.model.title = ""
        ImgView.coverTitle = "Profile"
        ImgView.isFirstImage = true
        ImgView.contentMode = .scaleAspectFill
        ImgView.model.image = image
        ImgView.model.deleteTapped = { [weak self] in
            self?.deleteImage()
        }
    }
    
    func setupDragAndDrop() {
        uploadBtn.onImageDropped = { [weak self] image in
//            self?.images.append(image)
//            self?.collectionView.reloadData()
            self?.image = image
        }
        
        // Handle button click for image picker
        uploadBtn.onImageUpload = { [weak self] in
            self?.addImageButtonTapped(UIButton())  // Reuse the existing function
        }
    }

    
    @IBAction func nextTapped(_ sender: Any) {
        if let imageData = image?.pngData() {
            profileImage = imageData
            
            let request = CreateServiceListingRequest(name: createServiceListing?.name ?? "", description: createServiceListing?.description ?? "", profile_image: profileImage ?? Data(), from_when: "", to_when: "", dishes: [], price: 0, sample_images: [], type: "", gender: "")
            
            coordinator?.gotoDJAvailableDatesView(createServiceListingData: request)
        }
        

    }
            
    func deleteImage() {
        image = nil
        ImgView.model.image = nil
        ImgView.isHidden = true
    }
            

}

extension DJUploadProfileImageView: UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    

    @IBAction func addImageButtonTapped(_ sender: UIButton) {
        var config = PHPickerConfiguration()
        config.filter = .images  // Only images
        config.selectionLimit = 1  // 0 means no limit (allows multiple selections)
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
        


    // UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}


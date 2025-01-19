//
//  BoatUploadImageView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/10/2024.
//

import UIKit
import PhotosUI
import RxSwift

class BoatUploadImageView: BaseViewControllerPlain {
    
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var uploadBtn: UploadImageField!
    @IBOutlet weak var nextBtn: PrimaryButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    var disposeBag = DisposeBag()
    var vm = ListBoatViewModel()
    
    var boatData: BoatDatas?
    var createBoatListing: CreateBoatListingRequest?
    var boatType: String?
    
    var images: [UIImage] = []{
        didSet {
            collectionView.reloadData()
        }
    }
    
    var boatImages: [Data] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Boats"
        setupCollectionView()
        setupDragAndDrop()
        
        bindNetwork()
    }


    func setupCollectionView() {
        stepOneProgress.setProgress(1, animated: false)
        stepOneProgress.tintColor = .success
        stepTwoProgress.setProgress(1, animated: true)
        stepTwoProgress.tintColor = .B_B
        
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
            self?.images.append(image)
            self?.collectionView.reloadData()
        }
        
        // Handle button click for image picker
        uploadBtn.onImageUpload = { [weak self] in
            self?.addImageButtonTapped(UIButton())  // Reuse the existing function
        }
    }

    func bindNetwork(){
        vm.output.subscribe(onNext: {[weak self] response in
            LoadingModal.dismiss()
            
            switch response {
            case .listBoatSuccessful(let response):
                print(response)
                self?.coordinator?.gotoListingSuccessView(type: 1)
            case .listBoatFailed(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
            
        }).disposed(by: disposeBag)
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        if let boatData = boatData{
            for image in images {
                if let imageData = image.pngData() {
                    boatImages.append(imageData)
                }
            }
            
            if var createBoatListing = createBoatListing{
                createBoatListing.images = boatImages
                print(createBoatListing)
                LoadingModal.show(title: "Hold on while we list your Boat")
                vm.createBoat(createBoatListing)
                
            }
            
        }
        
    }
    
    
    @IBAction func saveAndExit(_ sender: Any) {
        for image in images {
            if let imageData = image.pngData() {
                boatImages.append(imageData)
            }
        }
        
        if var createBoatListing = createBoatListing{
            createBoatListing.images = boatImages
            print(createBoatListing)
            
            AppStorage.boatListing = createBoatListing
            coordinator?.backToDashboard()
            
        }
        
        
    }
            
    func deleteImage(image: UIImage) {
        if let index = images.firstIndex(where: { $0 == image }) {
            images.remove(at: index)
        }
    }
            

}


// MARK: - UICollectionViewDataSource
extension BoatUploadImageView: UICollectionViewDataSource {
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
extension BoatUploadImageView: UICollectionViewDelegateFlowLayout {
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

extension BoatUploadImageView: UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
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
            updateCollectionViewHeight(collectionView, collectionViewHeight)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}


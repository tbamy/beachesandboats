//
//  DJUploadInstrumentsView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/10/2024.
//

import UIKit
import PhotosUI
import RxSwift

class DJUploadInstrumentsView: BaseViewControllerPlain {
    
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var uploadBtn: UploadImageField!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var createServiceListing: CreateServiceListingRequest?
    var disposeBag = DisposeBag()
    var vm = ListServiceViewModel()
    
    var images: [UIImage] = []{
        didSet {
            collectionView.reloadData()
        }
    }
    
    var djInstruments: [Data] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupDragAndDrop()
        
        bindNetwork()
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
    
    func bindNetwork(){
        vm.output.subscribe(onNext: {[weak self] response in
            LoadingModal.dismiss()
            
            switch response {
            case .listServiceSuccessful(let response):
                print(response)
                self?.coordinator?.gotoServiceListingSuccessView()
            case .listServiceFailed(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
            
        }).disposed(by: disposeBag)
    }

    
    @IBAction func nextTapped(_ sender: Any) {
        djInstruments.removeAll()
        for image in images {
            if let imageData = image.pngData() {
                djInstruments.append(imageData)
            }
        }
        
        let images = createServiceListing?.images ?? []
        if var createServiceListing = createServiceListing{
            createServiceListing.images = images + djInstruments
            
            print(createServiceListing)
            
            LoadingModal.show(title: "Hold on while we list your service")
            vm.createService(createServiceListing)
        }

    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        djInstruments.removeAll()
        for image in images {
            if let imageData = image.pngData() {
                djInstruments.append(imageData)
            }
        }
        
        let images = createServiceListing?.images ?? []
        if var createServiceListing = createServiceListing{
            createServiceListing.images = images + djInstruments
            
            AppStorage.serviceListing = createServiceListing
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
extension DJUploadInstrumentsView: UICollectionViewDataSource {
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
extension DJUploadInstrumentsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0{
            let widthOfView = collectionView.bounds.width
            let heightOfView = collectionView.bounds.height
            return CGSize(width: widthOfView, height: heightOfView)
        }else{
            let widthOfView = collectionView.bounds.width / 2
            let heightOfView = collectionView.bounds.height - (collectionView.bounds.height / 3)
            return CGSize(width: widthOfView - 5, height: heightOfView)
        }
    }
}

extension DJUploadInstrumentsView: UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
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


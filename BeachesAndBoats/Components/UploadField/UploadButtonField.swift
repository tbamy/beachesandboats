//
//  UploadButtonField.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 28/02/2025.
//

import UIKit
import MobileCoreServices
import PDFKit

class UploadButtonField: BaseXib {

    @IBInspectable public var identifier: String = "" { didSet {
        self.accessibilityIdentifier = identifier
    } }
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var error: RegularLabel!
    @IBOutlet weak var errorStack: UIStackView!
    
    public var isOnlyPdf = false
    
    @IBInspectable public var errorText: String = "" {
        didSet { updateError() }
    }
    
    @IBInspectable public var buttonText: String = "Select a document"
    
    public var onSelected: (Data, String) -> Void = { _, _ in }
    let Window = UIApplication.shared.windows.first
    var vc: UIViewController?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        vc = Window?.rootViewController
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        vc = Window?.rootViewController
    }

    @IBAction func uploadTapped(_ sender: Any) {
        selectFile()
    }
    
    public override func layoutSubviews() {
        setup()
    }
    
    func setup() {
        uploadButton.setTitle(buttonText, for: .normal)
        errorStack.isHidden = errorText.isEmpty
        updateHeight()
    }
    
    public override func prepareForInterfaceBuilder() {
        contentView.widthAnchor.constraint(equalToConstant: superview?.bounds.width ?? 100).isActive = true
        setNeedsLayout()
    }
    
//    public func reset() {
//        uploadImage.image = AlatAssets.uploadIcon.image
//        uploadImage.contentMode = .center
//    }
    
    func showFileAddedState() {
        uploadButton.setTitle("✓ File Added", for: .normal)
        uploadButton.setTitleColor(.systemGreen, for: .normal)
    }

    
    func updateError() {
        errorStack.isHidden = errorText.isEmpty
        error.text = errorText
    }
    
}

//MARK: Document Picker
extension UploadButtonField: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate {
    
    func selectFile() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let photoAction = UIAlertAction(title: "Select Image", style: .default) { [unowned self] _ in
            self.showImagePicker()
        }
        let pdfAction = UIAlertAction(title: "Select PDF", style: .default) { [unowned self] _ in
            self.showPDFPicker()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        if isOnlyPdf {
            actionSheet.addAction(pdfAction)
        } else {
            actionSheet.addAction(photoAction)
            actionSheet.addAction(pdfAction)
        }
        actionSheet.addAction(cancelAction)
        vc?.present(actionSheet, animated: true, completion: nil)
    }
    
    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        vc?.present(imagePicker, animated: true, completion: nil)
    }
        
    // MARK: - Image Picker Delegate
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        let imageData = selectedImage?.jpegData(compressionQuality: 1.0)
        let base64String = imageData?.base64EncodedString()
        
        if let imageData = imageData {
            let fileSize = Double(imageData.count) / 1000000.0
            if fileSize <= 1.0 {
                onSelected(imageData, ".jpg")
                showFileAddedState()
            } else {
                errorText = "Image should not be more than 1mb"
                updateError()
//                MiddleModal.show(title: "Image should not be more than 1mb", type: .caution)
            }
        }

        picker.dismiss(animated: true, completion: nil)
    }

    func showPDFPicker() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypePDF as String], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        vc?.present(documentPicker, animated: true, completion: nil)
    }
    
    // MARK: - Document Picker Delegate
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let pdfURL = urls.first {
            if let pdfDocument = PDFDocument(url: pdfURL) {
                let pdfData = pdfDocument.dataRepresentation()
                let base64String = pdfData?.base64EncodedString()
                if let pdfData = pdfData {
                    let fileSize = Double(pdfData.count) / 1000000.0
                    if fileSize <= 1.0 {
                        setPdfImage(pdfDocument: pdfDocument)
                        onSelected(pdfData, ".pdf")
                        showFileAddedState()
                    } else {
                        errorText = "File should not be more than 1mb"
                        updateError()
//                        MiddleModal.show(title: "Image should not be more than 1mb", type: .caution)
                    }
                }

            }
        }
    }
    
    func setPdfImage(pdfDocument: PDFDocument) {
        let pdfPage = pdfDocument.page(at: 0)
        let pageSize = pdfPage?.bounds(for: .cropBox).size

        UIGraphicsBeginImageContextWithOptions(pageSize!, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.translateBy(x: 0.0, y: -pageSize!.height)
        
        pdfPage?.draw(with: .cropBox, to: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}

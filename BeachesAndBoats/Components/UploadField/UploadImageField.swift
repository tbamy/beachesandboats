//
//  UploadImageField.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 08/10/2024.
//

import UIKit
import UniformTypeIdentifiers

@IBDesignable public class UploadImageField: BaseXib {

    let nibName = "UploadImageField"
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var uploadBtn: UIButton!

    var onImageDropped: ((UIImage) -> Void)?
    var onImageUpload: (() -> Void)?


    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func getNibName() -> String? {
        return nibName
    }
    
    func setup(){
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = UIColor.background.cgColor
        
        let dropInteraction = UIDropInteraction(delegate: self)
        self.addInteraction(dropInteraction)
        self.isUserInteractionEnabled = true
        
        uploadBtn.addTarget(self, action: #selector(uploadBtnTapped), for: .touchUpInside)
    }
    
    @objc func uploadBtnTapped() {
        onImageUpload?()
    }

}

extension UploadImageField: UIDropInteractionDelegate{
    public func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.hasItemsConforming(toTypeIdentifiers: [UTType.image.identifier])
    }

    public func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    public func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: UIImage.self) { [weak self] items in
            if let images = items as? [UIImage], let image = images.first {
                self?.onImageDropped?(image)
                print("Image dropped: \(image)")
            } else {
                print("No image detected.")
            }
        }
    }

            
}

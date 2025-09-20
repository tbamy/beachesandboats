//
//  RoomCard.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 09/10/2024.
//

import UIKit
import SDWebImage

class RoomCard: BaseXib {
    
    let nibName = "RoomCard"

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var roomName: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var guestsNum: UILabel!
    @IBOutlet weak var roomsNum: UILabel!
    @IBOutlet weak var bedsNum: UILabel!
    @IBOutlet weak var roomPrice: UILabel!
    
    @IBInspectable public var identifier: String = "" { didSet {
        self.accessibilityIdentifier = identifier
    } }
    
    public var model: RoomCardModel = RoomCardModel() {
        didSet {
            setup()
        }
    }
    
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
        layer.cornerRadius = 8
        mainImage.layer.cornerRadius = 10
        backgroundColor = .white
        
//        mainImage.image = model.image
        if let imgData = model.image {
            // Local image: Assign directly
            mainImage.image = imgData
        } else if let url = model.imageURL {
            // Remote URL: Load with SDWebImage
            let placeholder = UIImage(named: "placeholder")  // Ensure this asset exists
            mainImage.sd_setImage(with: url, placeholderImage: placeholder) { [weak self] loadedImage, error, _, _ in
                // Optional: Update model on success for consistency
                if let strongSelf = self, error == nil, let loadedImage = loadedImage {
                    strongSelf.model.image = loadedImage
                }
            }
        } else {
            // No image or URL: Clear it
            mainImage.image = nil
        }
        
        roomName.text = model.roomName
        guestsNum.text = "\(model.numberOfGuests)"
        roomsNum.text = "\(model.numberOfRooms)"
        bedsNum.text = "\(model.numberOfBeds)"
        roomPrice.text = model.roomPrice
        
//        editBtn.isHidden = true
        editBtn.configureButtonTitle(title: "Edit", fontSize: 12, underline: false)
        deleteBtn.configureButtonTitle(title: "", fontSize: 12, underline: false)
        deleteBtn.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteBtn.setTitle("", for: .normal)
        deleteBtn.setTitleColor(.red, for: .normal)
        deleteBtn.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        editBtn.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
        
    }
    
    @objc func deleteTapped() {
        model.deleteTapped()
    }
    
    @objc func editTapped() {
        model.editTapped()
    }

}

public struct RoomCardModel{
    public var roomName: String = ""
    public var numberOfGuests: Int = 0
    public var numberOfRooms: Int = 0
    public var numberOfBeds: Int = 0
    public var roomPrice: String = ""
    public var image: UIImage? = nil
    public var imageURL: URL? = nil
    public var editTapped: () -> Void = {}
    public var deleteTapped: () -> Void = {}
}

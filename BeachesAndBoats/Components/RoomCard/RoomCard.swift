//
//  RoomCard.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 09/10/2024.
//

import UIKit

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
        backgroundColor = .white
        
        mainImage.image = model.image
        roomName.text = model.roomName
        guestsNum.text = model.numberOfGuests
        roomsNum.text = model.numberOfRooms
        bedsNum.text = model.numberOfBeds
        roomPrice.text = model.roomPrice
        
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
    public var numberOfGuests: String = ""
    public var numberOfRooms: String = ""
    public var numberOfBeds: String = ""
    public var roomPrice: String = ""
    public var image: UIImage? = nil
    public var editTapped: () -> Void = {}
    public var deleteTapped: () -> Void = {}
}

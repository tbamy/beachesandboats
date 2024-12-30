//
//  BookingRoomCell.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 28/12/2024.
//

import UIKit

class BookingRoomCell: BaseXib {

    let nibName = "BookingRoomCell"
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var guestsLabel: UILabel!
    @IBOutlet weak var bedTypeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var selectBtn: PlainOutlineButton!
    @IBOutlet weak var selectedBtn: PlainOutlineButton!
    @IBOutlet weak var amenitiesCollectionView: UICollectionView!
    
    @IBInspectable public var identifier: String = "" { didSet {
        self.accessibilityIdentifier = identifier
    } }
    
    private var amenities: [Amenity] = []
    
//    public var img: String = ""{
//        didSet{
//            setup()
//        }
//    }
    
    public override init(frame: CGRect) {
        super .init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super .init(coder: coder)
        setup()
    }
    
    public var model: BookingRoomCellModel = BookingRoomCellModel(){
        didSet {
            setup()
        }
        
    }
    
    @IBInspectable var state: Bool = false {
        didSet { model.state = state }
    }
    
    func setup(){
        selectedBtn.isHidden = true
        selectBtn.layer.borderColor = UIColor.grey.cgColor
        selectBtn.tintColor = .beachBlue
        selectedBtn.layer.borderColor = UIColor.beachBlue.cgColor
        selectedBtn.tintColor = .beachBlue
        guestsLabel.text =  model.guests
        bedTypeLabel.text = model.bedType
        dateLabel.text = model.date
        priceLabel.text = model.price
        amenities = model.amenities
        
        amenitiesCollectionView.delegate = self
        amenitiesCollectionView.dataSource = self
        amenitiesCollectionView.backgroundColor = .clear
        amenitiesCollectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")

        
        if let url = URL(string: model.img.replacingOccurrences(of: "http://", with: "https://")) {
            image.kf.setImage(with: url)
        }
        
        setState()
    }
    
    @objc func onTapped(_ sender: UITapGestureRecognizer) {
        model.tapped()
        model.state = true
    }
    
    func setState() {
        if model.state {
            image.layer.borderColor = UIColor.beachBlue.cgColor
            image.layer.borderWidth = 2
            selectBtn.isHidden = true
            selectedBtn.isHidden = false
            
        } else {
            image.layer.borderColor = UIColor.clear.cgColor
            image.layer.borderWidth = 0
            selectBtn.isHidden = false
            selectedBtn.isHidden = true
        }
    }
    
}


extension BookingRoomCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return amenities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = amenitiesCollectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
        let cellAt = amenities[indexPath.item]
        
        let view = CategoriesCell(frame: cell.bounds)
        view.identifier = "Amenitiess " + indexPath.description
        view.model.image = cellAt.icon ?? ""
        view.model.title = cellAt.name ?? ""
        view.isSubcategory = true
        
        cell.applyView(view: view)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width / 6), height: 50)
    }
    
    
}


struct BookingRoomCellModel{
    public var img: String = ""
    public var title: String = ""
    public var guests: String = ""
    public var bedType: String = ""
    public var date: String = ""
    public var price: String = ""
    public var amenities: [Amenity] = []
    public var state: Bool = false
    public var tapped: () -> Void = {}
}

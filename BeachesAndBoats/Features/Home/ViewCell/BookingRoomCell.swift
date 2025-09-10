//
//  BookingRoomCell.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 28/12/2024.
//

//import UIKit
//import SDWebImage
//import SDWebImageSVGCoder
//
//class BookingRoomCell: BaseXib{
//
//    let nibName = "BookingRoomCell"
//    
//    @IBOutlet weak var cellView: UIView!
//    @IBOutlet weak var image: UIImageView!
//    @IBOutlet weak var guestsLabel: UILabel!
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var bedTypeLabel: UILabel!
//    @IBOutlet weak var dateLabel: UILabel!
//    @IBOutlet weak var priceLabel: UILabel!
//    @IBOutlet weak var selectBtn: SecondaryButton!
//    @IBOutlet weak var selectedBtn: SecondaryButton!
//    @IBOutlet weak var amenitiesCollectionView: UICollectionView!
//    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
//    
//    @IBInspectable public var identifier: String = "" { didSet {
//        self.accessibilityIdentifier = identifier
//    } }
//    
//    private var amenities: [Amenity] = []
//    
//    public override init(frame: CGRect) {
//        super .init(frame: frame)
//        setup()
//    }
//    
//    public required init?(coder: NSCoder) {
//        super .init(coder: coder)
//        setup()
//    }
//    
//    public var model: BookingRoomCellModel = BookingRoomCellModel(){
//        didSet {
//            setup()
//            updateCollectionViewHeight()
//        }
//    }
//    
//    @IBInspectable var state: Bool = false {
//        didSet { model.state = state }
//    }
//    
//    func setup(){
//        setState()
//        cellView.layer.cornerRadius = 15
//        cellView.backgroundColor = .white
//        selectBtn.layer.borderColor = UIColor.grey.cgColor
//        selectBtn.tintColor = .beachBlue
//        selectedBtn.layer.borderColor = UIColor.beachBlue.cgColor
//        selectedBtn.tintColor = .beachBlue
//        selectedBtn.backgroundColor = .bBLight
//        guestsLabel.text =  model.guests
//        bedTypeLabel.text = model.bedType
//        dateLabel.text = model.date
//        priceLabel.text = model.price
//        
//        titleLabel.text = model.title
//        
//        if let layout = amenitiesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//            layout.minimumInteritemSpacing = 10
//            layout.minimumLineSpacing = 15
//        }
//                    
//        amenitiesCollectionView.delegate = self
//        amenitiesCollectionView.dataSource = self
//        amenitiesCollectionView.backgroundColor = .clear
//        amenitiesCollectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
//        amenities = model.amenities
//        
//        if let url = URL(string: model.img.replacingOccurrences(of: "http://", with: "https://")) {
//            image.sd_setImage(with: url, placeholderImage: UIImage(named: "dummy"))
//        }
//        
//        // Add target for both buttons
//        selectBtn.addTarget(self, action: #selector(onTapped), for: .touchUpInside)
//        selectedBtn.addTarget(self, action: #selector(onTapped), for: .touchUpInside)
//        
//        amenitiesCollectionView.reloadData()
//        updateCollectionViewHeight()
//    }
//    
//    func updateCollectionViewHeight() {
//        let layout = amenitiesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
//        let itemsPerRow = 4
//        let totalRows = Int(ceil(Double(amenities.count) / Double(itemsPerRow)))
//        let itemHeight: CGFloat = 20 // Match sizeForItemAt height
//        let height = CGFloat(totalRows) * itemHeight + CGFloat(max(0, totalRows - 1)) * 15 // Account for line spacing
//        collectionViewHeight.constant = height
//        layoutIfNeeded() // Force layout update
//    }
//    
//    @objc func onTapped(_ sender: UIButton) {
//        model.tapped() // This will trigger the quantity picker
//    }
//    
//    func setState() {
//        if model.state {
//            layer.borderColor = UIColor.beachBlue.cgColor
//            layer.borderWidth = 2
//            layer.cornerRadius = 8
//            selectBtn.isHidden = true
//            selectedBtn.isHidden = false
//            
//            // Update button title with selected quantity
//            let quantityText = model.selectedQuantity > 1 ? "\(model.selectedQuantity) Units" : "1 Unit"
//            selectedBtn.setTitle(quantityText, for: .normal)
//            selectedBtn.setTitleColor(.beachBlue, for: .normal)
//            
//        } else {
//            layer.borderColor = UIColor.clear.cgColor
//            layer.borderWidth = 0
//            selectBtn.isHidden = false
//            selectedBtn.isHidden = true
//            selectBtn.setTitle("Select", for: .normal)
//        }
//    }
//}
//
//extension BookingRoomCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return amenities.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = amenitiesCollectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
//        let cellAt = amenities[indexPath.item]
//        
//        let view = CatViewCell(frame: cell.bounds)
//        view.identifier = "Amenitiess " + indexPath.description
//        view.model.image = cellAt.icon ?? ""
//        view.model.title = cellAt.name
//        
//        cell.applyView(view: view)
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let itemsPerRow: CGFloat = 4 // Match the second image's layout
//        let padding: CGFloat = 10
//        let width = (collectionView.bounds.width - (itemsPerRow - 1) * padding) / itemsPerRow
//        return CGSize(width: width, height: 20) // Adjust height to fit icon + text
//    }
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////        return CGSize(width: (collectionView.bounds.width / 4) - 5, height: 20)
////    }
//}
//
//struct BookingRoomCellModel{
//    public var img: String = ""
//    public var title: String = ""
//    public var guests: String = ""
//    public var bedType: String = ""
//    public var date: String = ""
//    public var price: String = ""
//    public var amenities: [Amenity] = []
//    public var state: Bool = false
//    public var roomIndex: Int = 0
//    public var maxQuantity: Int = 1
//    public var selectedQuantity: Int = 1
//    public var tapped: () -> Void = {}
//}


import UIKit

class BookingRoomCell: BaseXib {
    let nibName = "BookingRoomCell"
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var guestsLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bedTypeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var selectBtn: SecondaryButton!
    @IBOutlet weak var selectedBtn: SecondaryButton!
    @IBOutlet weak var amenitiesCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    @IBInspectable public var identifier: String = "" { didSet { self.accessibilityIdentifier = identifier } }
    
    private var amenities: [Amenity] = []
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    public var model: BookingRoomCellModel = BookingRoomCellModel() {
        didSet {
            setup()
        }
    }
    
    @IBInspectable var state: Bool = false {
        didSet { model.state = state }
    }
    
    func setup() {
        setState()
        cellView.layer.cornerRadius = 15
        cellView.backgroundColor = .white
        selectBtn.layer.borderColor = UIColor.grey.cgColor
        selectBtn.tintColor = .beachBlue
        selectedBtn.layer.borderColor = UIColor.beachBlue.cgColor
        selectedBtn.tintColor = .beachBlue
        selectedBtn.backgroundColor = .bBLight
        guestsLabel.text = model.guests
        bedTypeLabel.text = model.bedType
        dateLabel.text = model.date
        priceLabel.text = model.price
        titleLabel.text = model.title
        
        if let layout = amenitiesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = CGSize(width: (amenitiesCollectionView.bounds.width / 4) - 5, height: 50)
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 15
            layout.scrollDirection = .vertical
        }
        
        amenitiesCollectionView.delegate = self
        amenitiesCollectionView.dataSource = self
        amenitiesCollectionView.backgroundColor = .clear
        amenitiesCollectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        amenities = model.amenities
        
        if let url = URL(string: model.img.replacingOccurrences(of: "http://", with: "https://")) {
            image.sd_setImage(with: url, placeholderImage: UIImage(named: "dummy"))
        }
        
        selectBtn.addTarget(self, action: #selector(onTapped), for: .touchUpInside)
        selectedBtn.addTarget(self, action: #selector(onTapped), for: .touchUpInside)
        
        amenitiesCollectionView.reloadData()
        updateCollectionViewHeight()
    }
    
    @objc func onTapped(_ sender: UIButton) {
        model.tapped()
    }
    
    func setState() {
        if model.state {
            layer.borderColor = UIColor.beachBlue.cgColor
            layer.borderWidth = 2
            layer.cornerRadius = 8
            selectBtn.isHidden = true
            selectedBtn.isHidden = false
            let quantityText = model.selectedQuantity > 1 ? "\(model.selectedQuantity) Units" : "1 Unit"
            selectedBtn.setTitle(quantityText, for: .normal)
            selectedBtn.setTitleColor(.beachBlue, for: .normal)
        } else {
            layer.borderColor = UIColor.clear.cgColor
            layer.borderWidth = 0
            selectBtn.isHidden = false
            selectedBtn.isHidden = true
            selectBtn.setTitle("Select", for: .normal)
        }
    }
    
    func updateCollectionViewHeight() {
        let layout = amenitiesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let itemsPerRow: CGFloat = 4
        let totalRows = Int(ceil(Double(min(amenities.count, 16)) / Double(itemsPerRow)))
        let itemHeight: CGFloat = 20 // Adjust based on icon + text height
        let height = CGFloat(totalRows) * itemHeight + CGFloat(max(0, totalRows - 1)) * (layout?.minimumLineSpacing ?? 15)
        print(height)
        
        collectionViewHeight.constant = height
        layoutIfNeeded()
    }
}

extension BookingRoomCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(amenities.count, 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = amenitiesCollectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
        let amenity = amenities[indexPath.item]
        
        let view = CatViewCell(frame: cell.bounds)
        view.identifier = "Amenities " + indexPath.description
        view.model.image = amenity.icon ?? ""
        view.model.title = amenity.name
        
        cell.applyView(view: view)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 4
        let padding: CGFloat = 10
        let width = (collectionView.bounds.width - (itemsPerRow - 1) * padding) / itemsPerRow
        return CGSize(width: width, height: 20)
    }
}

struct BookingRoomCellModel {
    public var img: String = ""
    public var title: String = ""
    public var guests: String = ""
    public var bedType: String = ""
    public var date: String = ""
    public var price: String = ""
    public var amenities: [Amenity] = []
    public var state: Bool = false
    public var roomIndex: Int = 0
    public var maxQuantity: Int = 1
    public var selectedQuantity: Int = 1
    public var tapped: () -> Void = {}
}

//
//  BookingRoomCell.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 28/12/2024.
//

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
        
        // Load amenities
        amenities = Array(model.amenities.prefix(10)) // Limit to 10 items as per your original code
        
        // Setup intelligent layout for amenities
        setupIntelligentAmenitiesLayout()
        
        if let url = URL(string: model.img.replacingOccurrences(of: "http://", with: "https://")) {
            image.sd_setImage(with: url, placeholderImage: UIImage(named: "dummy"))
        }
        
        selectBtn.addTarget(self, action: #selector(onTapped), for: .touchUpInside)
        selectedBtn.addTarget(self, action: #selector(onTapped), for: .touchUpInside)
        
        amenitiesCollectionView.reloadData()
        
        // Update height after layout
        DispatchQueue.main.async {
            self.updateIntelligentCollectionViewHeight()
        }
    }
    
    private func setupIntelligentAmenitiesLayout() {
        // Create and configure the intelligent layout
        let intelligentLayout = IntelligentFlowLayout()
        intelligentLayout.minimumLineSpacing = 6
        intelligentLayout.minimumInteritemSpacing = 6
        intelligentLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
        
        // Calculate item sizes based on amenity names
        intelligentLayout.itemSizes = amenities.map { amenity in
            let width = calculateItemWidth(for: amenity.name)
            return CGSize(width: width, height: 32) // Slightly smaller height for this cell
        }
        
        amenitiesCollectionView.collectionViewLayout = intelligentLayout
        amenitiesCollectionView.delegate = self
        amenitiesCollectionView.dataSource = self
        amenitiesCollectionView.backgroundColor = .clear
        amenitiesCollectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
    }
    
    private func calculateItemWidth(for text: String) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 11) // Smaller font for this compact cell
        let textSize = text.size(withAttributes: [NSAttributedString.Key.font: font])
        
        // Account for icon, padding, and spacing in your CatViewCell
        let iconWidth: CGFloat = 16 // Smaller icon for compact layout
        let horizontalPadding: CGFloat = 16 // Reduced padding
        let iconTextSpacing: CGFloat = 6 // Reduced spacing
        let minimumWidth: CGFloat = 50
        let buffer: CGFloat = 4
        
        let calculatedWidth = textSize.width + iconWidth + iconTextSpacing + horizontalPadding + buffer
        
        return max(calculatedWidth, minimumWidth)
    }
    
    private func updateIntelligentCollectionViewHeight() {
        // Force layout calculation
        amenitiesCollectionView.layoutIfNeeded()
        
        let contentHeight = amenitiesCollectionView.collectionViewLayout.collectionViewContentSize.height
        collectionViewHeight.constant = max(contentHeight, 50) // Minimum height
        
        // Animate the constraint change
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
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

// MARK: - Optional: Compact CatViewCell variant for BookingRoomCell
// Add this to your CatViewCell class if you want a more compact version

//extension CatViewCell {
//    func setupCompactLayout() {
//        // Make everything slightly smaller for the booking cell context
//        image.widthAnchor.constraint(equalToConstant: 16).isActive = true
//        image.heightAnchor.constraint(equalToConstant: 16).isActive = true
//        title.font = UIFont.systemFont(ofSize: 11, weight: .medium)
//    }
//}


//import UIKit
//
//class BookingRoomCell: BaseXib {
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
//    @IBInspectable public var identifier: String = "" { didSet { self.accessibilityIdentifier = identifier } }
//    
//    private var amenities: [Amenity] = []
//    
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//    
//    public required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setup()
//    }
//    
//    public var model: BookingRoomCellModel = BookingRoomCellModel() {
//        didSet {
//            setup()
//        }
//    }
//    
//    @IBInspectable var state: Bool = false {
//        didSet { model.state = state }
//    }
//    
//    func setup() {
//        setState()
//        cellView.layer.cornerRadius = 15
//        cellView.backgroundColor = .white
//        selectBtn.layer.borderColor = UIColor.grey.cgColor
//        selectBtn.tintColor = .beachBlue
//        selectedBtn.layer.borderColor = UIColor.beachBlue.cgColor
//        selectedBtn.tintColor = .beachBlue
//        selectedBtn.backgroundColor = .bBLight
//        guestsLabel.text = model.guests
//        bedTypeLabel.text = model.bedType
//        dateLabel.text = model.date
//        priceLabel.text = model.price
//        titleLabel.text = model.title
//        
//        if let layout = amenitiesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.estimatedItemSize = CGSize(width: (amenitiesCollectionView.bounds.width / 4) - 5, height: 50)
//            layout.minimumInteritemSpacing = 10
//            layout.minimumLineSpacing = 15
//            layout.scrollDirection = .vertical
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
//        selectBtn.addTarget(self, action: #selector(onTapped), for: .touchUpInside)
//        selectedBtn.addTarget(self, action: #selector(onTapped), for: .touchUpInside)
//        
//        amenitiesCollectionView.reloadData()
//        updateCollectionViewHeight()
//    }
//    
//    @objc func onTapped(_ sender: UIButton) {
//        model.tapped()
//    }
//    
//    func setState() {
//        if model.state {
//            layer.borderColor = UIColor.beachBlue.cgColor
//            layer.borderWidth = 2
//            layer.cornerRadius = 8
//            selectBtn.isHidden = true
//            selectedBtn.isHidden = false
//            let quantityText = model.selectedQuantity > 1 ? "\(model.selectedQuantity) Units" : "1 Unit"
//            selectedBtn.setTitle(quantityText, for: .normal)
//            selectedBtn.setTitleColor(.beachBlue, for: .normal)
//        } else {
//            layer.borderColor = UIColor.clear.cgColor
//            layer.borderWidth = 0
//            selectBtn.isHidden = false
//            selectedBtn.isHidden = true
//            selectBtn.setTitle("Select", for: .normal)
//        }
//    }
//    
//    func updateCollectionViewHeight() {
//        let layout = amenitiesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
//        let itemsPerRow: CGFloat = 4
//        let totalRows = Int(ceil(Double(min(amenities.count, 16)) / Double(itemsPerRow)))
//        let itemHeight: CGFloat = 20 // Adjust based on icon + text height
//        let height = CGFloat(totalRows) * itemHeight + CGFloat(max(0, totalRows - 1)) * (layout?.minimumLineSpacing ?? 15)
//        print(height)
//        
//        collectionViewHeight.constant = height
//        layoutIfNeeded()
//    }
//}
//
//extension BookingRoomCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return min(amenities.count, 10)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = amenitiesCollectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
//        let amenity = amenities[indexPath.item]
//        
//        let view = CatViewCell(frame: cell.bounds)
//        view.identifier = "Amenities " + indexPath.description
//        view.model.image = amenity.icon ?? ""
//        view.model.title = amenity.name
//        
//        cell.applyView(view: view)
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let itemsPerRow: CGFloat = 4
//        let padding: CGFloat = 10
//        let width = (collectionView.bounds.width - (itemsPerRow - 1) * padding) / itemsPerRow
//        return CGSize(width: width, height: 20)
//    }
//}
//
//struct BookingRoomCellModel {
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

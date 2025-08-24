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
//    private var itemSizes: [CGSize] = []
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
//        setupCollectionView()
//        
//        if let url = URL(string: model.img.replacingOccurrences(of: "http://", with: "https://")) {
//            image.sd_setImage(with: url, placeholderImage: UIImage(named: "dummy"))
////            image.kf.setImage(with: url)
//        }
//        
//        // Add target for both buttons
//        selectBtn.addTarget(self, action: #selector(onTapped), for: .touchUpInside)
//        selectedBtn.addTarget(self, action: #selector(onTapped), for: .touchUpInside)
//    }
//    
//    private func setupCollectionView() {
//        // Create custom flow layout
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumInteritemSpacing = 10
//        layout.minimumLineSpacing = 15
//        layout.scrollDirection = .vertical
//        
//        amenitiesCollectionView.collectionViewLayout = layout
//        amenitiesCollectionView.delegate = self
//        amenitiesCollectionView.dataSource = self
//        amenitiesCollectionView.backgroundColor = .clear
//        amenitiesCollectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
//        
//        amenities = model.amenities
//        
//        // Calculate item sizes and update collection view height
//        DispatchQueue.main.async {
//            self.calculateItemSizes()
//            self.updateCollectionViewHeight()
//        }
//    }
//    
//    private func calculateItemSizes() {
//        itemSizes.removeAll()
//        
//        for amenity in amenities {
//            let tempView = CatViewCell(frame: CGRect.zero)
//            tempView.model.image = amenity.icon ?? ""
//            tempView.model.title = amenity.name
//            
//            // Calculate the size needed for this item
//            let size = tempView.systemLayoutSizeFitting(
//                CGSize(width: CGFloat.greatestFiniteMagnitude, height: 40), // Max width, fixed height
//                withHorizontalFittingPriority: .fittingSizeLevel,
//                verticalFittingPriority: .required
//            )
//            
//            // Add some padding
//            let finalSize = CGSize(width: size.width + 20, height: 40)
//            itemSizes.append(finalSize)
//        }
//    }
//    
//    private func updateCollectionViewHeight() {
//        guard !itemSizes.isEmpty else { return }
//        
//        let collectionViewWidth = amenitiesCollectionView.bounds.width
//        let minimumInteritemSpacing: CGFloat = 3
//        let minimumLineSpacing: CGFloat = 5
//        
//        var currentRowWidth: CGFloat = 0
//        var numberOfRows = 1
//        
//        for (index, size) in itemSizes.enumerated() {
//            let itemWidth = size.width
//            
//            if index == 0 {
//                // First item always fits
//                currentRowWidth = itemWidth
//            } else {
//                // Check if current item fits in current row
//                let neededWidth = currentRowWidth + minimumInteritemSpacing + itemWidth
//                
//                if neededWidth <= collectionViewWidth {
//                    // Item fits in current row
//                    currentRowWidth = neededWidth
//                } else {
//                    // Item doesn't fit, start new row
//                    numberOfRows += 1
//                    currentRowWidth = itemWidth
//                }
//            }
//        }
//        
//        // Calculate total height
//        let itemHeight: CGFloat = 20
//        let totalHeight = CGFloat(numberOfRows) * itemHeight + CGFloat(numberOfRows - 1) * minimumLineSpacing
//        
//        // Update collection view height constraint
//        collectionViewHeight.constant = totalHeight
//        
//        // Force layout update
//        setNeedsLayout()
//        layoutIfNeeded()
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
//        // Return pre-calculated sizes
//        if indexPath.item < itemSizes.count {
//            return itemSizes[indexPath.item]
//        }
//        
//        // Fallback size if calculation failed
//        return CGSize(width: 100, height: 20)
//    }
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

class BookingRoomCell: BaseXib{

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
    
    @IBInspectable public var identifier: String = "" { didSet {
        self.accessibilityIdentifier = identifier
    } }
    
    private var amenities: [Amenity] = []
    
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
        setState()
        cellView.layer.cornerRadius = 15
        cellView.backgroundColor = .white
        selectBtn.layer.borderColor = UIColor.grey.cgColor
        selectBtn.tintColor = .beachBlue
        selectedBtn.layer.borderColor = UIColor.beachBlue.cgColor
        selectedBtn.tintColor = .beachBlue
        selectedBtn.backgroundColor = .bBLight
        guestsLabel.text =  model.guests
        bedTypeLabel.text = model.bedType
        dateLabel.text = model.date
        priceLabel.text = model.price
        
        titleLabel.text = model.title
        
        if let layout = amenitiesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 15
        }
                    
        amenitiesCollectionView.delegate = self
        amenitiesCollectionView.dataSource = self
        amenitiesCollectionView.backgroundColor = .clear
        amenitiesCollectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        amenities = model.amenities
        
        if let url = URL(string: model.img.replacingOccurrences(of: "http://", with: "https://")) {
            image.sd_setImage(with: url, placeholderImage: UIImage(named: "dummy"))
        }
        
        // Add target for both buttons
        selectBtn.addTarget(self, action: #selector(onTapped), for: .touchUpInside)
        selectedBtn.addTarget(self, action: #selector(onTapped), for: .touchUpInside)
    }
    
    @objc func onTapped(_ sender: UIButton) {
        model.tapped() // This will trigger the quantity picker
    }
    
    func setState() {
        if model.state {
            layer.borderColor = UIColor.beachBlue.cgColor
            layer.borderWidth = 2
            layer.cornerRadius = 8
            selectBtn.isHidden = true
            selectedBtn.isHidden = false
            
            // Update button title with selected quantity
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

extension BookingRoomCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return amenities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = amenitiesCollectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
        let cellAt = amenities[indexPath.item]
        
        let view = CatViewCell(frame: cell.bounds)
        view.identifier = "Amenitiess " + indexPath.description
        view.model.image = cellAt.icon ?? ""
        view.model.title = cellAt.name
        
        cell.applyView(view: view)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width / 4) - 5, height: 20)
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
    public var roomIndex: Int = 0
    public var maxQuantity: Int = 1
    public var selectedQuantity: Int = 1
    public var tapped: () -> Void = {}
}

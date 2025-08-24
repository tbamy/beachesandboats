//
//  FilterModal.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 03/08/2024.
//

import UIKit

class FilterModal: BaseXib {
    
    let nibName = "FilterModal"
    @IBOutlet weak var cancelBtn: UIImageView!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var propertyTypeCollection: UICollectionView!
    @IBOutlet weak var priceSlider: PriceRangeSlider!
    @IBOutlet weak var minPriceLabel: UILabel!
    @IBOutlet weak var maxPriceLabel: UILabel!
    @IBOutlet weak var noOfBedroomCollection: UICollectionView!
    @IBOutlet weak var noOfAdultCollection: UICollectionView!
    @IBOutlet weak var noOfChildrenCollection: UICollectionView!
    @IBOutlet weak var noOfBedCollection: UICollectionView!
    @IBOutlet weak var petSwitch: UISwitch!
    @IBOutlet weak var noOfBathroomCollection: UICollectionView!
    @IBOutlet weak var amenitiesCollection: UICollectionView!
    
    
    @IBOutlet weak var minView: UIView!
    @IBOutlet weak var maxView: UIView!
    
    
    @IBOutlet weak var propertyTypeHeight: NSLayoutConstraint!
    @IBOutlet weak var noOfBedroomHeight: NSLayoutConstraint!
    @IBOutlet weak var noOfAdultsHeight: NSLayoutConstraint!
    @IBOutlet weak var noOfChildrenHeight: NSLayoutConstraint!
    @IBOutlet weak var noOfBedHeight: NSLayoutConstraint!
    @IBOutlet weak var noOfBathroomHeight: NSLayoutConstraint!
    @IBOutlet weak var amenitiesHeight: NSLayoutConstraint!
    
    
    var propertyType: [FilterPropertyTypes] = []
    var noOfBedroom: [String] = []
    var noOfAdult: [String] = []
    var noOfChildren: [String] = []
    var noOfBed: [String] = []
    var noOfBathroom: [String] = []
    var amenities: [RoomAmenities] = []
    var filterType: String = ""
    
    
    private var selectedPropertyType: String = ""
    private var selectedBedroom: Int = 0
    private var selectedAdult: Int = 0
    private var selectedChildren: Int = 0
    private var selectedBed: Int = 0
    private var selectedBathroom: Int = 0
    private var selectedAmenities: [String] = []
    private var selectedPet: Bool = false
    private var selectedMinPrice: Double = 0
    private var selectedMaxPrice: Double = 0
    
    var selectedFilter: GetBookingCategorySearchRequest?
    
    var callback: (GetBookingCategorySearchRequest?) -> Void = { _ in }
    var clearAll: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    
    func setup(){
        minView.backgroundColor = .clear
        minView.layer.cornerRadius = 8
        minView.layer.borderWidth = 0.5
        minView.layer.borderColor = UIColor.darkGray.cgColor
        
        maxView.backgroundColor = .clear
        maxView.layer.cornerRadius = 8
        maxView.layer.borderWidth = 0.5
        maxView.layer.borderColor = UIColor.darkGray.cgColor
        
        configureCollectionViews()
        populateData()
        cancelBtn.isUserInteractionEnabled = true
        cancelBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissal)))
        
        priceSlider.onValueChanged = { [weak self] min, max in
            self?.minPriceLabel.text = "₦ \(min)"
            self?.maxPriceLabel.text = "₦ \(max)+"
            
            self?.selectedMinPrice = min
            self?.selectedMaxPrice = max
        }
    }
    
    func populateData(){
        noOfBedroom = [ "Any", "1", "2", "3", "4", "5", "6", "7", "8+"]
        noOfAdult = [ "Any", "1", "2", "3", "4", "5", "6", "7", "8+"]
        noOfChildren = [ "Any", "1", "2", "3", "4", "5", "6", "7", "8+"]
        noOfBed = [ "Any", "1", "2", "3", "4", "5", "6", "7", "8+"]
        noOfBathroom = [ "Any", "1", "2", "3", "4", "5", "6", "7", "8+"]
    }
    
    private func configureCollectionViews() {
        let collectionViews: [(UICollectionView, FilterCollectionViewType)] = [
            (propertyTypeCollection, .propertyType),
            (noOfBedroomCollection, .noOfBedroom),
            (noOfAdultCollection, .noOfAdult),
            (noOfChildrenCollection, .noOfChildren),
            (noOfBedCollection, .noOfBed),
            (noOfBathroomCollection, .noOfBathroom),
            (amenitiesCollection, .amenities)
        ]
        
        collectionViews.forEach { collectionView, type in
            configureCollectionView(collectionView, tag: type.rawValue)
        }
    }
    
    private func configureCollectionView(_ collectionView: UICollectionView, tag: Int) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.tag = tag
        collectionView.backgroundColor = .clear
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        
        // Configure flow layout for automatic sizing
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumInteritemSpacing = 10
            flowLayout.minimumLineSpacing = 10
            flowLayout.scrollDirection = .vertical
            
            // Remove automatic sizing - we'll handle it manually
            flowLayout.estimatedItemSize = CGSize.zero
        }
    }
    
    // MARK: - Helper Methods for Dynamic Height Calculation
    
    private func getText(for type: FilterCollectionViewType, at indexPath: IndexPath) -> String {
        switch type {
        case .propertyType:
            return indexPath.item < propertyType.count ? propertyType[indexPath.item].name : ""
        case .noOfBedroom:
            return indexPath.item < noOfBedroom.count ? noOfBedroom[indexPath.item] : ""
        case .noOfAdult:
            return indexPath.item < noOfAdult.count ? noOfAdult[indexPath.item] : ""
        case .noOfChildren:
            return indexPath.item < noOfChildren.count ? noOfChildren[indexPath.item] : ""
        case .noOfBed:
            return indexPath.item < noOfBed.count ? noOfBed[indexPath.item] : ""
        case .noOfBathroom:
            return indexPath.item < noOfBathroom.count ? noOfBathroom[indexPath.item] : ""
        case .amenities:
            return indexPath.item < amenities.count ? amenities[indexPath.item].name ?? "" : ""
        }
    }
    
    private func calculateItemWidth(for text: String) -> CGFloat {
        
        let font = UIFont.systemFont(ofSize: 16, weight: .medium)
        let textSize = text.size(withAttributes: [NSAttributedString.Key.font: font])
        
        let horizontalPadding: CGFloat = 32 // Adjust this based on your SelectableViewWithBg padding
        let minimumWidth: CGFloat = 60
        
        // Add some extra buffer to prevent truncation
        let buffer: CGFloat = 8
        let calculatedWidth = textSize.width + horizontalPadding + buffer
        
        return max(calculatedWidth, minimumWidth)
    }

    
    private func getItemCount(for type: FilterCollectionViewType) -> Int {
        switch type {
        case .propertyType: return propertyType.count
        case .noOfBedroom: return noOfBedroom.count
        case .noOfAdult: return noOfAdult.count
        case .noOfChildren: return noOfChildren.count
        case .noOfBed: return noOfBed.count
        case .noOfBathroom: return noOfBathroom.count
        case .amenities: return amenities.count
        }
    }
    
    private func updateCollectionViewHeight(_ collectionView: UICollectionView, heightConstraint: NSLayoutConstraint) {
        // Force layout to ensure we have correct bounds
        collectionView.layoutIfNeeded()
        
        guard let type = FilterCollectionViewType(rawValue: collectionView.tag) else { return }
        
        let itemCount = getItemCount(for: type)
        guard itemCount > 0 else {
            heightConstraint.constant = 0
            return
        }
        
        let collectionViewWidth = collectionView.bounds.width
        let itemHeight: CGFloat = 40
        let horizontalSpacing: CGFloat = 10
        let verticalSpacing: CGFloat = 10
        let sectionInset: CGFloat = 0
        
        var currentRowWidth: CGFloat = sectionInset
        var numberOfRows: Int = 1
        
        // Calculate rows based on text width calculation
        for i in 0..<itemCount {
            let text = getText(for: type, at: IndexPath(item: i, section: 0))
            let itemWidth = calculateItemWidth(for: text)
            
            let requiredWidth = currentRowWidth + itemWidth + (currentRowWidth > sectionInset ? horizontalSpacing : 0)
            
            if requiredWidth <= collectionViewWidth - sectionInset {
                currentRowWidth = requiredWidth
            } else {
                // Start new row
                numberOfRows += 1
                currentRowWidth = sectionInset + itemWidth
            }
        }
        
        let totalHeight = (CGFloat(numberOfRows) * itemHeight) + (CGFloat(max(0, numberOfRows - 1)) * verticalSpacing)
        
        heightConstraint.constant = totalHeight
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    // MARK: - Call this when data changes
    func refreshCollectionViewLayout() {
        DispatchQueue.main.async {
            // Reload data first
            self.propertyTypeCollection.reloadData()
            self.noOfBedroomCollection.reloadData()
            self.noOfAdultCollection.reloadData()
            self.noOfChildrenCollection.reloadData()
            self.noOfBedCollection.reloadData()
            self.noOfBathroomCollection.reloadData()
            self.amenitiesCollection.reloadData()
            
            // Then update heights after a brief delay to ensure collection views are laid out
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.updateAllCollectionViewHeights()
            }
        }
    }
    
    func updateAllCollectionViewHeights() {
        updateCollectionViewHeight(propertyTypeCollection, heightConstraint: propertyTypeHeight)
        updateCollectionViewHeight(noOfBedroomCollection, heightConstraint: noOfBedroomHeight)
        updateCollectionViewHeight(noOfAdultCollection, heightConstraint: noOfAdultsHeight)
        updateCollectionViewHeight(noOfChildrenCollection, heightConstraint: noOfChildrenHeight)
        updateCollectionViewHeight(noOfBedCollection, heightConstraint: noOfBedHeight)
        updateCollectionViewHeight(noOfBathroomCollection, heightConstraint: noOfBathroomHeight)
        updateCollectionViewHeight(amenitiesCollection, heightConstraint: amenitiesHeight)
    }
    
    // MARK: - Override viewDidLayoutSubviews to update heights when bounds change
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update heights when the view's bounds change
        updateAllCollectionViewHeights()
    }

    @IBAction func clearTapped(_ sender: Any) {
        clearAll?()
        dismiss()
    }
    
    @IBAction func showListingsTapped(_ sender: Any) {
        
        let petAllowed = selectedPet ? 1 : 0
        
        let searchQuery = GetBookingCategorySearchRequest(page: 1,
                                                          subCategoryId: selectedPropertyType,
                                                          minPrice: selectedMinPrice,
                                                          maxPrice: selectedMaxPrice,
                                                          noOfBedrooms: selectedBedroom,
                                                          noOfAdults: selectedAdult,
                                                          noOfChildren: selectedChildren,
                                                          noOfBeds: selectedBed,
                                                          petAllowed: petAllowed,
                                                          languages: [],
                                                          amenities: selectedAmenities,
                                                          filterType: filterType,
                                                          searchQuery: "")
        
        print(searchQuery)
        
        callback(searchQuery)
        dismiss()
    }
    
    @objc func handleDismissal() {
        dismiss()
    }
}

extension FilterModal: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let type = FilterCollectionViewType(rawValue: collectionView.tag) else { return 0 }
        return getItemCount(for: type)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let type = FilterCollectionViewType(rawValue: collectionView.tag) else {
            return UICollectionViewCell()
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
        
        switch type {
        case .propertyType:
            return configurePropertiesCell(cell, at: indexPath)
        case .noOfBedroom:
            return configureBedroomCell(cell, at: indexPath)
        case .noOfAdult:
            return configureAdultCell(cell, at: indexPath)
        case .noOfChildren:
            return configureChildrenCell(cell, at: indexPath)
        case .noOfBed:
            return configureBedsCell(cell, at: indexPath)
        case .noOfBathroom:
            return configureBathroomCell(cell, at: indexPath)
        case .amenities:
            return configureAmenitiesCell(cell, at: indexPath)
        }
    }
    
    // MARK: - Flow Layout Delegate for Dynamic Sizing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let type = FilterCollectionViewType(rawValue: collectionView.tag) else {
            return CGSize(width: 60, height: 40)
        }
        
        let text = getText(for: type, at: indexPath)
        let width = calculateItemWidth(for: text)
        return CGSize(width: width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let type = FilterCollectionViewType(rawValue: collectionView.tag) else { return }

        // Track previously selected index
        var previouslySelectedIndex: Int?

        switch type {
        case .propertyType:
            let property = propertyType[indexPath.item]
            previouslySelectedIndex = propertyType.firstIndex { $0.id == selectedPropertyType }
            selectedPropertyType = property.id

        case .noOfBedroom:
            previouslySelectedIndex = selectedBedroom
            selectedBedroom = indexPath.item

        case .noOfAdult:
            previouslySelectedIndex = selectedAdult
            selectedAdult = indexPath.item

        case .noOfChildren:
            previouslySelectedIndex = selectedChildren
            selectedChildren = indexPath.item

        case .noOfBed:
            previouslySelectedIndex = selectedBed
            selectedBed = indexPath.item

        case .noOfBathroom:
            previouslySelectedIndex = selectedBathroom
            selectedBathroom = indexPath.item

        case .amenities:
//            let amenity = amenities[indexPath.item]
//            previouslySelectedIndex = amenities.firstIndex { $0.id == selectedAmenities }
//            selectedAmenities = amenity.id ?? ""
            
            let amenity = amenities[indexPath.item]
            guard let amenityId = amenity.id else { return }
            
            if selectedAmenities.contains(amenityId) {
                // Remove from selection
                selectedAmenities.removeAll { $0 == amenityId }
            } else {
                // Add to selection
                selectedAmenities.append(amenityId)
            }
                                    
        }

        // Reload just the previously selected and newly selected cell
        var indexPathsToReload: [IndexPath] = [indexPath]

        if let prev = previouslySelectedIndex, prev != indexPath.item {
            indexPathsToReload.append(IndexPath(item: prev, section: 0))
        }

        collectionView.reloadItems(at: indexPathsToReload)
    }

    
    // MARK: - Cell Configuration Methods
    private func configurePropertiesCell(_ cell: DynamicCollectionViewCell, at indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.item < propertyType.count else { return cell }
        let category = propertyType[indexPath.item]
        let text = category.name
        let cellWidth = calculateItemWidth(for: text)
        
        let view = SelectableViewWithBg(frame: CGRect(x: 0, y: 0, width: cellWidth, height: 40))
        view.identifier = "PropertyType \(indexPath.description)"
        view.titleOnlyMode = true
        view.model.title = text
        view.model.state = (category.id == selectedPropertyType)
        view.setState()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        cell.applyView(view: view)
        
        return cell
    }
    
    private func configureBedroomCell(_ cell: DynamicCollectionViewCell, at indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.item < noOfBedroom.count else { return cell }
        let category = noOfBedroom[indexPath.item]
        let cellWidth = calculateItemWidth(for: category)
        
        let view = SelectableViewWithBg(frame: CGRect(x: 0, y: 0, width: cellWidth, height: 40))
        view.identifier = "noOfBedroom \(indexPath.description)"
        view.titleOnlyMode = true
        view.model.title = category
        view.model.state = (indexPath.item == selectedBedroom)
        view.setState()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        cell.applyView(view: view)
        return cell
    }
    
    private func configureAdultCell(_ cell: DynamicCollectionViewCell, at indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.item < noOfAdult.count else { return cell }
        let category = noOfAdult[indexPath.item]
        let cellWidth = calculateItemWidth(for: category)
        
        let view = SelectableViewWithBg(frame: CGRect(x: 0, y: 0, width: cellWidth, height: 40))
        view.identifier = "noOfAdult \(indexPath.description)"
        view.titleOnlyMode = true
        view.model.title = category
        view.model.state = (indexPath.item == selectedAdult)
        view.setState()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        cell.applyView(view: view)
        return cell
    }
    
    private func configureChildrenCell(_ cell: DynamicCollectionViewCell, at indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.item < noOfChildren.count else { return cell }
        let category = noOfChildren[indexPath.item]
        let cellWidth = calculateItemWidth(for: category)
        
        let view = SelectableViewWithBg(frame: CGRect(x: 0, y: 0, width: cellWidth, height: 40))
        view.identifier = "noOfChildren \(indexPath.description)"
        view.titleOnlyMode = true
        view.model.title = category
        view.model.state = (indexPath.item == selectedChildren)
        view.setState()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        cell.applyView(view: view)
        return cell
    }
    
    private func configureBedsCell(_ cell: DynamicCollectionViewCell, at indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.item < noOfBed.count else { return cell }
        let category = noOfBed[indexPath.item]
        let cellWidth = calculateItemWidth(for: category)
        
        let view = SelectableViewWithBg(frame: CGRect(x: 0, y: 0, width: cellWidth, height: 40))
        view.identifier = "noOfBed \(indexPath.description)"
        view.titleOnlyMode = true
        view.model.title = category
        view.model.state = (indexPath.item == selectedBed)
        view.setState()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        cell.applyView(view: view)
        return cell
    }
    
    private func configureBathroomCell(_ cell: DynamicCollectionViewCell, at indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.item < noOfBathroom.count else { return cell }
        let category = noOfBathroom[indexPath.item]
        let cellWidth = calculateItemWidth(for: category)
        
        let view = SelectableViewWithBg(frame: CGRect(x: 0, y: 0, width: cellWidth, height: 40))
        view.identifier = "noOfBathroom \(indexPath.description)"
        view.titleOnlyMode = true
        view.model.title = category
        view.model.state = (indexPath.item == selectedBathroom)
        view.setState()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        cell.applyView(view: view)
        return cell
    }
    
    private func configureAmenitiesCell(_ cell: DynamicCollectionViewCell, at indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.item < amenities.count else { return cell }
        let category = amenities[indexPath.item]
        let text = category.name ?? ""
        let cellWidth = calculateItemWidth(for: text)
        
        let view = SelectableViewWithBg(frame: CGRect(x: 0, y: 0, width: cellWidth, height: 40))
        view.identifier = "amenities \(indexPath.description)"
        view.titleOnlyMode = true
        view.selectMultiple = true
        view.model.title = text
        view.model.selectMultiple = true
        view.model.state = selectedAmenities.contains(category.id ?? "")
        view.setState()

        
        view.translatesAutoresizingMaskIntoConstraints = false
        cell.applyView(view: view)
        return cell
    }
}

extension FilterModal {
    
    public static func startFilterModal(propertyTypes: [FilterPropertyTypes], amenities: [RoomAmenities], filterType: String?, callBack: @escaping (GetBookingCategorySearchRequest?) -> Void, clearAll: @escaping () -> Void) {
        let backDrop = UIView(frame: Helpers.screen)
        backDrop.backgroundColor = .gray.withAlphaComponent(0.5)
        
        let modal = FilterModal()
        modal.callback = callBack
        modal.propertyType = propertyTypes
        modal.amenities = amenities
        modal.filterType = filterType ?? ""
        
        modal.backgroundColor = .background.lighter(by: 17)
        modal.layer.cornerRadius = 12
        modal.clipsToBounds = true
        backDrop.addSubview(modal)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.addSubview(backDrop)
        }
        
        let height = Helpers.screenHeight * 0.9
        modal.frame = CGRect(x: 0, y: Helpers.screenHeight, width: Helpers.screenWidth, height: height)
        backDrop.layoutIfNeeded()
        
        // Refresh layout after the modal is added and has proper bounds
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            modal.refreshCollectionViewLayout()
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            modal.frame.origin.y = Helpers.screenHeight - height
            backDrop.layoutIfNeeded()
        }, completion: nil)
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            self?.frame.origin.y = Helpers.screenHeight
            self?.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.superview?.removeFromSuperview()
        })
    }
}

enum FilterCollectionViewType: Int {
    case propertyType = 1
    case noOfBedroom = 2
    case noOfAdult = 3
    case noOfChildren = 4
    case noOfBed = 5
    case noOfBathroom = 6
    case amenities = 7
}

struct FilterPropertyTypes: Codable {
    let id: String
    let name: String
}



//import UIKit
//
//class FilterModal: BaseXib {
//    
//    let nibName = "FilterModal"
//    @IBOutlet weak var cancelBtn: UIImageView!
//    @IBOutlet weak var clearBtn: UIButton!
//    @IBOutlet weak var propertyTypeCollection: UICollectionView!
//    @IBOutlet weak var priceSlider: PriceRangeSlider!
//    @IBOutlet weak var minPriceLabel: UILabel!
//    @IBOutlet weak var maxPriceLabel: UILabel!
//    @IBOutlet weak var noOfBedroomCollection: UICollectionView!
//    @IBOutlet weak var noOfAdultCollection: UICollectionView!
//    @IBOutlet weak var noOfChildrenCollection: UICollectionView!
//    @IBOutlet weak var noOfBedCollection: UICollectionView!
//    @IBOutlet weak var petSwitch: UISwitch!
//    @IBOutlet weak var noOfBathroomCollection: UICollectionView!
//    @IBOutlet weak var amenitiesCollection: UICollectionView!
//    
//    
//    @IBOutlet weak var minView: UIView!
//    @IBOutlet weak var maxView: UIView!
//    
//    
//    @IBOutlet weak var propertyTypeHeight: NSLayoutConstraint!
//    @IBOutlet weak var noOfBedroomHeight: NSLayoutConstraint!
//    @IBOutlet weak var noOfAdultsHeight: NSLayoutConstraint!
//    @IBOutlet weak var noOfChildrenHeight: NSLayoutConstraint!
//    @IBOutlet weak var noOfBedHeight: NSLayoutConstraint!
//    @IBOutlet weak var noOfBathroomHeight: NSLayoutConstraint!
//    @IBOutlet weak var amenitiesHeight: NSLayoutConstraint!
//    
//    
//    var propertyType: [SubCategory] = []
//    var noOfBedroom: [String] = []
//    var noOfAdult: [String] = []
//    var noOfChildren: [String] = []
//    var noOfBed: [String] = []
//    var noOfBathroom: [String] = []
//    var amenities: [Amenity] = []
//    var filterType: String = ""
//    
//    
//    private var selectedPropertyType: String = ""
//    private var selectedBedroom: Int = 0
//    private var selectedAdult: Int = 0
//    private var selectedChildren: Int = 0
//    private var selectedBed: Int = 0
//    private var selectedBathroom: Int = 0
//    private var selectedAmenities: String = ""
//    private var selectedPet: Bool = false
//    private var selectedMinPrice: Double = 0
//    private var selectedMaxPrice: Double = 0
//    
//    var selectedFilter: GetBookingCategorySearchRequest?
//    
//    var callback: (GetBookingCategorySearchRequest?) -> Void = { _ in }
//    var clearAll: (() -> Void)?
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setup()
//    }
//
//    
//    func setup(){
//        minView.backgroundColor = .clear
//        minView.layer.cornerRadius = 8
//        minView.layer.borderWidth = 0.5
//        minView.layer.borderColor = UIColor.darkGray.cgColor
//        
//        maxView.backgroundColor = .clear
//        maxView.layer.cornerRadius = 8
//        maxView.layer.borderWidth = 0.5
//        maxView.layer.borderColor = UIColor.darkGray.cgColor
//        
//        configureCollectionViews()
//        populateData()
//        cancelBtn.isUserInteractionEnabled = true
//        cancelBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissal)))
//        
//        priceSlider.onValueChanged = { [weak self] min, max in
//            self?.minPriceLabel.text = "₦ \(min)"
//            self?.maxPriceLabel.text = "₦ \(max)+"
//            
//            self?.selectedMinPrice = min
//            self?.selectedMaxPrice = max
//        }
//    }
//    
//    func populateData(){
//        noOfBedroom = [ "Any", "11", "21", "31", "41", "51", "61", "71", "8+"]
//        noOfAdult = [ "Any", "1", "2", "3", "4", "5", "6", "7", "8+"]
//        noOfChildren = [ "Any", "1", "2", "3", "4", "5", "6", "7", "8+"]
//        noOfBed = [ "Any", "1", "2", "3", "4", "5", "6", "7", "8+"]
//        noOfBathroom = [ "Any", "1", "2", "3", "4", "5", "6", "7", "8+"]
//    }
//    
//    private func configureCollectionViews() {
//        let collectionViews: [(UICollectionView, FilterCollectionViewType)] = [
//            (propertyTypeCollection, .propertyType),
//            (noOfBedroomCollection, .noOfBedroom),
//            (noOfAdultCollection, .noOfAdult),
//            (noOfChildrenCollection, .noOfChildren),
//            (noOfBedCollection, .noOfBed),
//            (noOfBathroomCollection, .noOfBathroom),
//            (amenitiesCollection, .amenities)
//        ]
//        
//        collectionViews.forEach { collectionView, type in
//            configureCollectionView(collectionView, tag: type.rawValue)
//        }
//    }
//    
//    private func configureCollectionView(_ collectionView: UICollectionView, tag: Int) {
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.tag = tag
//        collectionView.backgroundColor = .clear
//        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
//        
//        // Configure flow layout for automatic sizing
//        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            // Use estimated item size for automatic sizing
//            flowLayout.minimumInteritemSpacing = 10
//            flowLayout.minimumLineSpacing = 10
//            flowLayout.scrollDirection = .vertical
//            
//            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//
//
//        }
//    }
//    
//    // MARK: - Helper Methods for Dynamic Height Calculation
//    
//    private func getText(for type: FilterCollectionViewType, at indexPath: IndexPath) -> String {
//        switch type {
//        case .propertyType:
//            return indexPath.item < propertyType.count ? propertyType[indexPath.item].name ?? "" : ""
//        case .noOfBedroom:
//            return indexPath.item < noOfBedroom.count ? noOfBedroom[indexPath.item] : ""
//        case .noOfAdult:
//            return indexPath.item < noOfAdult.count ? noOfAdult[indexPath.item] : ""
//        case .noOfChildren:
//            return indexPath.item < noOfChildren.count ? noOfChildren[indexPath.item] : ""
//        case .noOfBed:
//            return indexPath.item < noOfBed.count ? noOfBed[indexPath.item] : ""
//        case .noOfBathroom:
//            return indexPath.item < noOfBathroom.count ? noOfBathroom[indexPath.item] : ""
//        case .amenities:
//            return indexPath.item < amenities.count ? amenities[indexPath.item].name ?? "" : ""
//        }
//    }
//    
//    private func calculateItemWidth(for text: String) -> CGFloat {
//        let font = UIFont.systemFont(ofSize: 16)
//        let textSize = text.size(withAttributes: [NSAttributedString.Key.font: font])
//        let padding: CGFloat = 32
//        let minimumWidth: CGFloat = 60
//        return max(textSize.width + padding, minimumWidth)
//    }
//
//    
//    private func getItemCount(for type: FilterCollectionViewType) -> Int {
//        switch type {
//        case .propertyType: return propertyType.count
//        case .noOfBedroom: return noOfBedroom.count
//        case .noOfAdult: return noOfAdult.count
//        case .noOfChildren: return noOfChildren.count
//        case .noOfBed: return noOfBed.count
//        case .noOfBathroom: return noOfBathroom.count
//        case .amenities: return amenities.count
//        }
//    }
//    
//    private func updateCollectionViewHeight(_ collectionView: UICollectionView, heightConstraint: NSLayoutConstraint) {
//        // Force layout to ensure we have correct bounds
//        collectionView.layoutIfNeeded()
//        
//        guard let type = FilterCollectionViewType(rawValue: collectionView.tag) else { return }
//        
//        let itemCount = getItemCount(for: type)
//        guard itemCount > 0 else {
//            heightConstraint.constant = 0
//            return
//        }
//        
//        let collectionViewWidth = collectionView.bounds.width
//        let itemHeight: CGFloat = 40
//        let horizontalSpacing: CGFloat = 10
//        let verticalSpacing: CGFloat = 10
//        let sectionInset: CGFloat = 0
//        
//        var currentRowWidth: CGFloat = sectionInset
//        var numberOfRows: Int = 1
//        
//        // Calculate rows based on text width calculation
//        for i in 0..<itemCount {
//            let text = getText(for: type, at: IndexPath(item: i, section: 0))
//            let itemWidth = calculateItemWidth(for: text)
//            
//            let requiredWidth = currentRowWidth + itemWidth + (currentRowWidth > sectionInset ? horizontalSpacing : 0)
//            
//            if requiredWidth <= collectionViewWidth - sectionInset {
//                currentRowWidth = requiredWidth
//            } else {
//                // Start new row
//                numberOfRows += 1
//                currentRowWidth = sectionInset + itemWidth
//            }
//        }
//        
//        let totalHeight = (CGFloat(numberOfRows) * itemHeight) + (CGFloat(max(0, numberOfRows - 1)) * verticalSpacing)
//        
//        heightConstraint.constant = totalHeight
//        
//        UIView.animate(withDuration: 0.3) {
//            self.layoutIfNeeded()
//        }
//    }
//    
//    // MARK: - Call this when data changes
//    func refreshCollectionViewLayout() {
//        DispatchQueue.main.async {
//            // Reload data first
//            self.propertyTypeCollection.reloadData()
//            self.noOfBedroomCollection.reloadData()
//            self.noOfAdultCollection.reloadData()
//            self.noOfChildrenCollection.reloadData()
//            self.noOfBedCollection.reloadData()
//            self.noOfBathroomCollection.reloadData()
//            self.amenitiesCollection.reloadData()
//            
//            // Then update heights after a brief delay to ensure collection views are laid out
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                self.updateAllCollectionViewHeights()
//            }
//        }
//    }
//    
//    func updateAllCollectionViewHeights() {
//        updateCollectionViewHeight(propertyTypeCollection, heightConstraint: propertyTypeHeight)
//        updateCollectionViewHeight(noOfBedroomCollection, heightConstraint: noOfBedroomHeight)
//        updateCollectionViewHeight(noOfAdultCollection, heightConstraint: noOfAdultsHeight)
//        updateCollectionViewHeight(noOfChildrenCollection, heightConstraint: noOfChildrenHeight)
//        updateCollectionViewHeight(noOfBedCollection, heightConstraint: noOfBedHeight)
//        updateCollectionViewHeight(noOfBathroomCollection, heightConstraint: noOfBathroomHeight)
//        updateCollectionViewHeight(amenitiesCollection, heightConstraint: amenitiesHeight)
//    }
//    
//    // MARK: - Override viewDidLayoutSubviews to update heights when bounds change
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        // Update heights when the view's bounds change
//        updateAllCollectionViewHeights()
//    }
//
//    @IBAction func clearTapped(_ sender: Any) {
//        clearAll?()
//        dismiss()
//    }
//    
//    @IBAction func showListingsTapped(_ sender: Any) {
//        
//        let petAllowed = selectedPet ? 1 : 0
//        
//        let searchQuery = GetBookingCategorySearchRequest(page: 1,
//                                                          subCategoryId: selectedPropertyType,
//                                                          minPrice: selectedMinPrice,
//                                                          maxPrice: selectedMaxPrice,
//                                                          noOfBedrooms: selectedBedroom,
//                                                          noOfAdults: selectedAdult,
//                                                          noOfChildren: selectedChildren,
//                                                          noOfBeds: selectedBed,
//                                                          petAllowed: petAllowed,
//                                                          languages: [],
//                                                          amenities: [selectedAmenities],
//                                                          filterType: filterType,
//                                                          searchQuery: "")
//        
//        callback(searchQuery)
//        dismiss()
//    }
//    
//    @objc func handleDismissal() {
//        dismiss()
//    }
//}
//
//extension FilterModal: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        guard let type = FilterCollectionViewType(rawValue: collectionView.tag) else { return 0 }
//        return getItemCount(for: type)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let type = FilterCollectionViewType(rawValue: collectionView.tag) else {
//            return UICollectionViewCell()
//        }
//        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
//        
//        switch type {
//        case .propertyType:
//            return configurePropertiesCell(cell, at: indexPath)
//        case .noOfBedroom:
//            return configureBedroomCell(cell, at: indexPath)
//        case .noOfAdult:
//            return configureAdultCell(cell, at: indexPath)
//        case .noOfChildren:
//            return configureChildrenCell(cell, at: indexPath)
//        case .noOfBed:
//            return configureBedsCell(cell, at: indexPath)
//        case .noOfBathroom:
//            return configureBathroomCell(cell, at: indexPath)
//        case .amenities:
//            return configureAmenitiesCell(cell, at: indexPath)
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let type = FilterCollectionViewType(rawValue: collectionView.tag) else { return }
//        let propertyType = propertyType[indexPath.item]
//        let amenity = amenities[indexPath.item]
//        
//        switch type {
//        case .propertyType:
//            selectedPropertyType = propertyType.id ?? ""
//        case .noOfBedroom:
//            selectedBedroom = indexPath.item
//        case .noOfAdult:
//            selectedAdult = indexPath.item
//        case .noOfChildren:
//            selectedChildren = indexPath.item
//        case .noOfBed:
//            selectedBed = indexPath.item
//        case .noOfBathroom:
//            selectedBathroom = indexPath.item
//        case .amenities:
//            selectedAmenities = amenity.id ?? ""
//        }
//        
//        // Reload the specific collection view to update selection state
//        collectionView.reloadData()
//    }
//    
//    // MARK: - Cell Configuration Methods
//    private func configurePropertiesCell(_ cell: DynamicCollectionViewCell, at indexPath: IndexPath) -> UICollectionViewCell {
//        guard indexPath.item < propertyType.count else { return cell }
//        let category = propertyType[indexPath.item]
//        let view = SelectableViewWithBg(frame: cell.bounds)
//        
//        view.identifier = "PropertyType \(indexPath.description)"
//        view.titleOnlyMode = true
//        view.model.title = category.name ?? ""
//        view.model.state = (category.id == selectedPropertyType)
//        
//        cell.applyView(view: view)
//        return cell
//    }
//    
//    private func configureBedroomCell(_ cell: DynamicCollectionViewCell, at indexPath: IndexPath) -> UICollectionViewCell {
//        guard indexPath.item < noOfBedroom.count else { return cell }
//        let category = noOfBedroom[indexPath.item]
//        let view = SelectableViewWithBg(frame: cell.bounds)
//        
//        view.identifier = "noOfBedroom \(indexPath.description)"
//        view.titleOnlyMode = true
//        view.model.title = category
//        view.model.state = (indexPath.item == selectedBedroom)
//        
//        cell.applyView(view: view)
//        return cell
//    }
//    
//    private func configureAdultCell(_ cell: DynamicCollectionViewCell, at indexPath: IndexPath) -> UICollectionViewCell {
//        guard indexPath.item < noOfAdult.count else { return cell }
//        let category = noOfAdult[indexPath.item]
//        let view = SelectableViewWithBg(frame: cell.bounds)
//        
//        view.identifier = "noOfAdult \(indexPath.description)"
//        view.titleOnlyMode = true
//        view.model.title = category
//        view.model.state = (indexPath.item == selectedAdult)
//        
//        cell.applyView(view: view)
//        return cell
//    }
//    
//    private func configureChildrenCell(_ cell: DynamicCollectionViewCell, at indexPath: IndexPath) -> UICollectionViewCell {
//        guard indexPath.item < noOfChildren.count else { return cell }
//        let category = noOfChildren[indexPath.item]
//        let view = SelectableViewWithBg(frame: cell.bounds)
//        
//        view.identifier = "noOfChildren \(indexPath.description)"
//        view.titleOnlyMode = true
//        view.model.title = category
//        view.model.state = (indexPath.item == selectedChildren)
//        
//        cell.applyView(view: view)
//        return cell
//    }
//    
//    private func configureBedsCell(_ cell: DynamicCollectionViewCell, at indexPath: IndexPath) -> UICollectionViewCell {
//        guard indexPath.item < noOfBed.count else { return cell }
//        let category = noOfBed[indexPath.item]
//        let view = SelectableViewWithBg(frame: cell.bounds)
//        
//        view.identifier = "noOfBed \(indexPath.description)"
//        view.titleOnlyMode = true
//        view.model.title = category
//        view.model.state = (indexPath.item == selectedBed)
//        
//        cell.applyView(view: view)
//        return cell
//    }
//    
//    private func configureBathroomCell(_ cell: DynamicCollectionViewCell, at indexPath: IndexPath) -> UICollectionViewCell {
//        guard indexPath.item < noOfBathroom.count else { return cell }
//        let category = noOfBathroom[indexPath.item]
//        let view = SelectableViewWithBg(frame: cell.bounds)
//        
//        view.identifier = "noOfBathroom \(indexPath.description)"
//        view.titleOnlyMode = true
//        view.model.title = category
//        view.model.state = (indexPath.item == selectedBathroom)
//        
//        cell.applyView(view: view)
//        return cell
//    }
//    
//    private func configureAmenitiesCell(_ cell: DynamicCollectionViewCell, at indexPath: IndexPath) -> UICollectionViewCell {
//        guard indexPath.item < amenities.count else { return cell }
//        let category = amenities[indexPath.item]
//        let view = SelectableViewWithBg(frame: cell.bounds)
//        
//        view.identifier = "amenities \(indexPath.description)"
//        view.titleOnlyMode = true
//        view.model.title = category.name ?? ""
//        view.model.state = (category.id == selectedAmenities)
//        
//        cell.applyView(view: view)
//        return cell
//    }
//}
//
//extension FilterModal {
//    
//    public static func startFilterModal(propertyTypes: [SubCategory], amenities: [Amenity], filterType: String?, callBack: @escaping (GetBookingCategorySearchRequest?) -> Void, clearAll: @escaping () -> Void) {
//        let backDrop = UIView(frame: Helpers.screen)
//        backDrop.backgroundColor = .gray.withAlphaComponent(0.5)
//        
//        let modal = FilterModal()
//        modal.callback = callBack
//        modal.propertyType = propertyTypes
//        modal.amenities = amenities
//        modal.filterType = filterType ?? ""
//        
//        modal.backgroundColor = .background.lighter(by: 17)
//        modal.layer.cornerRadius = 12
//        modal.clipsToBounds = true
//        backDrop.addSubview(modal)
//        
//        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
//            keyWindow.addSubview(backDrop)
//        }
//        
//        let height = Helpers.screenHeight * 0.9
//        modal.frame = CGRect(x: 0, y: Helpers.screenHeight, width: Helpers.screenWidth, height: height)
//        backDrop.layoutIfNeeded()
//        
//        // Refresh layout after the modal is added and has proper bounds
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            modal.refreshCollectionViewLayout()
//        }
//        
//        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
//            modal.frame.origin.y = Helpers.screenHeight - height
//            backDrop.layoutIfNeeded()
//        }, completion: nil)
//    }
//    
//    func dismiss() {
//        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: { [weak self] in
//            self?.frame.origin.y = Helpers.screenHeight
//            self?.layoutIfNeeded()
//        }, completion: { [weak self] _ in
//            self?.superview?.removeFromSuperview()
//        })
//    }
//}
//
//enum FilterCollectionViewType: Int {
//    case propertyType = 1
//    case noOfBedroom = 2
//    case noOfAdult = 3
//    case noOfChildren = 4
//    case noOfBed = 5
//    case noOfBathroom = 6
//    case amenities = 7
//}

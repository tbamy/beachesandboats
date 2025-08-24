//
//  RoomDetailsView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 06/01/2025.
//

import UIKit
import SDWebImage
import SDWebImageSVGCoder

class RoomDetailsView: BaseViewControllerPlain {
    var coordinator: ExploreCoordinator?
    
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bedLabel: UILabel!
    @IBOutlet weak var guestsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var facilitiesCollectionView: UICollectionView!
    @IBOutlet weak var guestCommentsCollectionView: UICollectionView!
    @IBOutlet weak var accessibilityContentLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var continueBookingView: UIView!
    @IBOutlet weak var selectBtn: SecondaryButton!
    @IBOutlet weak var selectedBtn: SecondaryButton!
    @IBOutlet weak var BookingBtn: PrimaryButton!
    @IBOutlet weak var facilitiesHeightConstraint: NSLayoutConstraint!
    
    var room: BeachRoom?
    var listing: GetBeachData?
    var booking: CreateBeachHouseBookingRequest?
    var units: Int = 1
    var selectedQuantity: Int = 1
    
    private var amenities: [Amenity] = []
    var comments: [Review] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        
    }
        
    func setup(){
        
        selectedBtn.isHidden = true
        continueBookingView.isHidden = true
        selectedBtn.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        selectedBtn.semanticContentAttribute = .forceRightToLeft
        selectedBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
        
        if let url = URL(string: room?.images?.first?.url?.replacingOccurrences(of: "http://", with: "https://") ?? "") {
            print("Image Url is: \(url)")
//            topImage.kf.setImage(with: url)
            topImage.sd_setImage(with: url, placeholderImage: UIImage(named: "dummy"))
        }
        
        titleLabel.text = room?.name
        let descriptions = room?.bedTypes?.compactMap { bedType -> String? in
            guard let name = bedType.name, let quantity = bedType.quantity else { return nil }
            return "\(quantity): \(name)"
        }
        bedLabel.text = descriptions?.joined(separator: ", ") ?? ""
        
        let startDateString = booking?.checkingDate ?? ""
        let endDateString = booking?.checkoutDate ?? ""
        let nights = calculateNights(from: startDateString, to: endDateString)
        dateLabel.text = "\(startDateString.convertToShorterDateFormat() ?? "") - \(endDateString.convertToShorterDateFormat() ?? "") \(nights ?? 0) Nights"
        guestsLabel.text = "\(room?.noOfOccupant ?? "") Guests"
        descriptionLabel.text = room?.description
        accessibilityContentLabel.text = "Easy accessibility"
        if let price = listing?.pricePerNight {
            totalAmountLabel.text = "₦ \(price.toAmount() ?? "0")"
        }
        
        func configureAllCollectionViews() {
            configureCollectionView(facilitiesCollectionView, tag: 1)
            configureCollectionView(guestCommentsCollectionView, tag: 2)
        }

        
        func configureCollectionView(_ collectionView: UICollectionView, tag: Int) {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.tag = tag
            collectionView.backgroundColor = .clear
            collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        }
        
        // Configure collection views
        configureAllCollectionViews()
        
        continueBookingView.isHidden = true
        if let price = room?.pricePerNight{
            BookingBtn.setTitle("Reserve for ₦ \(price.toAmount() ?? "0")", for: .normal)
        }
        
        amenities = listing?.amenities ?? []
        facilitiesCollectionView.reloadData()
        
        self.updateCollectionViewHeight(self.facilitiesCollectionView, heightConstraint: self.facilitiesHeightConstraint)
    }
    
    private func getText(at indexPath: IndexPath) -> String {
        return indexPath.item < amenities.count ? amenities[indexPath.item].name : ""
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
    
    private func getItemCount() -> Int {
        return amenities.count
    }
    
    private func updateCollectionViewHeight(_ collectionView: UICollectionView, heightConstraint: NSLayoutConstraint) {
        // Force layout to ensure we have correct bounds
        collectionView.layoutIfNeeded()
        
//        guard let type = FilterCollectionViewType(rawValue: collectionView.tag) else { return }
        
        let itemCount = getItemCount()
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
            let text = getText(at: IndexPath(item: i, section: 0))
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
    }

    @IBAction func selectBtnTapped(_ sender: Any) {
        selectBtn.isHidden = true
        selectedBtn.isHidden = false
        continueBookingView.isHidden = false
    }
    
    @IBAction func selectedBtnTapped(_ sender: Any) {
        showQuantityPicker()
    }
    
    @IBAction func reserveBtnTapped(_ sender: Any) {
        if let listing = listing, let booking = booking, let roomId = room?.id{
            coordinator?.gotoConfirmBookingView(units: selectedQuantity, listing: listing, booking: booking, roomId: roomId)
        }
    }
    
    func calculateNights(from startDateString: String, to endDateString: String, format: String = "MM/dd/yyyy") -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        print("From: \(startDateString) - To: \(endDateString)")
        guard let startDate = dateFormatter.date(from: startDateString),
              let endDate = dateFormatter.date(from: endDateString) else {
            return nil
        }
        
        guard endDate > startDate else { return nil }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        
        return components.day
    }

    func showQuantityPicker() {
//        let room = room
        let maxQuantity = room?.quantity ?? 1 // Use room's quantity as max
        
        let alert = UIAlertController(title: "Select Quantity", message: "\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.tag = maxQuantity // Store max quantity in tag
        
        alert.view.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            picker.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            picker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 40),
            picker.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -40)
        ])
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
            let selectedRow = picker.selectedRow(inComponent: 0)
            self?.selectedQuantity = selectedRow + 1
//            self?.roomId = room.id
//            self?.continueBookingView.isHidden = false
            let title = "\(self?.selectedQuantity ?? 1) unit"
            self?.selectedBtn.setTitle(title, for: .normal)

            
            if let price = self?.room?.pricePerNight {
                let totalPrice = price * (Float(self?.selectedQuantity ?? 1))
                self?.BookingBtn.setTitle("Reserve for ₦ \(totalPrice.toAmount() ?? "0")", for: .normal)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }

}


extension RoomDetailsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 1:
            return amenities.count
        case 2:
            return comments.count
        default:
            return 0
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView.tag {
        case 1:
            let cell = facilitiesCollectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
            let cellAt = amenities[indexPath.item]
            
            let view = CatViewCell(frame: cell.bounds)
            view.identifier = "Facilities " + indexPath.description
            view.model.image = cellAt.icon ?? ""
            view.model.title = cellAt.name
            
            cell.applyView(view: view)
            return cell
            
        case 2:
            let cell = guestCommentsCollectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
            let cellAt = comments[indexPath.item]
            
            let view = CommentsViewCell(frame: cell.bounds)
            view.identifier = "GuestComments " + indexPath.description
            view.model.name = cellAt.user?.firstName ?? ""
            view.model.rating = "\(cellAt.rating)"
            view.model.comment = cellAt.note
            
            cell.applyView(view: view)
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
        case 1: // Facilities collection view
//            let text = getText(at: indexPath)
//            let width = calculateItemWidth(for: text)
//            return CGSize(width: width, height: 40)
            return CGSize(width: (collectionView.bounds.width / 4) - 5, height: 20)
        case 2: // Comments collection view
            return CGSize(width: (collectionView.bounds.width / 4) - 5, height: 20)
        default:
            return CGSize(width: 100, height: 40)
        }
    }
    
    
}

extension RoomDetailsView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView.tag // Use the tag which stores max quantity
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1) Unit"
    }
}

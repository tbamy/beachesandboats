//
//  RoomDetailsView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 06/01/2025.
//

import UIKit

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
    @IBOutlet weak var selectBtn: PlainOutlineButton!
    @IBOutlet weak var selectedBtn: PlainOutlineButton!
    @IBOutlet weak var BookingBtn: PrimaryButton!
    
    var room: BookingRoom?
    var listing: Listing?
    var booking: CreateBeachHouseBookingRequest?
    
    private var amenities: [Amenity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    func setup(){
        if let url = URL(string: room?.images?.first?.url?.replacingOccurrences(of: "http://", with: "https://") ?? "") {
            print("Image Url is: \(url)")
            topImage.kf.setImage(with: url)
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
        guestsLabel.text = "\(room?.noOfOccupant ?? 0) Guests"
        descriptionLabel.text = room?.description
        accessibilityContentLabel.text = "Easy accessibility"
        if let price = listing?.pricePerNight {
            totalAmountLabel.text = "₦ \(price)"
        }
        
        
        
        if let layout = facilitiesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 15
        }
        facilitiesCollectionView.delegate = self
        facilitiesCollectionView.dataSource = self
        facilitiesCollectionView.backgroundColor = .clear
        facilitiesCollectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        
        
        continueBookingView.isHidden = true
        if let price = room?.pricePerNight{
            BookingBtn.setTitle("Reserve for ₦ \(price ?? 0)", for: .normal)
        }
        
        
    }

    
    func calculateNights(from startDateString: String, to endDateString: String, format: String = "dd/MM/yyyy") -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        guard let startDate = dateFormatter.date(from: startDateString),
              let endDate = dateFormatter.date(from: endDateString) else {
            return nil
        }
        
        guard endDate > startDate else { return nil }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        
        return components.day
    }


}


extension RoomDetailsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return amenities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = facilitiesCollectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
        let cellAt = amenities[indexPath.item]
        
        let view = CatViewCell(frame: cell.bounds)
        view.identifier = "Facilities " + indexPath.description
        view.model.image = cellAt.icon ?? ""
        view.model.title = cellAt.name ?? ""
        
        cell.applyView(view: view)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width / 4) - 5, height: 20)
    }
    
    
}

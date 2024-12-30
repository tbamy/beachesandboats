//
//  BeachDetailsView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 23/12/2024.
//

import UIKit
import MapKit
import Kingfisher

class BeachDetailsView: BaseViewControllerPlain {
    
    var coordinator: ExploreCoordinator?
    
    
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var roomAndGuestsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var checkinDateLabel: HorizonDateField!
    @IBOutlet weak var checkoutDateLabel: HorizonDateField!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var guestCommentsCollectionView: UICollectionView!
    @IBOutlet weak var locationView: MKMapView!
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var aboutHostLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var continueBookingView: UIView!
    
    
    var beachDetails: Listing?
//    var beachBookingRequest: CreateBeachHouseBookingRequest?
    var amenities: [Amenity] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        configureAllCollectionViews()
        setupCustomNavigationButtons()
    }
    
    func setup(){
        if let url = URL(string: beachDetails?.rooms?.first?.images?.first?.url?.replacingOccurrences(of: "http://", with: "https://") ?? "") {
            print("Image Url is: \(url)")
            topImage.kf.setImage(with: url)
        }
        titleLabel.text = beachDetails?.name
        locationLabel.text = "\(beachDetails?.locations?.city ?? ""), \(beachDetails?.locations?.state ?? "") \(beachDetails?.locations?.country ?? "")"
        locationView.layer.cornerRadius = 8
        descriptionLabel.text = beachDetails?.description
        aboutHostLabel.text = beachDetails?.aboutOwner
        hostNameLabel.text = "\(beachDetails?.owner?.firstName ?? "") \(beachDetails?.owner?.lastName ?? "")"
        ratingLabel.text = "\(beachDetails?.rating ?? 0)"
        totalAmountLabel.text = "₦ \(beachDetails?.pricePerNight ?? 0)"
        let totalGuests = (beachDetails?.noOfAdults ?? 0) + (beachDetails?.noOfChildren ?? 0)
        roomAndGuestsLabel.text = "\(totalGuests) guests, \(beachDetails?.rooms?.count ?? 0) rooms"
        
        amenities = beachDetails?.amenities ?? []
        print(amenities)
        
    }
    
    func configureAllCollectionViews() {
        configureCollectionView(categoriesCollectionView, tag: 1)
//        configureCollectionView(guestCommentsCollectionView, tag: 2)
    }

    
    func configureCollectionView(_ collectionView: UICollectionView, tag: Int) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.tag = tag
        collectionView.backgroundColor = .clear
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
    }

    @IBAction func continueBookingTapped(_ sender: Any) {
        print("Continue Tapped")
        if let beachDetails = beachDetails{
            let beachBookingRequest = CreateBeachHouseBookingRequest(userId: "", beachHouseRoomId: "", checkingDate: checkinDateLabel.text, checkoutDate: checkoutDateLabel.text, checkingTime: "", checkoutTime: "", numberOfPeople: 0, amount: 0, units: 0)
            print(beachBookingRequest)
            
            coordinator?.gotoBookingRoomsListView(listing: beachDetails, booking: beachBookingRequest)
        }
        
    }
    
}

extension BeachDetailsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return amenities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
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


extension BeachDetailsView {
    func setupCustomNavigationButtons() {
        
        let addButton = UIButton(type: .custom)
        addButton.setImage(Assets.backButton.image, for: .normal)
        addButton.addTarget(self, action: #selector(addNewBtnTapped), for: .touchUpInside)
        let addBarButtonItem = UIBarButtonItem(customView: addButton)

        let settingsButton = UIButton(type: .custom)
        settingsButton.setImage(Assets.backButton .image, for: .normal)
        settingsButton.addTarget(self, action: #selector(settingsBtnTapped), for: .touchUpInside)
        let settingsBarButtonItem = UIBarButtonItem(customView: settingsButton)

        navigationItem.rightBarButtonItems = [addBarButtonItem, settingsBarButtonItem]
    }

    // Actions for the buttons
    @objc func addNewBtnTapped() {
        print("Add button tapped")
    }

    @objc func settingsBtnTapped() {
        print("Settings button tapped")
    }


}

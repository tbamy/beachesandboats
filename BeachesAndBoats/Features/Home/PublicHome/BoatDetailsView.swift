//
//  BoatDetailsView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 26/12/2024.
//

import UIKit
import MapKit

class BoatDetailsView: BaseViewControllerPlain {
    
    var coordinator: ExploreCoordinator?
    
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var peopleCapacityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var startingLocationLabel: UILabel!
    @IBOutlet weak var bookingDateLabel: DatePicker!
    @IBOutlet weak var bookingTimeLabel: TimePicker!
    @IBOutlet weak var numberOfPeopleLabel: DropDown!
    @IBOutlet weak var cruiseLengthLabel: DropDown!
    @IBOutlet weak var cruiseLengthStack: UIStackView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var guestCommentsCollectionView: UICollectionView!
    @IBOutlet weak var locationView: MKMapView!
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var aboutHostLabel: UILabel!
//    @IBOutlet weak var beachHouseCollectionView: UICollectionView!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var cruisingOption: CheckboxButton!
    @IBOutlet weak var travelDestinationOption: CheckboxButton!
    @IBOutlet weak var myDestinationStack: UIStackView!
    @IBOutlet weak var myDestinationDropdown: DropDown!
    
    
    
    var boatDetails: Listing?
    
    var amenities: [Amenity] = []
    var roomImages: [String] = []
    var destinations: [Destinations] = []
    var pickerItems: [PickerItem] = []
    
    var numberOfPeoplePickerItems: [PickerItem] = []
    var cruiseLengthPickerItems: [PickerItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        configureAllCollectionViews()
        setupCustomNavigationButtons()
        
    }
    
    func setup(){
        if let url = URL(string: boatDetails?.rooms?.first?.images?.first?.url?.replacingOccurrences(of: "http://", with: "https://") ?? "") {
            print("Image Url is: \(url)")
            topImage.kf.setImage(with: url)
        }
        titleLabel.text = boatDetails?.name
        locationLabel.text = "\(boatDetails?.locations?.city ?? ""), \(boatDetails?.locations?.state ?? "") \(boatDetails?.locations?.country ?? "")"
        locationView.layer.cornerRadius = 8
        descriptionLabel.text = boatDetails?.description
        aboutHostLabel.text = boatDetails?.aboutOwner
        hostNameLabel.text = "\(boatDetails?.owner?.firstName ?? "") \(boatDetails?.owner?.lastName ?? "")"
        ratingLabel.text = "\(boatDetails?.rating ?? 0)"
        totalAmountLabel.text = "₦ \(boatDetails?.pricePerNight ?? 0)"
        peopleCapacityLabel.text = "1 - \((boatDetails?.noOfAdults ?? 0) + (boatDetails?.noOfChildren ?? 0)) "
        
        amenities = boatDetails?.amenities ?? []
        destinations = boatDetails?.destinations ?? []
        pickerItems = destinations.compactMap{ destination in
                guard let id = destination.id, let name = destination.name else {
                    return nil
                }
                return PickerItem(name: name, value: id)
        }
        myDestinationDropdown.items = pickerItems
        
        numberOfPeoplePickerItems = (1...10).map { PickerItem(name: "\($0)", value: "\($0)") }
        cruiseLengthPickerItems = (1...10).map { PickerItem(name: "\($0)", value: "\($0)") }
        
        numberOfPeopleLabel.items = numberOfPeoplePickerItems
        cruiseLengthLabel.items = cruiseLengthPickerItems
                
        

        
        topImage.isUserInteractionEnabled = true
        topImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewImages)))
        
    }
    
    func configureAllCollectionViews() {
        configureCollectionView(categoriesCollectionView, tag: 1)
        configureCollectionView(guestCommentsCollectionView, tag: 2)
    }

    
    func configureCollectionView(_ collectionView: UICollectionView, tag: Int) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.tag = tag
        collectionView.backgroundColor = .clear
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
    }

    @objc func viewImages(){
        
        if let rooms = boatDetails?.rooms{
            roomImages = rooms.compactMap { $0.images }
                .flatMap { $0 }
                .compactMap { $0.url }
            coordinator?.gotoAllPhotos(images: roomImages)
        }
        
    }

}

extension BoatDetailsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 1:
            return amenities.count
        case 2:
            return amenities.count
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 1:
            let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
            let cellAt = amenities[indexPath.item]
            
            let view = CategoriesCell(frame: cell.bounds)
            view.identifier = "Amenitiess " + indexPath.description
            view.model.image = cellAt.icon ?? ""
            view.model.title = cellAt.name ?? ""
            view.isSubcategory = true
            
            cell.applyView(view: view)
            return cell
        case 2:
            let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
            let cellAt = amenities[indexPath.item]
            
            let view = CategoriesCell(frame: cell.bounds)
            view.identifier = "Amenitiess " + indexPath.description
            view.model.image = cellAt.icon ?? ""
            view.model.title = cellAt.name ?? ""
            view.isSubcategory = true
            
            cell.applyView(view: view)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
        case 1:
            return CGSize(width: (collectionView.bounds.width / 6), height: 50)
        case 2:
            return CGSize(width: (collectionView.bounds.width / 6), height: 50)
        default:
            return CGSize()
        }
    }
    
    
}



extension BoatDetailsView {
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

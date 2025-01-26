//
//  ListingDashboard.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/10/2024.
//


import UIKit
import RxSwift

class ListingDashboard: UIViewController {
    
    @IBOutlet weak var checkOutNoDataImg: UIImageView!
    @IBOutlet weak var checkOutCollectionView: UICollectionView!
    @IBOutlet weak var currentHostingNoDataImg: UIImageView!
    @IBOutlet weak var currentHostingCollectionView: UICollectionView!
    @IBOutlet weak var upcomingNoDataImg: UIImageView!
    @IBOutlet weak var upcomingCollectionView: UICollectionView!
    @IBOutlet weak var cancelBookingNoDataImg: UIImageView!
    @IBOutlet weak var cancelBookingCollectionView: UICollectionView!
    @IBOutlet var images: [UIImageView]!
    @IBOutlet weak var currentEarningYearLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var listingLbl: UILabel!
    @IBOutlet weak var beachReservation: SegmentOptionView!
    @IBOutlet weak var boatReservation: SegmentOptionView!
    @IBOutlet weak var checkingOutLbl: UILabel!
    @IBOutlet weak var currentHostingLbl: UILabel!
    @IBOutlet weak var upcomingLbl: UILabel!
    @IBOutlet weak var cancelLbl: UILabel!
    @IBOutlet weak var houseListing: UIStackView!
    @IBOutlet weak var boatListing: UILabel!
    @IBOutlet weak var notificationImg: UIImageView!
    
    var coordinator: HostingHouseAndBoatHomeCoordinator?
    
    let vm = ListingDashboardVM()
    let disposeBag = DisposeBag()
    let input = PublishSubject<ListingDashboardVM.Input>()
    
    var currentHostingData: [BeachHouseReservationsCurrentReservation] = []
    var cancelBookingData: [BeachHouseReservationsCurrentReservation] = []
    
    var boatHostingData: [BoatReservationsCurrentReservation] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        input.onNext(.beachHouseReservation)
        input.onNext(.boatReservation)
        LoadingModal.show(title: "Loading...")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageDesign()
        bind()
        collectionViewSetup()
        setupUI()
    }
    
    func setupUI() {
        
        let listingText = listingLbl.text ?? ""
        let attributedListingText = NSAttributedString(
            string: listingText,
            attributes: [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .underlineColor: UIColor.white.cgColor
            ]
        )
        listingLbl.attributedText = attributedListingText

        let boatText = boatListing.text ?? ""
        let attributedBoatText = NSAttributedString(
            string: boatText,
            attributes: [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .underlineColor: UIColor.white.cgColor
            ]
        )
        boatListing.attributedText = attributedBoatText

        
        if currentHostingData.isEmpty && boatHostingData.isEmpty {
            listingLbl.text  = "My Listing (0)"
            boatListing.isHidden = true
        } else if currentHostingData.isEmpty && !boatHostingData.isEmpty {
            boatListing.isHidden = false
            listingLbl.text = "My Listing (0)"
        } else if !currentHostingData.isEmpty && !boatHostingData.isEmpty {
            listingLbl.text = "My house listing (\(currentHostingData.count))"
            boatListing.text = "My boat listing (\(boatHostingData.count))"
            houseListing.isHidden = false
        }
    }
    
    func collectionViewSetup() {
        setupCollectionView(checkOutCollectionView, tag: 1)
        setupCollectionView(currentHostingCollectionView, tag: 2)
        setupCollectionView(upcomingCollectionView, tag: 3)
        setupCollectionView(cancelBookingCollectionView, tag: 4)
    }
    
    private func setupCollectionView(_ collectionView: UICollectionView, tag: Int) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "HostingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HostingCollectionViewCell")
        collectionView.tag = tag
    }
    
    @IBAction func checkingOutViewAll(_ sender: Any) {
    }
    
    @IBAction func currentHostingViewAll(_ sender: Any) {
    }
    
    @IBAction func upcomingViewAll(_ sender: Any) {
    }
    
    @IBAction func cancelBookingViewAll(_ sender: Any) {
    }
    
    func imageDesign() {
        for image in images {
            image.layer.cornerRadius = 20
        }
    }
    
    func checkOutNoData() {
        checkOutNoDataImg.subviews.forEach { $0.removeFromSuperview() }
        
        let noLabel = UILabel()
        let noImage = UIImageView()
        
        noLabel.text = "You don't have any check-outs soon"
        noImage.image = UIImage(named: "noDataIcon")
        
        checkOutNoDataImg.addSubview(noLabel)
        checkOutNoDataImg.addSubview(noImage)
        noLabel.translatesAutoresizingMaskIntoConstraints = false
        noImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noImage.centerXAnchor.constraint(equalTo: checkOutNoDataImg.centerXAnchor),
            noImage.centerYAnchor.constraint(equalTo: checkOutNoDataImg.centerYAnchor, constant: -15),
            noLabel.topAnchor.constraint(equalTo: noImage.bottomAnchor, constant: 10),
            noLabel.leadingAnchor.constraint(equalTo: checkOutNoDataImg.leadingAnchor, constant: 30),
            noLabel.trailingAnchor.constraint(equalTo: checkOutNoDataImg.trailingAnchor, constant: -30)
        ])
    }
    
    func currentHostingNoData() {
        currentHostingNoDataImg.subviews.forEach { $0.removeFromSuperview() }
        
        let noLabel = UILabel()
        let noImage = UIImageView()
        
        noLabel.text = "You don't have any current hostings"
        noImage.image = UIImage(named: "noDataIcon")
        
        currentHostingNoDataImg.addSubview(noLabel)
        currentHostingNoDataImg.addSubview(noImage)
        noLabel.translatesAutoresizingMaskIntoConstraints = false
        noImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noImage.centerXAnchor.constraint(equalTo: currentHostingNoDataImg.centerXAnchor),
            noImage.centerYAnchor.constraint(equalTo: currentHostingNoDataImg.centerYAnchor, constant: -15),
            noLabel.topAnchor.constraint(equalTo: noImage.bottomAnchor, constant: 10),
            noLabel.leadingAnchor.constraint(equalTo: currentHostingNoDataImg.leadingAnchor, constant: 30),
            noLabel.trailingAnchor.constraint(equalTo: currentHostingNoDataImg.trailingAnchor, constant: -30)
        ])
    }
    
    func upcomingNoData() {
        upcomingNoDataImg.subviews.forEach { $0.removeFromSuperview() }
        
        let noLabel = UILabel()
        let noImage = UIImageView()
        
        noLabel.text = "You don't have any upcoming bookings"
        noImage.image = UIImage(named: "noDataIcon")
        
        upcomingNoDataImg.addSubview(noLabel)
        upcomingNoDataImg.addSubview(noImage)
        noLabel.translatesAutoresizingMaskIntoConstraints = false
        noImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noImage.centerXAnchor.constraint(equalTo: upcomingNoDataImg.centerXAnchor),
            noImage.centerYAnchor.constraint(equalTo: upcomingNoDataImg.centerYAnchor, constant: -15),
            noLabel.topAnchor.constraint(equalTo: noImage.bottomAnchor, constant: 10),
            noLabel.leadingAnchor.constraint(equalTo: upcomingNoDataImg.leadingAnchor, constant: 30),
            noLabel.trailingAnchor.constraint(equalTo: upcomingNoDataImg.trailingAnchor, constant: -30)
        ])
    }
    
    func cancelBookingNoData() {
        cancelBookingNoDataImg.subviews.forEach { $0.removeFromSuperview() }
        
        let noLabel = UILabel()
        let noImage = UIImageView()
        
        noLabel.text = "You don't have any cancelled bookings"
        noImage.image = UIImage(named: "noDataIcon")
        
        cancelBookingNoDataImg.addSubview(noLabel)
        cancelBookingNoDataImg.addSubview(noImage)
        noLabel.translatesAutoresizingMaskIntoConstraints = false
        noImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noImage.centerXAnchor.constraint(equalTo: cancelBookingNoDataImg.centerXAnchor),
            noImage.centerYAnchor.constraint(equalTo: cancelBookingNoDataImg.centerYAnchor, constant: -15),
            noLabel.topAnchor.constraint(equalTo: noImage.bottomAnchor, constant: 10),
            noLabel.leadingAnchor.constraint(equalTo: cancelBookingNoDataImg.leadingAnchor, constant: 30),
            noLabel.trailingAnchor.constraint(equalTo: cancelBookingNoDataImg.trailingAnchor, constant: -30)
        ])
    }
}

// MARK: - Binding
extension ListingDashboard {
    func bind() {
        vm.transform(input: input)
        vm.output.subscribe(onNext: { [weak self] output in
            LoadingModal.dismiss()
            switch output {
            case .beachHouseReservationSuccess(let response):
                self?.currentHostingData = response.currentReservations ?? []
                self?.currentHostingCollectionView.reloadData()
                self?.upcomingCollectionView.reloadData()
                self?.cancelBookingCollectionView.reloadData()
            case .beachHouseReservationFailure(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            case .boatReservationSuccess(let response):
                print("Success")
            case .boatReservationFailure(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
        }).disposed(by: disposeBag)
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension ListingDashboard: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 1:
            checkOutNoDataImg.isHidden = false
            checkOutCollectionView.isHidden = true
            checkOutNoData()
            return 0
            
        case 2:
            if currentHostingData.isEmpty {
                currentHostingNoDataImg.isHidden = false
                currentHostingCollectionView.isHidden = true
                currentHostingNoData()
                return 0
            }
            currentHostingNoDataImg.isHidden = true
            currentHostingCollectionView.isHidden = false
            return currentHostingData.count
            
        case 3:
            if currentHostingData.isEmpty {
                upcomingNoDataImg.isHidden = false
                upcomingCollectionView.isHidden = true
                upcomingNoData()
                return 0
            }
            upcomingNoDataImg.isHidden = true
            upcomingCollectionView.isHidden = false
            return currentHostingData.count
            
        case 4:
            if cancelBookingData.isEmpty {
                cancelBookingNoDataImg.isHidden = false
                cancelBookingCollectionView.isHidden = true
                cancelBookingNoData()
                return 0
            }
            cancelBookingNoDataImg.isHidden = true
            cancelBookingCollectionView.isHidden = false
            return cancelBookingData.count
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HostingCollectionViewCell", for: indexPath) as? HostingCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        switch collectionView.tag {
        case 2:
            let cellData = currentHostingData[indexPath.item]
            cell.currentHostingCell(with: cellData)
        case 3:
            let cellData = currentHostingData[indexPath.item]
            cell.upcomingHostingCell(with: cellData)
        case 4:
            let cellData = cancelBookingData[indexPath.item]
            cell.cancelledBookingCell(with: cellData)
        default:
            break
        }
        
        return cell
    }
}

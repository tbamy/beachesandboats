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
    @IBOutlet weak var userName: UILabel!
    
    var coordinator: HostingHouseAndBoatHomeCoordinator?
    
    let vm = ListingDashboardVM()
    let earningsVM = EarningsVM()
    let disposeBag = DisposeBag()
    let input = PublishSubject<ListingDashboardVM.Input>()
    let earningsInput = PublishSubject<EarningsVM.Input>()

    
    var currentHostingData: [BeachHouseReservationsCurrentReservation] = []
    var cancelBookingData: [BeachHouseReservationsCurrentReservation] = []
    var upcomingReservationData: [BeachHouseReservationsCurrentReservation] = []
    var beachHouseCount: Int = 0
    var boatHouseCount: Int = 0
    
    var boatCancelBookingData: [BoatReservationsCurrentReservation] = []
    var boatUpcomingReservationData: [BoatReservationsCurrentReservation] = []
    var boatHostingData: [BoatReservationsCurrentReservation] = []
    
    private var isBeachReservation = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        input.onNext(.beachHouseReservation)
        input.onNext(.boatReservation)
        
//        let earningsRequest = year: selectedYear, month: getSelectedMonth
//        earningsInput.onNext(.topEarnings(earningsRequest))
        
        LoadingModal.show(title: "Loading...")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageDesign()
        bind()
        collectionViewSetup()
//        setupUI()
        gestureRecognizer()
        isBeachReservation = true
        userName.text = "Welcome, " + (UserSession.shared.userDetails?.first_name ?? "User")
        beachReservation.contentView.backgroundColor = .none
        boatReservation.contentView.backgroundColor = .none
    }
   
    func gestureRecognizer() {
        let beachSelected = UITapGestureRecognizer(target: self, action: #selector(beachReservationSelected))
        beachReservation.isUserInteractionEnabled = true
        beachReservation.addGestureRecognizer(beachSelected)
        
        let boatSelected = UITapGestureRecognizer(target: self, action: #selector(boatReservationSelected))
        boatReservation.isUserInteractionEnabled = true
        boatReservation.addGestureRecognizer(boatSelected)
    }

    private func updateSegmentSelection() {
        if isBeachReservation {
            beachReservation.isSelected = true
            boatReservation.isSelected = false
            self.upcomingLbl.text = "Upcoming (\(self.upcomingReservationData.count))"
            self.currentHostingLbl.text = "Current hosting (\(self.currentHostingData.count))"
            self.cancelLbl.text = "Cancelled booking (\(self.cancelBookingData.count))"
        } else {
            beachReservation.isSelected = false
            boatReservation.isSelected = true
            self.upcomingLbl.text = "Upcoming boat (\(self.boatUpcomingReservationData.count))"
            self.currentHostingLbl.text = "Current hosting (\(self.boatHostingData.count))"
            self.cancelLbl.text = "Cancelled booking (\(self.boatCancelBookingData.count))"
        }

        checkOutCollectionView.reloadData()
        currentHostingCollectionView.reloadData()
        upcomingCollectionView.reloadData()
        cancelBookingCollectionView.reloadData()
    }
    
    @objc func beachReservationSelected() {
        isBeachReservation = true
        updateSegmentSelection()
    }
    
    @objc func boatReservationSelected() {
        isBeachReservation = false
        updateSegmentSelection()
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
        
        if beachHouseCount <= 0 && boatHouseCount <= 0 {
            listingLbl.text  = "My Listings (0)"
            boatListing.isHidden = true
        } else if beachHouseCount <= 0 && boatHouseCount > 0 {
            boatListing.isHidden = false
            listingLbl.text = "My House Listings (\(beachHouseCount))"
            boatListing.text = "My Boat Listings (\(boatHouseCount))"
            boatListing.isHidden = false
        } else if beachHouseCount > 0 && boatHouseCount <= 0 {
            listingLbl.text = "My House Listings (\(beachHouseCount))"
            boatListing.text = "My Boat Listings (\(boatHouseCount))"
            boatListing.isHidden = false
        } else if beachHouseCount > 0 && boatHouseCount > 0 {
            listingLbl.text = "My House Listings (\(beachHouseCount))"
            boatListing.text = "My Boat Listings (\(boatHouseCount))"
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
    
    private func handleTopEarningsSuccess(_ response: TopEarningResponse) {
        // Update UI with earnings data
        if let amount = response.data?.topEarners, let earningAmount = amount.first {
            amountLbl.text = "\(earningAmount.value.totalEarnings ?? 0.00)"
        }
        if let year = response.data?.userEarnings.keys.first {
            currentEarningYearLbl.text = "Current Earning \(year)"
        } else {
            currentEarningYearLbl.text = "Current Earning"
        }

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
                self?.upcomingReservationData = response.upcomingReservations ?? []
                self?.updateSegmentSelection()
                self?.currentHostingCollectionView.reloadData()
                self?.upcomingCollectionView.reloadData()
                self?.cancelBookingCollectionView.reloadData()
                self?.beachHouseCount = (self?.currentHostingData.count ?? 0) + (self?.upcomingReservationData.count ?? 0)
                self?.setupUI()
                
            case .beachHouseReservationFailure(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            case .boatReservationSuccess(let response):
                self?.boatHostingData = response.currentReservations ?? []
                self?.boatUpcomingReservationData = response.upcomingReservations ?? []
                self?.updateSegmentSelection()
                self?.currentHostingCollectionView.reloadData()
                self?.upcomingCollectionView.reloadData()
                self?.cancelBookingCollectionView.reloadData()
                self?.boatHouseCount = (self?.boatHostingData.count ?? 0) + (self?.boatUpcomingReservationData.count ?? 0)
                self?.setupUI()
            case .boatReservationFailure(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
        }).disposed(by: disposeBag)
        
        earningsVM.transform(input: earningsInput)
        earningsVM.output.subscribe(onNext: { [weak self] output in
            LoadingModal.dismiss()
            switch output {
            case .topEarningsSuccess(let response):
                // Handle earnings success
                self?.handleTopEarningsSuccess(response)
            case .topEarningsFailure(let error):
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
            if isBeachReservation {
                if currentHostingData.isEmpty  {
                    currentHostingNoDataImg.isHidden = false
                    currentHostingCollectionView.isHidden = true
                    currentHostingNoData()
                    return 0
                }
            } else {
                if boatHostingData.isEmpty  {
                    currentHostingNoDataImg.isHidden = false
                    currentHostingCollectionView.isHidden = true
                    currentHostingNoData()
                    return 0
                }
            }
            currentHostingNoDataImg.isHidden = true
            currentHostingCollectionView.isHidden = false
            return isBeachReservation ? currentHostingData.count : boatHostingData.count
            
        case 3:
            if isBeachReservation {
                if upcomingReservationData.isEmpty {
                    upcomingNoDataImg.isHidden = false
                    upcomingCollectionView.isHidden = true
                    upcomingNoData()
                    return 0
                }
            } else {
                if boatUpcomingReservationData.isEmpty {
                    upcomingNoDataImg.isHidden = false
                    upcomingCollectionView.isHidden = true
                    upcomingNoData()
                    return 0
                }
            }
            upcomingNoDataImg.isHidden = true
            upcomingCollectionView.isHidden = false
            return isBeachReservation ? upcomingReservationData.count : boatUpcomingReservationData.count
            
        case 4:
            if isBeachReservation {
                if cancelBookingData.isEmpty {
                    cancelBookingNoDataImg.isHidden = false
                    cancelBookingCollectionView.isHidden = true
                    cancelBookingNoData()
                    return 0
                }
            } else {
                if boatCancelBookingData.isEmpty {
                    cancelBookingNoDataImg.isHidden = false
                    cancelBookingCollectionView.isHidden = true
                    cancelBookingNoData()
                    return 0
                }
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
            if isBeachReservation {
                let cellData = currentHostingData[indexPath.item]
                cell.currentHostingCell(with: cellData)
            } else {
                let cellData = boatHostingData[indexPath.item]
                cell.boatCurrentHostingCell(with: cellData)
            }
           
        case 3:
            let cellData = upcomingReservationData[indexPath.item]
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

extension ListingDashboard: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width
        let height: CGFloat = 310
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        .init(top: 5, left: 10, bottom: 5, right: 10)
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0
        )
    }
}

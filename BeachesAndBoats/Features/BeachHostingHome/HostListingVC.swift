//
//  HostListingVC.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 10/01/2025.
//

import UIKit
import RxSwift

class HostListingVC: BaseViewControllerPlain {
    
    @IBOutlet weak var searchField: SearchField!
    @IBOutlet weak var beachHouseListingSegment: SegmentOptionView!
    @IBOutlet weak var boatListingSegment: SegmentOptionView!
//    @IBOutlet weak var listingCollectionView: UICollectionView!
    @IBOutlet weak var listingTableView: UITableView!
    @IBOutlet weak var inProgressViewContainer: UIView!
    @IBOutlet weak var unfinishedListingName: UILabel!
    @IBOutlet weak var unfinishedListingLocation: UILabel!
    @IBOutlet weak var unfinishedListingStack: UIStackView!
    @IBOutlet weak var viewContainerHeightConstraint: NSLayoutConstraint!
    var coordinator: HostingHouseAndBoatListingCoordinator?
    
    let vm = HostListingVM()
    let disposeBag = DisposeBag()
    let input = PublishSubject<HostListingVM.Input>()
    
    var beachHouseListingData: [BeachHouseListing] = []
    var boatListingData: [BoatListing] = []
    
    private var isShowingBeachHouses = true
//    private var getUnfinishedResponse = String? = ""

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        input.onNext(.beachHouseListing)
        LoadingModal.show(title: "Getting Listings...")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableSetup()
        title = "Listings"
        bind()
        setupRightNavigationBar()
        gestureRecognizers()
//        isShowingBeachHouses = true
        beachHouseListingSegment.contentView.backgroundColor = .none
        boatListingSegment.contentView.backgroundColor = .none
        unfinishedListingStack.isHidden = true
    }
    
    func gestureRecognizers() {
        let beachHouse = UITapGestureRecognizer(target: self, action: #selector(beachHouseTapped))
        beachHouseListingSegment.isUserInteractionEnabled = true
        beachHouseListingSegment.addGestureRecognizer(beachHouse)
        
        let boat = UITapGestureRecognizer(target: self, action: #selector(boatTapped))
        boatListingSegment.isUserInteractionEnabled = true
        boatListingSegment.addGestureRecognizer(boat)
        
        let unfinishStack = UITapGestureRecognizer(target: self, action: #selector(unfinishedStackTapped))
        unfinishedListingStack.isUserInteractionEnabled = true
        unfinishedListingStack.addGestureRecognizer(unfinishStack)
    }
    
    @objc func unfinishedStackTapped() {
        self.showUnfinishedListingModal(
            listingName: "Gil House",
            listingLocation: "Ikoyi",
            showDeleteStack: false,
            buttonOneTitle: "Continue Listing",
            buttonOneAction: { [self] in
                print("Continue")
            },
            buttonTwoTitle: "Delete Listing",
            buttonTwoAction: {
                self.showDeleteModal()
                print("Cancel button tapped!")
            }
        )
    }

    func showDeleteModal() {
        self.showUnfinishedListingModal(
            listingName: "Gil House",
            listingLocation: "Ikoyi",
            showDeleteStack: true,
            buttonOneTitle: "Yes, delete",
            buttonOneAction: { [self] in
                deleteListing()
            },
            buttonTwoTitle: "Cancel",
            buttonTwoAction: {
                self.dismiss(animated: true)
                print("Cancel button tapped!")
            }
        )
    }
    
    func deleteListing() {
        if isShowingBeachHouses {
            AppStorage.beachListing = nil
            showListingForBeaches()
        } else {
            AppStorage.boatListing = nil
            showListingForBoats()
        }
        self.dismiss(animated: true)
    }
    
    @objc func beachHouseTapped() {
        isShowingBeachHouses = true
        updateSelection()
    }
    
    @objc func boatTapped() {
        isShowingBeachHouses = false
        updateSelection()
    }
    
    func showListingForBeaches() {
        if let unfinishedBeachListing = AppStorage.beachListing {
            unfinishedListingStack.isHidden = false
            unfinishedListingName.text = unfinishedBeachListing.name
            unfinishedListingLocation.text = unfinishedBeachListing.streetName + ", " + unfinishedBeachListing.state + unfinishedBeachListing.country
        } else {
            unfinishedListingStack.isHidden = true
        }
    }
    
    func showListingForBoats() {
        if let unfinishedBoatListing = AppStorage.boatListing {
            unfinishedListingStack.isHidden = false
            unfinishedListingName.text = unfinishedBoatListing.name
            unfinishedListingLocation.text = unfinishedBoatListing.streetName + ", " + unfinishedBoatListing.state + " " + unfinishedBoatListing.country
        } else {
            unfinishedListingStack.isHidden = true
        }
    }
    
    private func updateSelection() {
        if isShowingBeachHouses {
            beachHouseListingSegment.isSelected = true
            boatListingSegment.isSelected = false
            showListingForBeaches()
        } else {
            beachHouseListingSegment.isSelected = false
            boatListingSegment.isSelected = true
            showListingForBoats()
        }
        listingTableView.reloadData()
        self.updateTableHeight()
    }
    
    func setupRightNavigationBar() {
        let rightButton = UIBarButtonItem(image: UIImage(named: "sort_icon")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(sortTapped))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc func sortTapped() {
        coordinator?.presentSortView()
    }
    
    
    func tableSetup() {
        listingTableView.delegate = self
        listingTableView.dataSource = self
        listingTableView.register(UINib(nibName: "HostListingTableView", bundle: nil), forCellReuseIdentifier: "HostListingTableView")
        listingTableView.separatorStyle = .none
 
        searchField.duration.isHidden = true
        
    }
    
    private func updateTableHeight() {
        listingTableView.layoutIfNeeded()
        let contentHeight = listingTableView.contentSize.height
        viewContainerHeightConstraint.constant = contentHeight + 350
        view.layoutIfNeeded()
    }
}

//MARK: - Binding
extension HostListingVC {
    func bind() {
        vm.transform(input: input)
        vm.output.subscribe(onNext: { [weak self] output in
            LoadingModal.dismiss()
            switch output {
            case .beachHouseListingSuccess(let response):
                if let listings = response.data?.beachHouseListings {
                    self?.beachHouseListingData = listings
                    self?.beachHouseListingSegment.title = "Beach Houses Reservation (\(self?.beachHouseListingData.count ?? 0))"
                    self?.listingTableView.reloadData()
                    self?.updateTableHeight()
                }
                if let boatListings = response.data?.boatListings {
                    self?.boatListingData = boatListings
                    self?.boatListingSegment.title = "Boats Reservation (\(self?.boatListingData.count ?? 0))"
                    self?.listingTableView.reloadData()
                    self?.updateTableHeight()
                }
                self?.updateSelection()
            case .beachHouseListingFailure(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
        }).disposed(by: disposeBag)
    }
}

//MARK: - CollectionView Delegate
extension HostListingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isShowingBeachHouses ? beachHouseListingData.count : boatListingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HostListingTableView", for: indexPath) as! HostListingTableView
        if isShowingBeachHouses {
            let cellAt = beachHouseListingData[indexPath.row]
            cell.beachHouseListingCell(with: cellAt)
        } else {
            let cellAt = boatListingData[indexPath.row]
            cell.boatListingCell(with: cellAt)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            // Get actual content height
            tableView.layoutIfNeeded()
            let contentHeight = tableView.contentSize.height
            
            // Add height of UIView (300) + margins (50)
            let totalHeight = contentHeight + 350
            
            viewContainerHeightConstraint.constant = totalHeight
            view.layoutIfNeeded()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
    }
}

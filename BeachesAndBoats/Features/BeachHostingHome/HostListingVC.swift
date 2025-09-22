//
//  HostListingVC.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 10/01/2025.
//

import UIKit
import RxSwift

class HostListingVC: BaseViewControllerPlain, UITextFieldDelegate {
    
    @IBOutlet weak var searchField: InputField!
    @IBOutlet weak var beachHouseListingSegment: SegmentOptionView!
    @IBOutlet weak var boatListingSegment: SegmentOptionView!
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
    
    var filteredBeachHouseListingData: [BeachHouseListing] = []
    var filteredBoatListingData: [BoatListing] = []
    
    private var isShowingBeachHouses = true
    private var searchTimer: Timer? // For debouncing
    
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
        beachHouseListingSegment.contentView.backgroundColor = .none
        boatListingSegment.contentView.backgroundColor = .none
        unfinishedListingStack.isHidden = true
        
        // Configure search field
        searchField.placeHolder = "Search by name or location"
        searchField.textField.clearButtonMode = .whileEditing
        searchField.noSpecialCharacters = false // Allow special characters; adjust if needed
        searchField.textField.delegate = self // Set delegate for text field
        
        // Initialize filtered data
        filteredBeachHouseListingData = beachHouseListingData
        filteredBoatListingData = boatListingData
    }
    
    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Debounce search input (similar to RxCocoa's .debounce(.milliseconds(300)))
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
            let query = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            self?.filterListings(with: query)
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // Handle clear button tap
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
            self?.filterListings(with: "")
        }
        return true
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
        if let unfinishedBeachListing = AppStorage.beachListing {
            self.showUnfinishedListingModal(
                listingName: unfinishedBeachListing.name ?? "Unnamed",
                listingLocation: "\(unfinishedBeachListing.jettyLocation ?? ""), \(unfinishedBeachListing.locationName ?? "")",
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
        } else if let unfinishedBoatListing = AppStorage.boatListing {
            self.showUnfinishedListingModal(
                listingName: unfinishedBoatListing.name ?? "Unnamed",
                listingLocation: "\(unfinishedBoatListing.jettyLocation ?? ""), \(unfinishedBoatListing.locationName ?? "")",
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
    }

    func showDeleteModal() {
        if let unfinishedBeachListing = AppStorage.beachListing {
            self.showUnfinishedListingModal(
                listingName: unfinishedBeachListing.name ?? "Unnamed",
                listingLocation: "\(unfinishedBeachListing.jettyLocation ?? ""), \(unfinishedBeachListing.locationName ?? "")",
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
        } else if let unfinishedBoatListing = AppStorage.boatListing {
            self.showUnfinishedListingModal(
                listingName: unfinishedBoatListing.name ?? "Unnamed",
                listingLocation: "\(unfinishedBoatListing.jettyLocation ?? ""), \(unfinishedBoatListing.locationName ?? "")",
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
    }
    
    func deleteListing() {
        if isShowingBeachHouses {
            AppStorage.beachListing = nil
            MiddleModal.show(title: "Successfully Deleted!", type: .success, onConfirm: {self.showListingForBeaches()})
        } else {
            AppStorage.boatListing = nil
            MiddleModal.show(title: "Successfully Deleted!", type: .success, onConfirm: {self.showListingForBoats()})
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
            unfinishedListingLocation.text = (unfinishedBeachListing.jettyLocation ?? "") + ", " + (unfinishedBeachListing.locationName ?? "")
        } else {
            unfinishedListingStack.isHidden = true
        }
    }
    
    func showListingForBoats() {
        if let unfinishedBoatListing = AppStorage.boatListing {
            unfinishedListingStack.isHidden = false
            unfinishedListingName.text = unfinishedBoatListing.name
            unfinishedListingLocation.text = (unfinishedBoatListing.jettyLocation ?? "") + ", " + (unfinishedBoatListing.locationName ?? "")
        } else {
            unfinishedListingStack.isHidden = true
        }
    }
    
    private func updateSelection() {
        if isShowingBeachHouses {
            beachHouseListingSegment.isNotSelected = true
            boatListingSegment.isNotSelected = false
            showListingForBeaches()
        } else {
            beachHouseListingSegment.isNotSelected = false
            boatListingSegment.isNotSelected = true
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
    }
    
    private func updateTableHeight() {
        listingTableView.layoutIfNeeded()
        let contentHeight = listingTableView.contentSize.height
        viewContainerHeightConstraint.constant = contentHeight + 350
        view.layoutIfNeeded()
        
        // Show empty state if no results
        if (isShowingBeachHouses && filteredBeachHouseListingData.isEmpty) ||
           (!isShowingBeachHouses && filteredBoatListingData.isEmpty) {
            listingTableView.isHidden = true
            // Optionally add a UILabel or UIView to show "No results found"
        } else {
            listingTableView.isHidden = false
        }
    }
    
    private func filterListings(with query: String) {
        if query.isEmpty {
            // Reset to full dataset if query is empty
            filteredBeachHouseListingData = beachHouseListingData
            filteredBoatListingData = boatListingData
        } else {
            // Filter beach houses based on name or location
            filteredBeachHouseListingData = beachHouseListingData.filter { listing in
                let nameMatch = listing.name?.lowercased().contains(query.lowercased()) ?? false
                let locationMatch = listing.locations?.name?.lowercased().contains(query.lowercased()) ?? false
                let jettyLocationMatch = listing.locations?.jettyLocation?.lowercased().contains(query.lowercased()) ?? false
                return nameMatch || locationMatch || jettyLocationMatch
            }
            
            // Filter boats based on name or location
            filteredBoatListingData = boatListingData.filter { listing in
                let nameMatch = listing.name?.lowercased().contains(query.lowercased()) ?? false
                let locationMatch = listing.locations?.name?.lowercased().contains(query.lowercased()) ?? false
                let jettyLocationMatch = listing.locations?.jettyLocation?.lowercased().contains(query.lowercased()) ?? false
                return nameMatch || locationMatch || jettyLocationMatch
            }
        }

        // Update segment titles with filtered counts
        beachHouseListingSegment.title = "Beach House Listings (\(filteredBeachHouseListingData.count))"
        boatListingSegment.title = "Boats Listings (\(filteredBoatListingData.count))"
        
        // Reload table view and update height
        listingTableView.reloadData()
        updateTableHeight()
    }
}

// MARK: - Binding
extension HostListingVC {
    func bind() {
        vm.transform(input: input)
        vm.output.subscribe(onNext: { [weak self] output in
            LoadingModal.dismiss()
            switch output {
            case .beachHouseListingSuccess(let response):
                if let listings = response.data?.beachHouseListings {
                    self?.beachHouseListingData = listings
                    self?.filteredBeachHouseListingData = listings // Update filtered data
                    self?.beachHouseListingSegment.title = "Beach House Listings (\(self?.beachHouseListingData.count ?? 0))"
                    self?.listingTableView.reloadData()
                    self?.updateTableHeight()
                }
                if let boatListings = response.data?.boatListings {
                    self?.boatListingData = boatListings
                    self?.filteredBoatListingData = boatListings // Update filtered data
                    self?.boatListingSegment.title = "Boats Listings (\(self?.boatListingData.count ?? 0))"
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

// MARK: - TableView Delegate
extension HostListingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isShowingBeachHouses ? filteredBeachHouseListingData.count : filteredBoatListingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HostListingTableView", for: indexPath) as! HostListingTableView
        if isShowingBeachHouses {
            let cellAt = filteredBeachHouseListingData[indexPath.row]
            cell.beachHouseListingCell(with: cellAt)
        } else {
            let cellAt = filteredBoatListingData[indexPath.row]
            cell.boatListingCell(with: cellAt)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isShowingBeachHouses {
            let cellAt = filteredBeachHouseListingData[indexPath.row]
            coordinator?.gotoEditBeachHouseOptionsView(id: cellAt.id)
        } else {
            let cellAt = filteredBoatListingData[indexPath.row]
            coordinator?.gotoEditBoatOptionsView(id: cellAt.id)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
    }
}

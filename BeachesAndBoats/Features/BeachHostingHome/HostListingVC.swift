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
//        setupRightNavigationBar()
        gestureRecognizers()
        beachHouseListingSegment.contentView.backgroundColor = .none
        boatListingSegment.contentView.backgroundColor = .none
        unfinishedListingStack.isHidden = true
        
        // Configure search field
        searchField.placeHolder = "Search by name or location"
        searchField.textField.clearButtonMode = .whileEditing
        searchField.noSpecialCharacters = false // Allow special characters; adjust if needed
        searchField.textField.delegate = self // Set delegate for text field
        
        // Initialize filtered data - moved after data loading
        filteredBeachHouseListingData = beachHouseListingData
        filteredBoatListingData = boatListingData
    }
    
    deinit {
        // Clean up timer to prevent crashes
        searchTimer?.invalidate()
        searchTimer = nil
    }
    
    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Debounce search input (similar to RxCocoa's .debounce(.milliseconds(300)))
        searchTimer?.invalidate()
        
        // Create the predicted text
        guard let currentText = textField.text else { return true }
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // Use weak self and dispatch to main queue for safety
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
            DispatchQueue.main.async {
                self?.filterListings(with: newText)
            }
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // Handle clear button tap
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
            DispatchQueue.main.async {
                self?.filterListings(with: "")
            }
        }
        return true
    }
    
    // Alternative: Real-time search without debouncing (if you prefer immediate results)
    func textFieldDidChangeSelection(_ textField: UITextField) {
        // This provides immediate feedback without timer
        // filterListings(with: textField.text ?? "")
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
                listingLocation: "\(unfinishedBeachListing.locationName ?? ""), \(unfinishedBeachListing.jettyLocation ?? "")",
                showDeleteStack: false,
                buttonOneTitle: "Continue Listing",
                buttonOneAction: { [weak self] in
                    print("Continue")
                },
                buttonTwoTitle: "Delete Listing",
                buttonTwoAction: { [weak self] in
                    self?.showDeleteModal()
                    print("Cancel button tapped!")
                }
            )
        } else if let unfinishedBoatListing = AppStorage.boatListing {
            self.showUnfinishedListingModal(
                listingName: unfinishedBoatListing.name ?? "Unnamed",
                listingLocation: "\(unfinishedBoatListing.locationName ?? ""), \(unfinishedBoatListing.jettyLocation ?? "")",
                showDeleteStack: false,
                buttonOneTitle: "Continue Listing",
                buttonOneAction: { [weak self] in
                    print("Continue")
                },
                buttonTwoTitle: "Delete Listing",
                buttonTwoAction: { [weak self] in
                    self?.showDeleteModal()
                    print("Cancel button tapped!")
                }
            )
        }
    }

    func showDeleteModal() {
        if let unfinishedBeachListing = AppStorage.beachListing {
            self.showUnfinishedListingModal(
                listingName: unfinishedBeachListing.name ?? "Unnamed",
                listingLocation: "\(unfinishedBeachListing.locationName ?? ""), \(unfinishedBeachListing.jettyLocation ?? "")",
                showDeleteStack: true,
                buttonOneTitle: "Yes, delete",
                buttonOneAction: { [weak self] in
                    self?.deleteListing()
                },
                buttonTwoTitle: "Cancel",
                buttonTwoAction: { [weak self] in
                    self?.dismiss(animated: true)
                    print("Cancel button tapped!")
                }
            )
        } else if let unfinishedBoatListing = AppStorage.boatListing {
            self.showUnfinishedListingModal(
                listingName: unfinishedBoatListing.name ?? "Unnamed",
                listingLocation: "\(unfinishedBoatListing.locationName ?? ""), \(unfinishedBoatListing.jettyLocation ?? "")",
                showDeleteStack: true,
                buttonOneTitle: "Yes, delete",
                buttonOneAction: { [weak self] in
                    self?.deleteListing()
                },
                buttonTwoTitle: "Cancel",
                buttonTwoAction: { [weak self] in
                    self?.dismiss(animated: true)
                    print("Cancel button tapped!")
                }
            )
        }
    }
    
    func deleteListing() {
        if isShowingBeachHouses {
            AppStorage.beachListing = nil
            MiddleModal.show(title: "Successfully Deleted!", type: .success, onConfirm: {
                self.showListingForBeaches()
            })
        } else {
            AppStorage.boatListing = nil
            MiddleModal.show(title: "Successfully Deleted!", type: .success, onConfirm: {
                self.showListingForBoats()
            })
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
        
        // Apply current search filter when switching tabs
        let currentSearchText = searchField.textField.text ?? ""
        filterListings(with: currentSearchText)
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
        // Ensure we're on the main thread
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.listingTableView.layoutIfNeeded()
            let contentHeight = self.listingTableView.contentSize.height
            self.viewContainerHeightConstraint.constant = contentHeight + 350
            
            // Animate the layout change
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            
            // Show/hide table based on results
            let hasResults = (self.isShowingBeachHouses && !self.filteredBeachHouseListingData.isEmpty) ||
                            (!self.isShowingBeachHouses && !self.filteredBoatListingData.isEmpty)
            
            self.listingTableView.isHidden = !hasResults
            
            // You can add an empty state view here if needed
            if !hasResults {
                // Show empty state
                print("No results found")
            }
        }
    }
    
    private func filterListings(with query: String) {
        // Ensure we have data to filter
        guard !beachHouseListingData.isEmpty || !boatListingData.isEmpty else {
            print("No data available to filter")
            return
        }
        
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedQuery.isEmpty {
            // Reset to full dataset if query is empty
            filteredBeachHouseListingData = beachHouseListingData
            filteredBoatListingData = boatListingData
        } else {
            // Filter beach houses based on name or location (case-insensitive)
            filteredBeachHouseListingData = beachHouseListingData.filter { listing in
                let nameMatch = listing.name?.localizedCaseInsensitiveContains(trimmedQuery) ?? false
                let locationMatch = listing.locations?.name?.localizedCaseInsensitiveContains(trimmedQuery) ?? false
                let jettyLocationMatch = listing.locations?.jettyLocation?.localizedCaseInsensitiveContains(trimmedQuery) ?? false
                return nameMatch || locationMatch || jettyLocationMatch
            }
            
            // Filter boats based on name or location (case-insensitive)
            filteredBoatListingData = boatListingData.filter { listing in
                let nameMatch = listing.name?.localizedCaseInsensitiveContains(trimmedQuery) ?? false
                let locationMatch = listing.locations?.name?.localizedCaseInsensitiveContains(trimmedQuery) ?? false
                let jettyLocationMatch = listing.locations?.jettyLocation?.localizedCaseInsensitiveContains(trimmedQuery) ?? false
                return nameMatch || locationMatch || jettyLocationMatch
            }
        }

        // Update segment titles with filtered counts
        beachHouseListingSegment.title = "Beach House Listings (\(filteredBeachHouseListingData.count))"
        boatListingSegment.title = "Boats Listings (\(filteredBoatListingData.count))"
        
        // Reload table view and update height on main thread
        DispatchQueue.main.async { [weak self] in
            self?.listingTableView.reloadData()
            self?.updateTableHeight()
        }
    }
}

// MARK: - Binding
extension HostListingVC {
    func bind() {
        vm.transform(input: input)
        vm.output.subscribe(onNext: { [weak self] output in
            DispatchQueue.main.async {
                LoadingModal.dismiss()
                switch output {
                case .beachHouseListingSuccess(let response):
                    if let listings = response.data?.beachHouseListings {
                        self?.beachHouseListingData = listings
                        self?.filteredBeachHouseListingData = listings // Update filtered data
                        self?.beachHouseListingSegment.title = "Beach House Listings (\(listings.count))"
                    }
                    if let boatListings = response.data?.boatListings {
                        self?.boatListingData = boatListings
                        self?.filteredBoatListingData = boatListings // Update filtered data
                        self?.boatListingSegment.title = "Boats Listings (\(boatListings.count))"
                    }
                    self?.listingTableView.reloadData()
                    self?.updateTableHeight()
                    self?.updateSelection()
                case .beachHouseListingFailure(let error):
                    MiddleModal.show(title: error.message ?? "An error occurred", type: .error)
                }
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HostListingTableView", for: indexPath) as? HostListingTableView else {
            return UITableViewCell()
        }
        
        // Add bounds checking to prevent crashes
        if isShowingBeachHouses {
            guard indexPath.row < filteredBeachHouseListingData.count else {
                print("Index out of bounds for beach house listings")
                return cell
            }
            let cellAt = filteredBeachHouseListingData[indexPath.row]
            cell.beachHouseListingCell(with: cellAt)
        } else {
            guard indexPath.row < filteredBoatListingData.count else {
                print("Index out of bounds for boat listings")
                return cell
            }
            let cellAt = filteredBoatListingData[indexPath.row]
            cell.boatListingCell(with: cellAt)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isShowingBeachHouses {
            guard indexPath.row < filteredBeachHouseListingData.count else { return }
            let cellAt = filteredBeachHouseListingData[indexPath.row]
            coordinator?.gotoEditBeachHouseOptionsView(id: cellAt.id)
        } else {
            guard indexPath.row < filteredBoatListingData.count else { return }
            let cellAt = filteredBoatListingData[indexPath.row]
            coordinator?.gotoEditBoatOptionsView(id: cellAt.id)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
    }
}

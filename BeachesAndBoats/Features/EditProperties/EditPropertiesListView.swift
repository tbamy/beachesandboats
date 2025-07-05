//
//  EditPropertiesListView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 25/04/2025.
//

import UIKit
import RxSwift

class EditPropertiesListView: BaseViewControllerPlain {
    
    @IBOutlet weak var searchField: SearchField!
    @IBOutlet weak var beachHouseListingSegment: SegmentOptionView!
    @IBOutlet weak var boatListingSegment: SegmentOptionView!
    @IBOutlet weak var listingTableView: UITableView!
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
    }
    
    func gestureRecognizers() {
        let beachHouse = UITapGestureRecognizer(target: self, action: #selector(beachHouseTapped))
        beachHouseListingSegment.isUserInteractionEnabled = true
        beachHouseListingSegment.addGestureRecognizer(beachHouse)
        
        let boat = UITapGestureRecognizer(target: self, action: #selector(boatTapped))
        boatListingSegment.isUserInteractionEnabled = true
        boatListingSegment.addGestureRecognizer(boat)
    
    }
    
    @objc func beachHouseTapped() {
        isShowingBeachHouses = true
        updateSelection()
    }
    
    @objc func boatTapped() {
        isShowingBeachHouses = false
        updateSelection()
    }
    
    
    private func updateSelection() {
        if isShowingBeachHouses {
            beachHouseListingSegment.isNotSelected = true
            boatListingSegment.isNotSelected = false
        } else {
            beachHouseListingSegment.isNotSelected = false
            boatListingSegment.isNotSelected = true
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
 
//        searchField.duration.isHidden = true
        
    }
    
    private func updateTableHeight() {
        listingTableView.layoutIfNeeded()
        let contentHeight = listingTableView.contentSize.height
        view.layoutIfNeeded()
    }
}

//MARK: - Binding
extension EditPropertiesListView {
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
extension EditPropertiesListView: UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isShowingBeachHouses {
            let cellAt = beachHouseListingData[indexPath.row]
            
        } else {
            let cellAt = boatListingData[indexPath.row]
            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            // Get actual content height
            tableView.layoutIfNeeded()
            let contentHeight = tableView.contentSize.height
            
            // Add height of UIView (300) + margins (50)
            let totalHeight = contentHeight + 350
            
            view.layoutIfNeeded()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
    }
}

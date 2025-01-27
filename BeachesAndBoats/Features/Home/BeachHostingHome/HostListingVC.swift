//
//  HostListingVC.swift
//  BeachesAndBoats
//
//  Created by WEMA on 10/01/2025.
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
                showDeleteModal()
            },
            buttonTwoTitle: "Delete Listing",
            buttonTwoAction: {
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
               print("Delete")
            },
            buttonTwoTitle: "Cancel",
            buttonTwoAction: {
                print("Cancel button tapped!")
            }
        )
    }
    
    @objc func beachHouseTapped() {
        isShowingBeachHouses = true
        beachHouseListingSegment.isSelected = true
        boatListingSegment.isSelected = false
        listingTableView.reloadData()
    }
    
    @objc func boatTapped() {
        isShowingBeachHouses = false
        boatListingSegment.isSelected = true
        beachHouseListingSegment.isSelected = false
        listingTableView.reloadData()
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
                    self?.listingTableView.reloadData()
                }
                if let boatListings = response.data?.boatListings {
                    self?.boatListingData = boatListings
                    self?.listingTableView.reloadData()
                }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
    }
}

//
//  HomePageViewController.swift
//  BeachesAndBoats
//
//  Created by Paul Orimogunje on 26/05/2024.
//

import UIKit

class HomePageViewController: UIViewController {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var filterViewContainer: UIView!
    @IBOutlet weak var beachViewContainer: UIView!
    @IBOutlet weak var boatsViewContainer: UIView!
    @IBOutlet weak var servicesViewContainer: UIView!
    @IBOutlet weak var beachHouseImg: UIImageView!
    @IBOutlet weak var boatImg: UIImageView!
    @IBOutlet weak var serviceImg: UIImageView!
    @IBOutlet weak var subCategoryCollectionView: UICollectionView!
    @IBOutlet weak var topRatedCollectionView: UICollectionView!
    @IBOutlet weak var otherTableView: UITableView!
    @IBOutlet weak var boatLabel: UILabel!
    @IBOutlet weak var beachHouseLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var currentBookingTable: UITableView!
    @IBOutlet weak var bookNowCollection: UICollectionView!
    @IBOutlet weak var bookNowStack: UIStackView!
    @IBOutlet weak var currentBookingStack: UIStackView!
    @IBOutlet weak var topRatedStack: UIStackView!
    @IBOutlet weak var otherStack: UIStackView!
    @IBOutlet weak var viewScrollConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var categoryStack: UIStackView!
    
    
    var coordinator: AppCoordinator?
    var subCategoryCoordinator: [SubCategoryPropeties] = SubCateogryModel().populateData()
    var topRatedCoordinator: [TopRatedProperties] = TopRatedModel().populateData()
    var boatTopRatedCoordinator: [TopRatedProperties] = BoatsTopRatedModel().populateData()
    var otherCoordinator: [TopRatedProperties] = OthersModel().populateData()
    var boatOtherCoordinator: [TopRatedProperties] = BoatsOthersModel().populateData()
    var boatBookNowCoordinator: [TopRatedProperties] = BoatBookNowModel().populateData()
    
    var likedItems = [TopRatedProperties]()
    
    var selectedView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewContainerSetup()
        collectionViewSetup()
        gestureRecongnizers()
        
        beachHouseImg.layer.borderWidth = 4
        beachHouseImg.layer.borderColor = UIColor.orange.cgColor
        selectedView = beachViewContainer
        bookNowStack.isHidden = true
        currentBookingStack.isHidden = true
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTableViewHeight()
    }
    
    func viewContainerSetup() {
        
        filterViewContainer.layer.borderWidth = 1
        filterViewContainer.layer.borderColor = UIColor.lightGray.cgColor
        filterViewContainer.layer.cornerRadius = 10
        
        beachHouseImg.layer.cornerRadius = 10
        boatImg.layer.cornerRadius = 10
        serviceImg.layer.cornerRadius = 10
        
        searchView.layer.cornerRadius = 10
        searchView.layer.shadowColor = UIColor.black.cgColor
        searchView.layer.shadowOpacity = 0.1
        searchView.layer.shadowOffset = CGSize(width: 2, height: 2)
        searchView.layer.shadowRadius = 10
    }
    
    func gestureRecongnizers() {
        let search = UITapGestureRecognizer(target: self, action: #selector(searchTapped))
        searchView.isUserInteractionEnabled = true
        searchView.addGestureRecognizer(search)
        
        let beachView = UITapGestureRecognizer(target: self, action: #selector(beachViewTapped))
        beachViewContainer.isUserInteractionEnabled = true
        beachViewContainer.addGestureRecognizer(beachView)
        
        let boatView = UITapGestureRecognizer(target: self, action: #selector(boatViewTapped))
        boatsViewContainer.isUserInteractionEnabled = true
        boatsViewContainer.addGestureRecognizer(boatView)
        
        let serviceView = UITapGestureRecognizer(target: self, action: #selector(serviceViewTapped))
        servicesViewContainer.isUserInteractionEnabled = true
        servicesViewContainer.addGestureRecognizer(serviceView)
        
        let filter = UITapGestureRecognizer(target: self, action: #selector(filterTapped))
        filterViewContainer.isUserInteractionEnabled = true
        filterViewContainer.addGestureRecognizer(filter)
    }
    
    @objc func beachViewTapped() {
        print("beach view")
        selectedView = beachViewContainer
        scrollView.isScrollEnabled = true
        
        
        beachHouseImg.layer.borderWidth = 4
        beachHouseImg.layer.borderColor = UIColor.orange.cgColor
        
        boatImg.layer.borderWidth = .nan
        boatImg.layer.borderColor = .none
        serviceImg.layer.borderWidth = .nan
        serviceImg.layer.borderColor = .none
        
        bookNowStack.isHidden = true
        currentBookingStack.isHidden = true
        topRatedStack.isHidden = false
        otherStack.isHidden = false
        subCategoryCollectionView.isHidden = false
        
        
        viewScrollConstraintHeight.constant = 1900
        
        otherTableView.reloadData()
        topRatedCollectionView.reloadData()
    }
    
    @objc func boatViewTapped() {
        print("boat view")
        scrollView.isScrollEnabled = true
        
        
        selectedView = boatsViewContainer
        boatImg.layer.borderWidth = 4
        boatImg.layer.borderColor = UIColor.orange.cgColor
        
        beachHouseImg.layer.borderWidth = .nan
        beachHouseImg.layer.borderColor = .none
        serviceImg.layer.borderWidth = .nan
        serviceImg.layer.borderColor = .none
        
        bookNowStack.isHidden = false
        //        currentBookingStack.isHidden = true
        topRatedStack.isHidden = false
        otherStack.isHidden = false
        subCategoryCollectionView.isHidden = false
        
        viewScrollConstraintHeight.constant = 2250
        
        
        otherTableView.reloadData()
        topRatedCollectionView.reloadData()
        bookNowCollection.reloadData()
    }
    
    @objc func serviceViewTapped() {
        bookNowStack.isHidden = true
        serviceImg.layer.borderWidth = 4
        serviceImg.layer.borderColor = UIColor.orange.cgColor
        
        beachHouseImg.layer.borderWidth = .nan
        beachHouseImg.layer.borderColor = .none
        boatImg.layer.borderWidth = .nan
        boatImg.layer.borderColor = .none
        
        bookNowStack.isHidden = true
        topRatedStack.isHidden = true
        otherStack.isHidden = true
        currentBookingStack.isHidden = false
//        subCategoryCollectionView.isHidden = true
        scrollView.isScrollEnabled = true
        
//        scrollView.topAnchor.constraint(equalTo: categoryStack.bottomAnchor, constant: 20).isActive = true
        
        //        currentBookingTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        //        currentBookingStack.translatesAutoresizingMaskIntoConstraints = false
        //        currentBookingStack.topAnchor.constraint(equalTo: categoryStack.bottomAnchor).isActive = true
        
        //        viewScrollConstraintHeight.constant = 2000
        
        otherTableView.reloadData()
        topRatedCollectionView.reloadData()
        bookNowCollection.reloadData()
        currentBookingTable.reloadData()
    }
    
    @objc func searchTapped() {
        let searchView = DestinationSearchViewController()
        searchView.modalPresentationStyle = .fullScreen
        present(searchView, animated: false)
    }
    
    @objc func filterTapped() {
        let filterView = FilterViewController()
        filterView.modalPresentationStyle = .overCurrentContext
        present(filterView, animated: false)
    }
    
    func collectionViewSetup() {
        subCategoryCollectionView.delegate = self
        subCategoryCollectionView.dataSource = self
        subCategoryCollectionView.tag = 1
        subCategoryCollectionView.register(UINib(nibName: "subCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "subCategoryCollectionViewCell")
        
        topRatedCollectionView.delegate = self
        topRatedCollectionView.dataSource = self
        topRatedCollectionView.tag = 2
        topRatedCollectionView.register(UINib(nibName: "TopRatedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TopRatedCollectionViewCell")
        
        bookNowCollection.delegate = self
        bookNowCollection.dataSource = self
        bookNowCollection.tag = 3
        bookNowCollection.register(UINib(nibName: "TopRatedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TopRatedCollectionViewCell")
        
        otherTableView.delegate = self
        otherTableView.dataSource = self
        otherTableView.tag = 1
        otherTableView.register(UINib(nibName: "OthersTableViewCell", bundle: nil), forCellReuseIdentifier: "OthersTableViewCell" )
        otherTableView.separatorStyle = .none
        
        currentBookingTable.delegate = self
        currentBookingTable.dataSource = self
        currentBookingTable.tag = 2
        currentBookingTable.register(UINib(nibName: "OthersTableViewCell", bundle: nil), forCellReuseIdentifier: "OthersTableViewCell" )
        currentBookingTable.separatorStyle = .none
    }
    
    func updateTableViewHeight() {
        otherTableView?.layoutIfNeeded()
        let height = otherTableView.contentSize.height
        NSLayoutConstraint.deactivate(otherTableView.constraints.filter { $0.firstAttribute == .height })
        NSLayoutConstraint.activate([
            otherTableView.heightAnchor.constraint(equalToConstant: height)
        ])
    }
}


extension HomePageViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedView == beachViewContainer {
            if tableView.tag == 1 {
                return otherCoordinator.count
            }
        } else if selectedView == boatsViewContainer {
            if tableView.tag == 1 {
                return boatOtherCoordinator.count
            }
        } else if selectedView == servicesViewContainer {
            if tableView.tag == 2 {
                return boatOtherCoordinator.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedView == beachViewContainer {
            if tableView.tag == 1 {
                let cell = otherTableView.dequeueReusableCell(withIdentifier: "OthersTableViewCell", for: indexPath) as! OthersTableViewCell
                let cellAt = otherCoordinator[indexPath.item]
                cell.setup(with: cellAt)
                cell.selectionStyle = .none
                return cell
            }
        } else if selectedView == boatsViewContainer {
            if tableView.tag == 1{
                let cell = otherTableView.dequeueReusableCell(withIdentifier: "OthersTableViewCell", for: indexPath) as! OthersTableViewCell
                let cellAt = boatOtherCoordinator[indexPath.item]
                cell.setup(with: cellAt)
                cell.selectionStyle = .none
                return cell
            }
        } else if selectedView == servicesViewContainer {
            if tableView.tag == 2 {
                let cell = currentBookingTable.dequeueReusableCell(withIdentifier: "OthersTableViewCell", for: indexPath) as! OthersTableViewCell
                let cellAt = boatOtherCoordinator[indexPath.item]
                cell.setup(with: cellAt)
                cell.selectionStyle = .none
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    
}

extension HomePageViewController: UICollectionViewDelegate, UICollectionViewDataSource /*TopRatedCollectionViewCellDelegate*/ {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedView == beachViewContainer {
            if collectionView.tag == 1 {
                return subCategoryCoordinator.count
            } else if collectionView.tag == 2 {
                return topRatedCoordinator.count
            }
        } else if selectedView == boatsViewContainer {
            if collectionView.tag == 1 {
                return subCategoryCoordinator.count
            } else if collectionView.tag == 2 {
                return boatTopRatedCoordinator.count
            } else if collectionView.tag == 3 {
                return boatBookNowCoordinator.count
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if selectedView == beachViewContainer {
            if collectionView.tag == 1 {
                let cell = subCategoryCollectionView.dequeueReusableCell(withReuseIdentifier: "subCategoryCollectionViewCell", for: indexPath) as! subCategoryCollectionViewCell
                let cellAt = subCategoryCoordinator[indexPath.item]
                cell.setup(with: cellAt)
                return cell
            } else if collectionView.tag == 2 {
                let cell = topRatedCollectionView.dequeueReusableCell(withReuseIdentifier: "TopRatedCollectionViewCell", for: indexPath) as! TopRatedCollectionViewCell
                let cellAt = topRatedCoordinator[indexPath.item]
                cell.setup(with: cellAt)
//                cell.delegate = self
//                cell.isLiked = likedItems.contains { $0.likeImg == cellAt.likeImg }
                return cell
            }
        } else if selectedView == boatsViewContainer {
            if collectionView.tag == 1 {
                let cell = subCategoryCollectionView.dequeueReusableCell(withReuseIdentifier: "subCategoryCollectionViewCell", for: indexPath) as! subCategoryCollectionViewCell
                let cellAt = subCategoryCoordinator[indexPath.item]
                cell.setup(with: cellAt)
                return cell
            } else if collectionView.tag == 2 {
                let cell = topRatedCollectionView.dequeueReusableCell(withReuseIdentifier: "TopRatedCollectionViewCell", for: indexPath) as! TopRatedCollectionViewCell
                let cellAt = boatTopRatedCoordinator[indexPath.item]
                cell.setup(with: cellAt)
                return cell
            } else if collectionView.tag == 3 {
                let cell = bookNowCollection.dequeueReusableCell(withReuseIdentifier: "TopRatedCollectionViewCell", for: indexPath) as! TopRatedCollectionViewCell
                let cellAt = boatBookNowCoordinator[indexPath.item]
                cell.setup(with: cellAt)
                return cell
            }
        }
       
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedView == beachViewContainer {
            if collectionView.tag == 2{
                let bookDetails = BookingDetailsViewController()
                bookDetails.continueBooking = "Continue Booking"
                let getDetails = topRatedCoordinator[indexPath.item]
                coordinator?.gotoTopRatedDetails(data: getDetails)
            }
        } else if selectedView == boatsViewContainer {
            if collectionView.tag == 2 {
                let bookDetails = BookingDetailsViewController()
                bookDetails.continueBooking = "Continue Booking"
                let getDetails = boatTopRatedCoordinator[indexPath.item]
                coordinator?.gotoBoatDetails(data: getDetails)
            } else if collectionView.tag == 3 {
                let bookDetails = BookingDetailsViewController()
                bookDetails.continueBooking = "Continue Booking"
                let getDetails = boatBookNowCoordinator[indexPath.item]
                coordinator?.gotoBoatDetails(data: getDetails)
            }
        }
       
    }
    
    
    
//    func didTapImage(in cell: TopRatedCollectionViewCell) {
//        guard let indexPath = topRatedCollectionView.indexPath(for: cell) else { return }
//        let selectedItem = topRatedCoordinator[indexPath.item]
//        
//        if let index = likedItems.firstIndex(where: { $0.likeImg == selectedItem.likeImg }) {
//            likedItems.remove(at: index)
//            cell.isLiked = false
//        } else {
//            likedItems.append(selectedItem)
//            cell.isLiked = true
//        }
//        
//        //Saving liked items using userdefaults
//        let likeHouses = likedItems.compactMap { $0.likeImg}
//        UserDefaults.standard.set(likeHouses, forKey: "likeHouses")
//    }
}

extension HomePageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1 {
            let widthOfScreen: CGFloat = 93/*collectionView.bounds.width*/
            let heightOfScreen = collectionView.bounds.height
            return CGSize(width: widthOfScreen, height: heightOfScreen)
        } else if collectionView.tag == 2 {
            let widthOfScreen: CGFloat = 365
            let heightOfScreen = collectionView.bounds.height
            return CGSize(width: widthOfScreen, height: heightOfScreen)
        } else if collectionView.tag == 3 {
            let widthOfScreen: CGFloat = 365
            let heightOfScreen = collectionView.bounds.height
            return CGSize(width: widthOfScreen, height: heightOfScreen)
        }
        return CGSize()
       
    }
}


//extension HomePageViewController: PastBookingItemDelegate {
//    func cellTapped(inCell: TopRatedCollectionViewCell, data: TopRatedProperties) {
//        delegate.
//    }
//    
//    
//}

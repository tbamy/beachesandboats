//
//  HomeView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 03/09/2024.
//

import UIKit

class HomeView: BaseViewControllerPlain {

    var coordinator: AppCoordinator?
    var slides: [CategoriesModel] = []
    
    @IBOutlet weak var filterBtn: UIImageView!
    @IBOutlet weak var searchField: SearchField!
    @IBOutlet weak var subcategoryCollectionView: UICollectionView!
    @IBOutlet weak var topRatedTableView: UITableView!
    
    
    @IBOutlet weak var beachViewContainer: UIStackView!
    @IBOutlet weak var boatsViewContainer: UIStackView!
    @IBOutlet weak var servicesViewContainer: UIStackView!
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
    
    var selectedView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        
        addShadow(to: subcategoryCollectionView)
        
        
        slides = [
            .init(image: "", title: "Luxury"),
            .init(image: "", title: "Hotels"),
            .init(image: "", title: "Mansion"),
            .init(image: "", title: "Rooms"),
            .init(image: "", title: "Amazing pools"),
            .init(image: "", title: "Design"),
            .init(image: "", title: "Adapted")
        ]
        
//        mainCategoryCollectionView.delegate = self
//        mainCategoryCollectionView.dataSource = self
        
        
        subcategoryCollectionView.register(UINib(nibName: "CategoriesViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoriesViewCell")
    }
    
    func gestureRecognizers() {
        
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
        filterBtn.isUserInteractionEnabled = true
        filterBtn.addGestureRecognizer(filter)
    }
    
    @objc func beachViewTapped(){
        
    }
    
    @objc func boatViewTapped(){
        
    }
    
    @objc func serviceViewTapped(){
        
    }
    
    @objc func filterTapped(){
        
    }

    func addShadow(to view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.masksToBounds = false
    }

}

extension HomeView: UICollectionViewDelegate, UICollectionViewDataSource{
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
    
    
}

extension HomeView: UICollectionViewDelegateFlowLayout {
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

struct CategoriesModel{
    var image: String
    var title: String
}

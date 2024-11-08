//
//  HomeView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 03/09/2024.
//

import UIKit

class HomeView: BaseViewControllerPlain {

    var coordinator: ExploreCoordinator?
    
    @IBOutlet weak var filterBtn: UIImageView!
    @IBOutlet weak var searchField: SearchField!
    @IBOutlet weak var subcategoryCollectionView: UICollectionView!
//    @IBOutlet weak var topRatedTableView: UITableView!
    
    
    @IBOutlet weak var beachViewContainer: UIStackView!
    @IBOutlet weak var boatsViewContainer: UIStackView!
    @IBOutlet weak var servicesViewContainer: UIStackView!
    @IBOutlet weak var beachHouseImg: UIImageView!
    @IBOutlet weak var boatImg: UIImageView!
    @IBOutlet weak var serviceImg: UIImageView!
//    @IBOutlet weak var subCategoryCollectionView: UICollectionView!

    @IBOutlet weak var beachHouseTableView: UITableView!
    @IBOutlet weak var boatTableView: UITableView!
    @IBOutlet weak var serviceTableVIew: UITableView!
    
    var selectedView: UIView?
    
    
    var boatsCategories: [CategoriesModel] = []
    var beachesCategories: [CategoriesModel] = []
    var boats: [HomeViewData] = []
    var beaches: [HomeViewData] = []
    var topRatedBoats: [HomeViewData] = []
    var topRatedBeaches: [HomeViewData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        
        addShadow(to: subcategoryCollectionView)
        
    }
    
    func configureViews(){
        subcategoryCollectionView.delegate = self
        subcategoryCollectionView.dataSource = self
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
    
    func sampleData(){
        boatsCategories = [
            .init(image: "", title: "Luxury"),
            .init(image: "", title: "Hotels"),
            .init(image: "", title: "Mansion"),
            .init(image: "", title: "Rooms"),
            .init(image: "", title: "Amazing pools"),
            .init(image: "", title: "Design"),
            .init(image: "", title: "Adapted")
        ]
        
        beachesCategories = [
            .init(image: "", title: "Yacht"),
            .init(image: "", title: "Mini yacht"),
            .init(image: "", title: "Cabin Boat"),
            .init(image: "", title: "Speed Boat"),
            .init(image: "", title: "Ferry"),
            .init(image: "", title: "Banana Boat"),
            .init(image: "", title: "Water Taxi"),
            .init(image: "", title: "Jet Ski")
        ]
        
        boats = [
//            .init(title: <#T##String#>, price: <#T##String#>, rating: <#T##String#>, infoOne: <#T##String#>, infoTwo: <#T##String#>, bannerImg: <#T##String#>),
//            .init(title: <#T##String#>, price: <#T##String#>, rating: <#T##String#>, infoOne: <#T##String#>, infoTwo: <#T##String#>, bannerImg: <#T##String#>)
        ]
        
        beaches = [
            
        ]
        
        topRatedBoats = [
            
        ]
        
        topRatedBeaches = [
            
        ]
    }

}

extension HomeView: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedView == beachViewContainer {
            if collectionView.tag == 1 {
                return beachesCategories.count
            } else if collectionView.tag == 2 {
                return topRatedBeaches.count
            }
        } else if selectedView == boatsViewContainer {
            if collectionView.tag == 1 {
                return boatsCategories.count
            } else if collectionView.tag == 2 {
                return topRatedBoats.count
//            } else if collectionView.tag == 3 {
//                return boatBookNowCoordinator.count
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if selectedView == beachViewContainer {
            if collectionView.tag == 1 {
                let cell = subcategoryCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesViewCell", for: indexPath) as! CategoriesViewCell
                let cellAt = beachesCategories[indexPath.item]
//                cell.setup(with: cellAt)
                return cell
//            } else if collectionView.tag == 2 {
//                let cell = topRatedCollectionView.dequeueReusableCell(withReuseIdentifier: "GeneralViewCell", for: indexPath) as! GeneralViewCell
//                let cellAt = topRatedBeaches[indexPath.item]
////                cell.setup(with: cellAt)
////                cell.delegate = self
////                cell.isLiked = likedItems.contains { $0.likeImg == cellAt.likeImg }
//                return cell
            }
        } else if selectedView == boatsViewContainer {
            if collectionView.tag == 1 {
                let cell = subcategoryCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesViewCell", for: indexPath) as! CategoriesViewCell
                let cellAt = boatsCategories[indexPath.item]
//                cell.setup(with: cellAt)
                return cell
//            } else if collectionView.tag == 2 {
//                let cell = topRatedCollectionView.dequeueReusableCell(withReuseIdentifier: "GeneralViewCell", for: indexPath) as! GeneralViewCell
//                let cellAt = topRatedBoats[indexPath.item]
//                cell.setup(with: cellAt)
//                return cell
//            } else if collectionView.tag == 3 {
//                let cell = bookNowCollection.dequeueReusableCell(withReuseIdentifier: "TopRatedCollectionViewCell", for: indexPath) as! TopRatedCollectionViewCell
//                let cellAt = boatBookNowCoordinator[indexPath.item]
//                cell.setup(with: cellAt)
//                return cell
            }
        }
       
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("DO something")
//        if selectedView == beachViewContainer {
//            if collectionView.tag == 2{
//                let bookDetails = BookingDetailsViewController()
//                bookDetails.continueBooking = "Continue Booking"
//                let getDetails = topRatedCoordinator[indexPath.item]
//                coordinator?.gotoTopRatedDetails(data: getDetails)
//            }
//        } else if selectedView == boatsViewContainer {
//            if collectionView.tag == 2 {
//                let bookDetails = BookingDetailsViewController()
//                bookDetails.continueBooking = "Continue Booking"
//                let getDetails = boatTopRatedCoordinator[indexPath.item]
//                coordinator?.gotoBoatDetails(data: getDetails)
//            } else if collectionView.tag == 3 {
//                let bookDetails = BookingDetailsViewController()
//                bookDetails.continueBooking = "Continue Booking"
//                let getDetails = boatBookNowCoordinator[indexPath.item]
//                coordinator?.gotoBoatDetails(data: getDetails)
//            }
//        }
       
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

//struct BoatsModel{
//    var image: String
//    var title: String
//    var location: String
//    var capacity: String
//    var rating: String
//}
//
//struct BeachesModel{
//    var image: String
//    var title: String
//    var location: String
//    var date: String
//    var rating: String
//    var price: String
//}

//
//  HomeView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 03/09/2024.
//

import UIKit
import RxSwift

class HomeView: BaseViewControllerPlain {

    var coordinator: ExploreCoordinator?
    
    @IBOutlet weak var filterBtn: UIImageView!
    @IBOutlet weak var searchField: SearchField!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var subcategoryCollectionView: UICollectionView!
//    @IBOutlet weak var topRatedTableView: UITableView!

//    @IBOutlet weak var subCategoryCollectionView: UICollectionView!

    @IBOutlet weak var beachHouseCollectionView: UICollectionView!
    @IBOutlet weak var boatCollectionView: UICollectionView!
    @IBOutlet weak var serviceCollectionVIew: UICollectionView!
    @IBOutlet weak var topRatedBeachHouseCollectionView: UICollectionView!
    @IBOutlet weak var topRatedBoatCollectionView: UICollectionView!
    
    @IBOutlet weak var beachHouseStack: UIStackView!
    @IBOutlet weak var boatStack: UIStackView!
    @IBOutlet weak var serviceStack: UIStackView!
    @IBOutlet weak var topRatedBeachHouseStack: UIStackView!
    @IBOutlet weak var topRatedBoatStack: UIStackView!
    
    @IBOutlet weak var beachHouseCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var boatCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var serviceCollectionVIewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topRatedBeachHouseCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topRatedBoatCollectionVIewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    private var refreshControl = UIRefreshControl()
    
    var selectedView: UIView?
    
//    var allData: [PropertyCategory] = []
    var categories: [PropertyCategory] = []
    var subcategories: [SubCategory] = []
    var boats: [Listing] = []
    var beaches: [Listing] = []
    var services: [Listing] = []
    var topRatedBoats: [Listing] = []
    var topRatedBeaches: [Listing] = []
    
    var selectedBeachCat: [String] = []
    var selectedBoatCat: String = ""
    var selectedServiceCat: String = ""
    
    var selectedCatIndex: Int? = nil
    
    var details: Listing?
    
    let vm = HomeViewVM()
    let disposeBag = DisposeBag()
    let input = PublishSubject<HomeViewVM.Input>()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        
        setup()
        configureAllCollectionViews()
        setGestureRecognizers()
        refreshControl.tintColor = UIColor.beachBlue
        scrollView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        bind()
        LoadingModal.show()
        input.onNext(.getBookingCategories(page: "1"))
        
        addShadow(to: subcategoryCollectionView)
        
    }
    
    func setup(){
        topRatedBoatStack.isHidden = true
        boatStack.isHidden = true
        serviceStack.isHidden = true
        
        searchField
        
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        input.onNext(.getBookingCategories(page: "1"))
    }
    
    func configureAllCollectionViews() {
        configureCollectionView(categoryCollectionView, tag: CollectionViewType.category.rawValue)
        configureCollectionView(subcategoryCollectionView, tag: CollectionViewType.subcategory.rawValue)
        configureCollectionView(beachHouseCollectionView, tag: CollectionViewType.beachHouse.rawValue)
        configureCollectionView(boatCollectionView, tag: CollectionViewType.boat.rawValue)
        configureCollectionView(topRatedBeachHouseCollectionView, tag: CollectionViewType.topRatedBeachHouse.rawValue)
        configureCollectionView(topRatedBoatCollectionView, tag: CollectionViewType.topRatedBoat.rawValue)
        configureCollectionView(serviceCollectionVIew, tag: CollectionViewType.service.rawValue)
    }

    
    func configureCollectionView(_ collectionView: UICollectionView, tag: Int) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.tag = tag
        collectionView.backgroundColor = .clear
//        collectionView.layer.borderColor = UIColor.beachBlue.cgColor
//        collectionView.layer.borderWidth = 2
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
    }

    
    func setGestureRecognizers() {
        
        let filter = UITapGestureRecognizer(target: self, action: #selector(filterTapped))
        filterBtn.isUserInteractionEnabled = true
        filterBtn.addGestureRecognizer(filter)
    }
    
    @objc func filterTapped(){
        
    }

    func addShadow(to view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 2
        view.layer.masksToBounds = false
    }
    
    func updateCollectionViewHeight(_ CollectionView: UICollectionView, _ CollectionViewHeightConstraint: NSLayoutConstraint) {
        CollectionView.layoutIfNeeded()
        let contentHeight = CollectionView.contentSize.height
        CollectionViewHeightConstraint.constant = contentHeight
        
        self.view.layoutIfNeeded()
    }

}

extension HomeView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
            
        case 1:
            return categories.count
        case 2:
            return subcategories.count
        case 3:
//            print(topRatedBoats.count)
            return topRatedBeaches.count
        case 4:
            print(beaches.count)
            return beaches.count
        case 5:
            return topRatedBoats.count
        case 6:
            return boats.count
        case 7:
            return services.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView.tag {
        case 1:
            let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
            let cellAt = categories[indexPath.item]
            let view = CategoriesCell(frame: cell.bounds)
            view.identifier = "Categories " + indexPath.description
            view.model.image = cellAt.image ?? ""
            view.model.title = cellAt.name ?? ""
            
//            view.model.state = (indexPath.item == selectedCatIndex)
//            view.model.tapped = { [weak self] in
//                guard let self = self else { return }
//                self.selectedCatIndex = indexPath.item
//                self.categoryCollectionView.reloadData()
//            }
                
            
            cell.applyView(view: view)
            return cell
            
        case 2:
            let cell = subcategoryCollectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
            let cellAt = subcategories[indexPath.item]
            cell.isUserInteractionEnabled = false
            let view = CategoriesCell(frame: cell.bounds)
            view.identifier = "SubCategories " + indexPath.description
            view.model.image = cellAt.image ?? ""
            view.model.title = cellAt.name ?? ""
            view.isSubcategory = true
            view.isUserInteractionEnabled = false
            cell.applyView(view: view)
            return cell
            
        case 3:
            let cell = topRatedBeachHouseCollectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
            let beach = beaches[indexPath.item]
            let view = GeneralViewCell(frame: cell.bounds)
            view.identifier = "TopRated " + indexPath.description
            view.isBeachHouseMode = true
            view.model.titleLabel = beach.name ?? ""
            view.model.infoOneLabel = "\(beach.locations?.city ?? ""), \(beach.locations?.state ?? "") \(beach.locations?.country ?? "")"
            view.model.infoTwoLabel = "\(beach.availabilities?.availableFrom?.convertToShorterDateFormat() ?? "") - \(beach.availabilities?.availableTo?.convertToShorterDateFormat() ?? "")"
            view.model.priceLabel = "₦ \(beach.pricePerNight ?? 0)"
            view.model.ratingLabel = "\(beach.rating ?? 0)"
            view.model.bannerImg = beach.rooms?.first?.images?.first?.url ?? ""
            
            cell.applyView(view: view)
            cell.layer.backgroundColor = UIColor.white.cgColor
            cell.layer.cornerRadius = 15
            return cell
                
            
        case 4:
            let cell = beachHouseCollectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
            let beach = beaches[indexPath.item]
            print("Beaches Data: \(beaches)")
            let view = GeneralViewCell(frame: cell.bounds)
            view.identifier = "BeachHouses " + indexPath.description
            view.isBeachHouseMode = true
            view.model.titleLabel = beach.name ?? ""
            view.model.infoOneLabel = "\(beach.locations?.city ?? ""), \(beach.locations?.state ?? "") \(beach.locations?.country ?? "")"
            view.model.infoTwoLabel = "\(beach.availabilities?.availableFrom?.convertToShorterDateFormat() ?? "") - \(beach.availabilities?.availableTo?.convertToShorterDateFormat() ?? "")"
            view.model.priceLabel = "₦ \(beach.pricePerNight ?? 0)"
            view.model.ratingLabel = "\(beach.rating ?? 0)"
            view.model.bannerImg = beach.rooms?.first?.images?.first?.url ?? ""

            cell.applyView(view: view)
            return cell
            
        case 5:
            let cell = topRatedBoatCollectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
            
            let boat = boats[indexPath.item]
            let view = GeneralViewCell(frame: cell.bounds)
            view.identifier = "TopRated " + indexPath.description
            view.isBoatMode = true
            view.model.titleLabel = boat.name ?? ""
            view.model.infoOneLabel = "Capacity of People: 1 - \((boat.noOfAdults ?? 0) + (boat.noOfChildren ?? 0)) "
            view.model.infoTwoLabel = "\(boat.locations?.city ?? ""), \(boat.locations?.state ?? "") \(boat.locations?.country ?? "")"
            view.model.ratingLabel = "\(boat.rating ?? 0)"
            view.model.bannerImg = boat.images?.first?.url ?? ""
            
            cell.applyView(view: view)
            cell.layer.backgroundColor = UIColor.white.cgColor
            cell.layer.cornerRadius = 15
            
            return cell
            
        case 6:
            let cell = boatCollectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
            
            let boat = boats[indexPath.item]
            print("Boat Data: \(boats)")
            let view = GeneralViewCell(frame: cell.bounds)
            view.identifier = "Boats " + indexPath.description
            view.isBoatMode = true
            view.model.titleLabel = boat.name ?? ""
            view.model.infoOneLabel = "Capacity of People: 1 - \((boat.noOfAdults ?? 0) + (boat.noOfChildren ?? 0)) )"
            view.model.infoTwoLabel = "\(boat.locations?.city ?? ""), \(boat.locations?.state ?? "") \(boat.locations?.country ?? "")"
            view.model.ratingLabel = "\(boat.rating ?? 0)"
            view.model.bannerImg = boat.images?.first?.url ?? ""

            cell.applyView(view: view)
            
            return cell
            
        case 7:
            let cell = serviceCollectionVIew.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
            
            let service = services[indexPath.item]
            
            let view = BookingViewCell(frame: cell.bounds)
            view.identifier = "Services " + indexPath.description
            view.model.date = "\(service.availabilities?.availableFrom?.convertToShorterDateFormat() ?? "") - \(service.availabilities?.availableTo?.convertToShorterDateFormat() ?? "")"
            view.model.image = service.images?.first?.url ?? ""
            view.model.location = "\(service.locations?.city ?? ""), \(service.locations?.state ?? "") \(service.locations?.country ?? "")"
            view.model.title = "\(service.name ?? "")"
            return cell
            
        default:
            return UICollectionViewCell()
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 1:
            print("DO something")
            if indexPath.item == 0{
                self.selectedBeachCat = categories.prefix(2).compactMap { $0.id }
                let selectedCategories = self.categories.filter { category in
                    let selectedBeachCat = self.selectedBeachCat
                    let categoryId = category.id ?? ""
                    return selectedBeachCat.contains(categoryId)
                }
                self.beaches = selectedCategories.compactMap { $0.listings }.flatMap { $0 }
                self.topRatedBeaches = self.beaches.filter({$0.rating == 0})
                self.topRatedBeachHouseStack.isHidden = self.topRatedBeaches.isEmpty
                self.subcategories = selectedCategories.compactMap { $0.subCategories }.flatMap { $0 }
                self.reloadCollectionViews()
                print("Beaches Data: \(self.beaches)")
                topRatedBoatStack.isHidden = true
                topRatedBeachHouseStack.isHidden = false
                boatStack.isHidden = true
                topRatedBeachHouseStack.isHidden = topRatedBeaches.isEmpty
                beachHouseStack.isHidden = false
                self.updateCollectionViewHeight(self.beachHouseCollectionView, self.beachHouseCollectionViewHeightConstraint)
                self.updateCollectionViewHeight(self.topRatedBeachHouseCollectionView, self.topRatedBeachHouseCollectionViewHeightConstraint)
                
 
            }else if indexPath.item == 1{
                self.selectedBoatCat = categories[indexPath.item].id ?? ""
                let selectedCategories = self.categories.filter { category in
                    let selectedBoatCat = self.selectedBoatCat
                    let categoryId = category.id ?? ""
                    return selectedBoatCat.contains(categoryId)
                }
                self.boats = selectedCategories.compactMap { $0.listings}.flatMap{ $0 }
                self.topRatedBoats = self.boats.filter({$0.rating == 5})
                self.topRatedBoatStack.isHidden = self.topRatedBoats.isEmpty
                self.subcategories = selectedCategories.compactMap { $0.subCategories }.flatMap { $0 }
                self.reloadCollectionViews()
                print("Boat Data: \(self.boats)")
                topRatedBoatStack.isHidden = topRatedBoats.isEmpty
                boatStack.isHidden = false
                topRatedBeachHouseStack.isHidden = true
                topRatedBoatStack.isHidden = false
                beachHouseStack.isHidden = true
                self.updateCollectionViewHeight(self.boatCollectionView, self.boatCollectionViewHeightConstraint)
                self.updateCollectionViewHeight(self.topRatedBoatCollectionView, self.topRatedBoatCollectionVIewHeightConstraint)
                
            }else if indexPath.item == 2{
                self.selectedServiceCat = categories[indexPath.item].id ?? ""
                let selectedCategories = self.categories.filter { category in
                    let selectedServiceCat = self.selectedServiceCat
                    let categoryId = category.id ?? ""
                    return selectedServiceCat.contains(categoryId)
                }
                self.services = selectedCategories.compactMap { $0.listings}.flatMap{ $0 }
                self.reloadCollectionViews()
                print("Sselected service: \(self.selectedServiceCat)")
                print("Services Data: \(self.services)")
                subcategoryCollectionView.isHidden = true
                topRatedBoatStack.isHidden = true
                boatStack.isHidden = true
                topRatedBeachHouseStack.isHidden = true
                beachHouseStack.isHidden = true

            }
            
            // Highlight the selected cell by setting a border
            if collectionView.cellForItem(at: indexPath) is DynamicCollectionViewCell {
                let selectedView = CategoriesCell()
                selectedView.model.state = true
//                selectedCell.layer.borderWidth = 3
//                selectedCell.layer.borderColor = UIColor.systemOrange.cgColor
//                selectedCell.layer.cornerRadius = 8
            }

            // Remove the border for other cells
            for cell in collectionView.visibleCells {
                guard let cardCell = cell as? DynamicCollectionViewCell else {
                    continue
                }

                if let cellIndexPath = collectionView.indexPath(for: cardCell), cellIndexPath != indexPath {
                    let selectedView = CategoriesCell()
                    selectedView.model.state = false
//                    cardCell.layer.borderWidth = 0
//                    cardCell.layer.borderColor = UIColor.clear.cgColor
                }
            }

                    
            
        case 2:
            print("Do Nothing")
        case 3:
            coordinator?.gotoBeachDetails(details: beaches[indexPath.item])
        case 4:
            coordinator?.gotoBeachDetails(details: beaches[indexPath.item])
            
        case 5:
            coordinator?.gotoBoatDetails(details: boats[indexPath.item])
        case 6:
            coordinator?.gotoBoatDetails(details: boats[indexPath.item])
        case 7:
            print("DO something")
        default:
            print("DO something")
        }
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
        case 1:
            return CGSize(width: (collectionView.bounds.width / 3) - 8, height: 94)
        case 2:
            return CGSize(width: (collectionView.bounds.width / 4), height: 50)
        case 3:
            return CGSize(width: collectionView.bounds.width - 35, height: 400)
        case 4:
            return CGSize(width: collectionView.bounds.width - 10, height: 400)
        case 5:
            return CGSize(width: collectionView.bounds.width - 35, height: 400)
        case 6:
            return CGSize(width: collectionView.bounds.width - 10, height: 400)
        case 7:
            return CGSize(width: collectionView.bounds.width, height: 94)
        default:
            return CGSize()
        }
       
    }
}


extension HomeView{
    func bind(){
        vm.transform(input: input)
        
        vm.output.subscribe(onNext: {[weak self] event in
            guard let self = self else { return }
            LoadingModal.dismiss()
            switch event {
            case .getBookingCategoriesSuccess(let response):
                print(response)
                if let responseData = response.data {
                    self.categories = responseData
                    self.selectedBeachCat = categories.prefix(2).compactMap { $0.id }
                    
                    let selectedCategories = self.categories.filter { category in
                        let selectedBeachCat = self.selectedBeachCat
                        let categoryId = category.id ?? ""
                        return selectedBeachCat.contains(categoryId)
                    }
                    self.categories = self.mergeFirstTwoCategories(categories: self.categories ) 
                    self.beaches = selectedCategories.compactMap { $0.listings }.flatMap { $0 } 
                    self.topRatedBeaches = self.beaches.filter({$0.rating == 0}) 
                    self.topRatedBeachHouseStack.isHidden = self.topRatedBeaches.isEmpty
                    self.subcategories = selectedCategories.compactMap { $0.subCategories }.flatMap { $0 } 
                    self.reloadCollectionViews()
                    print("Beaches Data: \(self.beaches)")
                    self.updateCollectionViewHeight(self.beachHouseCollectionView, self.beachHouseCollectionViewHeightConstraint)
                    self.updateCollectionViewHeight(self.topRatedBeachHouseCollectionView, self.topRatedBeachHouseCollectionViewHeightConstraint)
                    
                    
                }
                self.refreshControl.endRefreshing()
            case .getBookingCategoriesFailed(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
                self.refreshControl.endRefreshing()
            }
        }).disposed(by: disposeBag)
    }
    
    func reloadCollectionViews(){
        categoryCollectionView.reloadData()
        subcategoryCollectionView.reloadData()
        beachHouseCollectionView.reloadData()
        topRatedBeachHouseCollectionView.reloadData()
        topRatedBoatCollectionView.reloadData()
        boatCollectionView.reloadData()
        serviceCollectionVIew.reloadData()
    }
    
    func mergeFirstTwoCategories(categories: [PropertyCategory]) -> [PropertyCategory] {
        // Ensure there are at least two categories to merge
        guard categories.count > 1 else { return categories }
        
        // Get the first two categories
        var updatedCategories = categories
        let firstCategory = updatedCategories[0]
        let secondCategory = updatedCategories[1]
        
        // Merge listings
        let mergedListings = (firstCategory.listings ?? []) + (secondCategory.listings ?? [])
        
        // Merge subcategories (if needed)
        let mergedSubCategories = (firstCategory.subCategories ?? []) + (secondCategory.subCategories ?? [])
        
        // Create the merged category
        let mergedCategory = PropertyCategory(
            id: firstCategory.id,
            name: firstCategory.name, // Use the name of the first category
            propertyType: firstCategory.propertyType, // Optionally keep the property type of the first
            description: firstCategory.description, // Optionally keep the description of the first
            image: firstCategory.image, // Optionally keep the image of the first
            subCategories: mergedSubCategories,
            listings: mergedListings
        )
        
        // Update the array
        updatedCategories[0] = mergedCategory // Replace the first category with the merged one
        updatedCategories.remove(at: 1)       // Remove the second category
        
        return updatedCategories
    }

}

enum CollectionViewType: Int {
    case category = 1
    case subcategory = 2
    case topRatedBeachHouse = 3
    case beachHouse = 4
    case topRatedBoat = 5
    case boat = 6
    case service = 7
}

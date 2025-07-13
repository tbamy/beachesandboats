//
//  HomeView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 03/09/2024.
//


import UIKit
import RxSwift

class HomeView: BaseViewControllerPlain, UITextFieldDelegate {
    
    // MARK: - Properties
    var coordinator: ExploreCoordinator?
    
    @IBOutlet weak var filterBtn: UIImageView!
//    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchField: InputField!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var subcategoryCollectionView: UICollectionView!
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
    
    private lazy var refreshControl = UIRefreshControl()
//    var searchFilter: GetBookingCategorySearchRequest?
    
    // MARK: - Data Properties
    private var originalCategories: [PropertyCategory] = []
    private var categories: [PropertyCategory] = []
    private var subcategories: [SubCategory] = []
    private var boats: [Listing] = []
    private var beaches: [Listing] = []
    private var services: [BeachHouseBooking] = []
    private var topRatedBoats: [Listing] = []
    private var topRatedBeaches: [Listing] = []
    
    private var selectedBeachCat: [String] = []
    private var selectedBoatCat: String = ""
    private var selectedServiceCat: String = ""
    private var selectedCatIndex: Int = 0
    
    private var isShowingBeachHouses: Bool = true
    private var isShowingBoats: Bool = false
    private var isShowingServices: Bool = false
    
    
    var boatFilterData: BoatDatas?
    var beachFilterData: BeachDatas?
    
    var filterType = ""
    
    // MARK: - Constants
    private struct Constants {
        static let topRatingThresholdBeach = 5
        static let topRatingThresholdBoat = 5
        static let categoryImageMapping: [String: String] = [
            "Beach Houses": "beachCat",
            "Boats": "boatsCat",
            "Services": "serviceCat"
        ]
    }
    
    private let vm = HomeViewVM()
    private let beachVM = BeachDataViewModel()
    private let boatVM = BoatDataViewModel()
    private let disposeBag = DisposeBag()
    private let input = PublishSubject<HomeViewVM.Input>()
    
    private var searchTimer: Timer?
    private let searchDelay: TimeInterval = 0.5
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureCollectionViews()
        setupRefreshControl()
        bindViewModel()
        loadInitialData()
    }
    
    // Make sure to invalidate timer when view disappears
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchTimer?.invalidate()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        navigationItem.hidesBackButton = true
        hideAllStacks()
        addShadow(to: subcategoryCollectionView)
//        addShadow(to: searchView)
        setupSearchField()
        setupFilterBtn()
        searchField.textField.delegate = self
    }
    
    private func hideAllStacks() {
        [topRatedBoatStack, boatStack, serviceStack].forEach { $0?.isHidden = true }
    }
    
    private func setupFilterBtn() {
        filterBtn.isUserInteractionEnabled = true
        filterBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(filterTapped)))
    }
    
    private func setupSearchField() {
        
        // Option 2b: Alternative - using the existing textChanged callback with debouncing
        searchField.textChanged = { [weak self] textField, range, replacementString in
            guard let self = self else { return }
            
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: replacementString)
            
            // Cancel previous timer
            self.searchTimer?.invalidate()
            
            // Schedule new search
            self.searchTimer = Timer.scheduledTimer(withTimeInterval: self.searchDelay, repeats: false) { _ in
                self.performSearch(with: updatedText)
            }
        }
    }
    
    // Add this method to handle the search
    private func performSearch(with query: String) {
        if query.isEmpty {
            // Reset to original data
            categories = originalCategories
            reloadAllCollectionViews()
        } else {
            // Perform search
            loadDataWithSearch()
        }
    }
    
    // Update your existing textFieldShouldReturn method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        // Cancel any pending search timer since user pressed return
        searchTimer?.invalidate()
        
        if let query = textField.text, !query.isEmpty {
            loadDataWithSearch()
        } else {
            categories = originalCategories
            reloadAllCollectionViews()
        }
        
        return true
    }



    
    private func setupRefreshControl() {
        refreshControl.tintColor = UIColor.beachBlue
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        scrollView.addSubview(refreshControl)
    }
    
    private func configureCollectionViews() {
        let collectionViews: [(UICollectionView, CollectionViewType)] = [
            (categoryCollectionView, .category),
            (subcategoryCollectionView, .subcategory),
            (beachHouseCollectionView, .beachHouse),
            (boatCollectionView, .boat),
            (topRatedBeachHouseCollectionView, .topRatedBeachHouse),
            (topRatedBoatCollectionView, .topRatedBoat),
            (serviceCollectionVIew, .service)
        ]
        
        collectionViews.forEach { collectionView, type in
            configureCollectionView(collectionView, tag: type.rawValue)
        }
    }
    
    private func configureCollectionView(_ collectionView: UICollectionView, tag: Int) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.tag = tag
        collectionView.backgroundColor = .clear
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
    }
    
    
    private func loadInitialData() {
        LoadingModal.show()
        input.onNext(.getBookingCategories(filter: GetBookingCategorySearchRequest()))
        beachVM.getBeachData()
        boatVM.getBoatData()
    }
    
    private func loadDataWithSearch() {
        LoadingModal.show()
        let searchParam = searchField.text
        
        
        if isShowingBeachHouses {
            filterType = "BeachHouse"
        }else if isShowingBoats {
            filterType = "Boat"
        }else if isShowingServices{
            filterType = "Service"
        }
            
        
        let searchFilter = GetBookingCategorySearchRequest(filterType: filterType ,searchQuery: searchParam)
            
            print("searchFilter: \(searchFilter)")
            
            input.onNext(.getBookingCategories(filter: searchFilter ))
        
    }
    
    @objc private func filterTapped() {
        if isShowingBeachHouses {
            filterType = "BeachHouse"
        }else if isShowingBoats {
            filterType = "Boat"
        }else if isShowingServices{
            filterType = "Service"
        }
        
        var filterPropertyTypes: [FilterPropertyTypes]?
        var amenities: [RoomAmenities]?
        if filterType == "BeachHouse" {
            amenities = beachFilterData?.amenities
            filterPropertyTypes = (beachFilterData?.categories ?? []).compactMap { category in
                guard let id = category.id, let name = category.name else {
                    return nil
                }
                return FilterPropertyTypes(id: id, name: name)
            }

        }else if filterType == "Boat" {
            amenities = boatFilterData?.amenities
            filterPropertyTypes = (boatFilterData?.categories ?? []).compactMap { category in
                guard let id = category.id, let name = category.name else {
                    return nil
                }
                return FilterPropertyTypes(id: id, name: name)
            }
        }else{
            amenities = beachFilterData?.amenities
            filterPropertyTypes = (beachFilterData?.categories ?? []).compactMap { category in
                guard let id = category.id, let name = category.name else {
                    return nil
                }
                return FilterPropertyTypes(id: id, name: name)
            }
        }
        
        FilterModal.startFilterModal(propertyTypes: filterPropertyTypes ?? [], amenities: amenities ?? [], filterType: filterType, callBack: { [weak self] item in
            LoadingModal.show()
            print("Request: \(item)")
            
            self?.input.onNext(.getBookingCategories(filter: item ?? GetBookingCategorySearchRequest() ))
        }, clearAll: { [weak self] in
            self?.categories = self?.originalCategories ?? []
            self?.reloadAllCollectionViews()
        })
    }
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        let searchFilter = GetBookingCategorySearchRequest(page: 1)
        input.onNext(.getBookingCategories(filter: searchFilter))
    }
    
    // MARK: - UI Helper Methods
    private func addShadow(to view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 2
        view.layer.masksToBounds = false
    }
    
    private func updateCollectionViewHeight(_ collectionView: UICollectionView, _ heightConstraint: NSLayoutConstraint) {
        collectionView.layoutIfNeeded()
        heightConstraint.constant = collectionView.contentSize.height
        view.layoutIfNeeded()
    }
    
    private func reloadAllCollectionViews() {
        [categoryCollectionView, subcategoryCollectionView, beachHouseCollectionView,
         topRatedBeachHouseCollectionView, topRatedBoatCollectionView,
         boatCollectionView, serviceCollectionVIew].forEach { $0?.reloadData() }
    }
    
    // MARK: - Data Processing
    private func processBeachHouseSelection() {
        selectedBeachCat = Array(categories.prefix(2).compactMap { $0.id })
        let selectedCategories = categories.filter { selectedBeachCat.contains($0.id ?? "") }
        
        beaches = selectedCategories.flatMap { $0.listings ?? [] }
        topRatedBeaches = beaches.filter { Int(($0.rating)) >= Constants.topRatingThresholdBeach }
        subcategories = selectedCategories.flatMap { $0.subCategories ?? [] }
        
        DispatchQueue.main.async {
            self.updateUIForBeachHouseSelection()
        }
    }
    
    private func processBoatSelection(at index: Int) {
        selectedBoatCat = categories[index].id ?? ""
        let selectedCategories = categories.filter { $0.id == selectedBoatCat }
        
        boats = selectedCategories.flatMap { $0.listings ?? [] }
        topRatedBoats = boats.filter { Int(($0.rating)) >= Constants.topRatingThresholdBoat }
        subcategories = selectedCategories.flatMap { $0.subCategories ?? [] }
        
        DispatchQueue.main.async {
            self.updateUIForBoatSelection()
        }
    }
    
    private func processServiceSelection(at index: Int) {
        selectedServiceCat = categories[index].id ?? ""
        let selectedCategories = categories.filter { $0.id == selectedServiceCat }
        
        services = selectedCategories.flatMap { $0.beachHouseBookings ?? [] }
        print("Selected service: \(selectedServiceCat)")
//        print("services: \(services)")
        print("services: \(services)")
//        print(services)
        DispatchQueue.main.async {
            self.updateUIForServiceSelection()
        }
        
    }
    
    // MARK: - UI State Updates
    private func updateUIForBeachHouseSelection() {
        subcategoryCollectionView.isHidden = false
        topRatedBoatStack.isHidden = true
        boatStack.isHidden = true
        serviceStack.isHidden = true
        
        topRatedBeachHouseStack.isHidden = topRatedBeaches.isEmpty
        beachHouseStack.isHidden = false
        
        updateCollectionViewHeight(beachHouseCollectionView, beachHouseCollectionViewHeightConstraint)
        updateCollectionViewHeight(topRatedBeachHouseCollectionView, topRatedBeachHouseCollectionViewHeightConstraint)
    }
    
    private func updateUIForBoatSelection() {
        subcategoryCollectionView.isHidden = false
        topRatedBeachHouseStack.isHidden = true
        beachHouseStack.isHidden = true
        serviceStack.isHidden = true
        
        topRatedBoatStack.isHidden = topRatedBoats.isEmpty
        boatStack.isHidden = false
        
        updateCollectionViewHeight(boatCollectionView, boatCollectionViewHeightConstraint)
        updateCollectionViewHeight(topRatedBoatCollectionView, topRatedBoatCollectionVIewHeightConstraint)
    }
    
    private func updateUIForServiceSelection() {
        subcategoryCollectionView.isHidden = true
        topRatedBoatStack.isHidden = true
        boatStack.isHidden = true
        topRatedBeachHouseStack.isHidden = true
        beachHouseStack.isHidden = true
        serviceStack.isHidden = false
        
        updateCollectionViewHeight(serviceCollectionVIew, serviceCollectionVIewHeightConstraint)
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension HomeView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let type = CollectionViewType(rawValue: collectionView.tag) else { return 0 }
        
        switch type {
        case .category: return categories.count
        case .subcategory: return subcategories.count
        case .topRatedBeachHouse: return topRatedBeaches.count
        case .beachHouse: return beaches.count
        case .topRatedBoat: return topRatedBoats.count
        case .boat: return boats.count
        case .service: return services.count
            print(services.count)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let type = CollectionViewType(rawValue: collectionView.tag) else {
            return UICollectionViewCell()
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
        
        switch type {
        case .category:
            configureCategoryCell(cell, at: indexPath)
        case .subcategory:
            configureSubcategoryCell(cell, at: indexPath)
        case .topRatedBeachHouse:
            configureBeachHouseCell(cell, at: indexPath, data: topRatedBeaches)
        case .beachHouse:
            configureBeachHouseCell(cell, at: indexPath, data: beaches)
        case .topRatedBoat:
            configureBoatCell(cell, at: indexPath, data: topRatedBoats)
        case .boat:
            configureBoatCell(cell, at: indexPath, data: boats)
        case .service:
            configureServiceCell(cell, at: indexPath)
        }
        
        return cell
    }
    
    // MARK: - Cell Configuration Methods
    private func configureCategoryCell(_ cell: DynamicCollectionViewCell, at indexPath: IndexPath) {
        let category = categories[indexPath.item]
        let view = CategoriesCell(frame: cell.bounds)
        
        view.identifier = "Categories \(indexPath.description)"
        view.model.image = category.image ?? ""
        view.model.title = category.name ?? ""
        view.model.dummyImage = Constants.categoryImageMapping[category.name ?? ""] ?? "dummy"
        view.model.state = (indexPath.item == selectedCatIndex)
        
        cell.applyView(view: view)
    }
    
    private func configureSubcategoryCell(_ cell: DynamicCollectionViewCell, at indexPath: IndexPath) {
        let subcategory = subcategories[indexPath.item]
        let view = CategoriesCell(frame: cell.bounds)
        
        view.identifier = "SubCategories \(indexPath.description)"
        view.model.image = subcategory.icon ?? ""
        view.model.title = subcategory.name
        view.model.dummyImage = "luxuryIcon"
        view.isSubcategory = true
        view.isUserInteractionEnabled = false
        
        cell.isUserInteractionEnabled = false
        cell.applyView(view: view)
    }
    
    private func configureBeachHouseCell(_ cell: DynamicCollectionViewCell, at indexPath: IndexPath, data: [Listing]) {
        let beach = data[indexPath.item]
        let view = GeneralViewCell(frame: cell.bounds)
        
        view.identifier = "BeachHouses \(indexPath.description)"
        view.isBeachHouseMode = true
        view.model.titleLabel = beach.name
        view.model.infoOneLabel = formatLocationString(beach.locations)
        view.model.infoTwoLabel = formatDateRange(from: beach.availabilities?.availableFrom,
                                                 to: beach.availabilities?.availableTo)
        view.model.priceLabel = "₦ \(beach.minRoomPricePerNight ?? "0")"
        view.model.ratingLabel = "\(beach.rating)"
        view.model.bannerImg = beach.rooms?.first?.images?.first?.url ?? ""
        
        view.onSaveFavouriteTapped = { [weak self] in
            self?.saveFavourite(itemId: beach.id, type: .BeachHouse)
        }
        
        cell.applyView(view: view)
        cell.layer.backgroundColor = UIColor.white.cgColor
        cell.layer.cornerRadius = 15
    }
    
    private func configureBoatCell(_ cell: DynamicCollectionViewCell, at indexPath: IndexPath, data: [Listing]) {
        let boat = data[indexPath.item]
        let view = GeneralViewCell(frame: cell.bounds)
        
        view.identifier = "Boats \(indexPath.description)"
        view.isBoatMode = true
        view.model.titleLabel = boat.name
        view.model.infoOneLabel = "Capacity: 1 - \((Int(boat.noOfAdults ?? "0") ?? 0) + (Int(boat.noOfChildren ?? "0") ?? 1))"
        view.model.infoTwoLabel = formatLocationString(boat.locations)
        view.model.ratingLabel = "\(boat.rating)"
        view.model.bannerImg = boat.images?.first?.url ?? ""
        let destinations: [Destination] = boat.destinations ?? []
        if destinations.contains(where: { $0.name == "Cruising"}) && destinations.count == 1{
            view.model.ribbonTagLabel = "Cruising"
        }else if destinations.contains(where: { $0.name == "Cruising"}) && destinations.count > 1{
            view.model.ribbonTagLabel = "Cruising + Travel destinations"
        }else{
            view.model.ribbonTagLabel = "Travel destinations"
        }
        
        
        
        view.onSaveFavouriteTapped = { [weak self] in
            self?.saveFavourite(itemId: boat.id, type: .Boat)
        }
        
        cell.applyView(view: view)
        cell.layer.backgroundColor = UIColor.white.cgColor
        cell.layer.cornerRadius = 15
    }
    
    private func configureServiceCell(_ cell: DynamicCollectionViewCell, at indexPath: IndexPath) {
        let service = services[indexPath.item]
        let view = BookingCell(frame: cell.bounds)
        
        view.identifier = "Services \(indexPath.description)"
        view.model.date = formatDateRange(from: service.checkingDate, to: service.checkoutDate)
        view.model.image = service.beachHouse?.image ?? ""
        view.model.location = formatLocationString(service.beachHouse?.locations)
        view.model.title = service.beachHouse?.name ?? ""
        
        cell.applyView(view: view)
    }
    
    // MARK: - Selection Handling
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let type = CollectionViewType(rawValue: collectionView.tag) else { return }
        
        switch type {
        case .category:
            handleCategorySelection(at: indexPath.item)
        case .subcategory:
            break
        case .topRatedBeachHouse:
            coordinator?.gotoBeachDetails(id: topRatedBeaches[indexPath.item].id)
        case .beachHouse:
            coordinator?.gotoBeachDetails(id: beaches[indexPath.item].id)
        case .topRatedBoat:
            coordinator?.gotoBoatDetails(id: topRatedBoats[indexPath.item].id)
        case .boat:
            coordinator?.gotoBoatDetails(id: boats[indexPath.item].id)
        case .service:
            selectServiceProvider()
        }
    }
    
    private func handleCategorySelection(at index: Int) {
        selectedCatIndex = index
        categoryCollectionView.reloadData()
        
        switch index {
        case 0:
            processBeachHouseSelection()
            isShowingBeachHouses = true
            isShowingBoats = false
            isShowingServices = false
            
        case 1:
            processBoatSelection(at: index)
            isShowingBeachHouses = false
            isShowingBoats = true
            isShowingServices = false
        case 2:
            processServiceSelection(at: index)
            isShowingBeachHouses = false
            isShowingBoats = false
            isShowingServices = true
        default:
            break
        }
        
        reloadAllCollectionViews()
    }
    
    // MARK: - Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let type = CollectionViewType(rawValue: collectionView.tag) else {
            return CGSize.zero
        }
        
        switch type {
        case .category:
            return CGSize(width: (collectionView.bounds.width / 3) - 8, height: 94)
        case .subcategory:
            return CGSize(width: collectionView.bounds.width / 4, height: 50)
        case .topRatedBeachHouse, .topRatedBoat:
            return CGSize(width: collectionView.bounds.width - 35, height: 420)
        case .beachHouse, .boat:
            return CGSize(width: collectionView.bounds.width - 10, height: 420)
        case .service:
            return CGSize(width: collectionView.bounds.width, height: 94)
        }
    }
}

// MARK: - Helper Methods
private extension HomeView {
    func formatLocationString(_ location: Location?) -> String {
        guard let location = location else { return "" }
        return "\(location.city ?? ""), \(location.state ?? "") \(location.country ?? "")"
    }
    
    func formatDateRange(from: String?, to: String?) -> String {
        let fromDate = from?.convertToShorterDateFormat() ?? ""
        let toDate = to?.convertToShorterDateFormat() ?? ""
        return "\(fromDate) - \(toDate)"
    }
    
    func saveFavourite(itemId: String?, type: BookingType) {
        guard let id = itemId else { return }
        let request = AddFavouriteRequest(itemId: id, type: type.rawValue, note: "")
        input.onNext(.addFavourite(request))
        Toast.show(message: "Saving Favourite")
    }
}

// MARK: - ViewModel Binding
extension HomeView {
    private func bindViewModel() {
        vm.transform(input: input)
        
        vm.output.subscribe(onNext: { [weak self] event in
            guard let self = self else { return }
            LoadingModal.dismiss()
            self.handleViewModelOutput(event)
        }).disposed(by: disposeBag)
        
        beachVM.output.subscribe(onNext: { [weak self] event in
            switch event {
            case .getBeachDataSuccess(let response):
//                LoadingModal.dismiss()
                self?.beachFilterData = response.data
            case .getBeachDataError(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
        }).disposed(by: disposeBag)
        
        
        boatVM.output.subscribe(onNext: { [weak self] event in
            switch event {
            case .getBoatDataSuccess(let response):
//                LoadingModal.dismiss()
                self?.boatFilterData = response.data
            case .getBoatDataError(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
        }).disposed(by: disposeBag)
    }
    
    private func handleViewModelOutput(_ event: HomeViewVM.Output) {
        switch event {
        case .getBookingCategoriesSuccess(let response):
            handleCategoriesSuccess(response)
        case .getBookingCategoriesFailed(let error):
            handleCategoriesError(error)
        case .addFavouriteSuccess(let response):
            Toast.show(message: response.message ?? "Saved to Favourites")
        case .addFavouriteFailed(let error):
            Toast.show(message: error.message ?? "Error Saving to Favourites")
        }
    }
    
    private func handleCategoriesSuccess(_ response: GetBookingCategoryResponse) {
        guard let responseData = response.data else { return }
        
        categories = mapCategories(categories: responseData)
        originalCategories = categories
        processBeachHouseSelection()
        reloadAllCollectionViews()
        
        updateCollectionViewHeight(beachHouseCollectionView, beachHouseCollectionViewHeightConstraint)
        updateCollectionViewHeight(topRatedBeachHouseCollectionView, topRatedBeachHouseCollectionViewHeightConstraint)
        
        refreshControl.endRefreshing()
    }
    
    private func handleCategoriesError(_ error: ErrorResponse) {
        MiddleModal.show(title: error.message ?? "", type: .error, dismissable: false, onConfirm: { self.loadInitialData() })
        refreshControl.endRefreshing()
    }
    
    private func mapCategories(categories: [PropertyCategory]) -> [PropertyCategory] {
        let targetCategoryNames = Array(Constants.categoryImageMapping.keys) // ["Beach Houses", "Boats", "Services"]
        
        // Filter categories to only include those with names in the mapping
        let filteredCategories = categories.filter { category in
            guard let categoryName = category.name else { return false }
            return targetCategoryNames.contains(categoryName)
        }
        
        print("Filtered Categories are: \(filteredCategories)")
        
        // Find Beach Houses and Boats categories specifically for merging
        guard let beachHousesCategory = filteredCategories.first(where: { $0.name == "Beach Houses" }),
              let boatsCategory = filteredCategories.first(where: { $0.name == "Boats" }) else {
            return filteredCategories
        }
        
        // Merge Beach Houses and Boats listings and subcategories
        let mergedListings = (beachHousesCategory.listings ?? []) + (boatsCategory.listings ?? [])
        let mergedSubCategories = (beachHousesCategory.subCategories ?? []) + (boatsCategory.subCategories ?? [])
        
        let mergedBeachHousesCategory = PropertyCategory(
            id: beachHousesCategory.id,
            name: beachHousesCategory.name,
            propertyType: beachHousesCategory.propertyType,
            description: beachHousesCategory.description,
            image: beachHousesCategory.image,
            subCategories: mergedSubCategories,
            listings: mergedListings,
            boatBookings: beachHousesCategory.boatBookings,
            beachHouseBookings: beachHousesCategory.beachHouseBookings
        )
        
        // Create final array with merged Beach Houses category, original Boats category, and Services category
        var finalCategories: [PropertyCategory] = [mergedBeachHousesCategory]
        
        // Add Boats category (unchanged)
        finalCategories.append(boatsCategory)
        
        // Add Services category if it exists
        if let servicesCategory = filteredCategories.first(where: { $0.name == "Services" }) {
            finalCategories.append(servicesCategory)
        }
        
        return finalCategories
    }
    
    private func selectServiceProvider() {
        SelectServiceModal.show { [weak self] selected in
            switch selected {
            case "CHEF":
                self?.coordinator?.gotoFindChef()
            case "BOUNCER":
                self?.coordinator?.gotoFindBouncer()
            case "DJ":
                self?.coordinator?.gotoFindDj()
            default:
                break
            }
        }
    }
}

// MARK: - Enums
enum CollectionViewType: Int {
    case category = 1
    case subcategory = 2
    case topRatedBeachHouse = 3
    case beachHouse = 4
    case topRatedBoat = 5
    case boat = 6
    case service = 7
}

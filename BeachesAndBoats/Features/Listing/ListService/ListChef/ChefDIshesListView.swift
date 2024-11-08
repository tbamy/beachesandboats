//
//  ChefDIshesListView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/10/2024.
//

import UIKit
import RxSwift

class ChefDIshesListView: BaseViewControllerPlain {
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var createServiceListing: CreateServiceListingRequest?
    var selectedItems: [String] = []
    
    var vm = ChefDishesViewModel()
    var disposeBag = DisposeBag()
    
    var chefDishes: [DishesData]?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chefs"
        setup()
        LoadingModal.show()
        vm.getChefDishes()
        bindNetwork()
    }
    
    func setup(){
        stepOneProgress.setProgress(0.60, animated: true)
        stepOneProgress.tintColor = .B_B
        stepTwoProgress.setProgress(0, animated: false)
        
        collectionView.backgroundColor = UIColor.background.lighter(by: 17)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
    }
    
    func bindNetwork(){
        vm.output.subscribe(onNext: { [weak self] response in
            LoadingModal.dismiss()
            
            switch response {
            case .getChefDishesSuccess(let response):
                self?.chefDishes = response.data.dishes
                self?.collectionView.reloadData()
            case .getChefDishesError(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
            
            
        }).disposed(by: disposeBag)
    }

    @IBAction func nextTapped(_ sender: Any) {

        let request = CreateServiceListingRequest(name: createServiceListing?.name ?? "", description: createServiceListing?.description ?? "", profile_image: createServiceListing?.profile_image ?? Data(), from_when: createServiceListing?.from_when ?? "", to_when: createServiceListing?.to_when ?? "", dishes: selectedItems, price: 0, sample_images: [], type: "", gender: createServiceListing?.gender ?? "")
        
        coordinator?.gotoChefPriceView(createServiceListingData: request)
    }
    

}

extension ChefDIshesListView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chefDishes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell

        cell.isUserInteractionEnabled = true
        let view = SelectableCheckbox(frame: cell.bounds)
        view.identifier = "Amenities Cell " + indexPath.description
        let item = chefDishes?[indexPath.row]
        
        let itemId = item?.dish_id ?? ""
        if selectedItems.contains(itemId) {
            view.model.state = true
        } else {
            view.model.state = false
        }
        
        view.model.subtitle = item?.name ?? ""
        view.isUserInteractionEnabled = false
        cell.applyView(view: view)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthOfScreen: CGFloat = collectionView.bounds.width
//        let heightOfScreen = collectionView.bounds.height
        return CGSize(width: widthOfScreen, height: 35)
       
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DynamicCollectionViewCell
        let view = SelectableCheckbox(frame: cell.bounds)
        guard let item = chefDishes?[indexPath.row] else { return }
        
        let itemId = item.dish_id
        
        if selectedItems.contains(itemId) {
            selectedItems.removeAll { $0 == itemId }
            view.model.state = true
//            view.model.image = UIImage.uncheckIcon
        } else {
            selectedItems.append(itemId)
            view.model.state = false
//            view.model.image = UIImage.checkIcon
        }
        
        collectionView.reloadItems(at: [indexPath])
            
        nextBtn.isEnabled = true
    }

    
}

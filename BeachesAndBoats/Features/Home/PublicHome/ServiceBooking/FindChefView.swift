//
//  FindChefView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 30/01/2025.
//

import UIKit
import RxSwift

class FindChefView: BaseViewControllerPlain {
    var coordinator: ExploreCoordinator?
    
    @IBOutlet weak var dateField: HorizonDateField!
    @IBOutlet weak var dishTypesField: DropDown!
    @IBOutlet weak var numberOfPeopleStack: UIStackView!
    @IBOutlet weak var numberOfPeopleCollectionView: UICollectionView!
    
    var numberOfPeople: [String]?
    var selectedNumber: String?
    var dishesData: [PickerItem]?
    var day: Date?
    
    let vm = FindServiceProviderVM()
    let disposeBag = DisposeBag()
    let input = PublishSubject<FindServiceProviderVM.Input>()
    
    var findChefResponse: FindServiceProviderResponse?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Chef"
        
        bind()
        input.onNext(.getAllDishes)
        LoadingModal.show()
        setup()
    }
    
    func setup(){
        dishTypesField.pickerTitle = "Select Dishes"
        numberOfPeople = ["1 - 3 People",
                          "4 - 6 People",
                          "7 - 10 People",
                          "10 - 15 People",
                          "15 - 20 People",
                          "21 - 30 People",
                          "31 - 50 People",
                          "50+ People"
        ]
        
        dateField.placeholder = "Select available date from calendar"
        dateField.placeHolderColor = .B_B
        dateField.onDateSelected = { (date) in
            self.day = date
            self.dateField.text = "\(date.toFormattedDate())"
        }
        numberOfPeopleStack.isHidden = true
        numberOfPeopleCollectionView.delegate = self
        numberOfPeopleCollectionView.dataSource = self
        numberOfPeopleCollectionView.backgroundColor = .clear
        numberOfPeopleCollectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
    }

    @IBAction func findChefTapped(_ sender: Any) {
        let request = dishTypesField.selectedItem?.value ?? ""
        if request == ""{
            MiddleModal.show(title: "Select a dish", type: .error)
        }else{
            input.onNext(.findChef(request))
            LoadingModal.show()
        }
    }
    
    func bind(){
        vm.transform(input: input)
        
        vm.chefOutput.subscribe(onNext: {[weak self] event in
            guard let self = self else { return }

            LoadingModal.dismiss()
            switch event {
            case .findChefSuccessful(let response):
                self.findChefResponse = response
                if let chefResponse = findChefResponse{
                    if let chefData = chefResponse.data, !chefData.isEmpty{
                        self.coordinator?.gotoRecommentdations(data: chefResponse, provider: "Chef")
                    }else{
                        MiddleModal.show(title: "Oops!", subtitle: "No Data returned for your search, try another", type: .error)
                    }
                    
                }
            case .findChefFailed(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
                
            case .getAllDishesSuccessful(let response):
                dishesData = self.convertDishesToPickerItems(response: response)
                if let dishesData = dishesData{
                    dishTypesField.items = dishesData
                }
            case .getAllDishesFailed(let error):
                MiddleModal.show(title: error.message ?? "", type: .error, dismissable: false, onConfirm: {self.coordinator?.pop() })
            }
        }).disposed(by: disposeBag)
    }
    
    func convertDishesToPickerItems(response: GetAllDishesResponse) -> [PickerItem] {
        guard let dishes = response.data else { return [] }
        return dishes.map { PickerItem(name: $0.name, value: $0.id) }
    }



}

extension FindChefView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfPeople?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = numberOfPeopleCollectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
        let name = numberOfPeople?[indexPath.item]
        
        let view = CatViewCell(frame: cell.bounds)
        view.identifier = "Amenitiess " + indexPath.description
        view.hasImage = false
        view.model.title = name ?? ""
        
        cell.applyView(view: view)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedNumber = numberOfPeople?[indexPath.item]
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width / 4) - 5, height: 20)
    }
    
}

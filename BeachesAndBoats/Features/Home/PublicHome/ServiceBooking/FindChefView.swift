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
    var propertyType: String?
    var bookingId: String?
    var startDate: String?
    var endDate: String?
    
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
        // Enable multiple selection mode
        dishTypesField.allowMultipleSelection = true
        dishTypesField.pickerTitle = "Select Dishes"
        
        // Handle multiple selection callback
        dishTypesField.itemsChanged = { [weak self] selectedItems in
            print("Selected dishes: \(selectedItems.map { $0.name })")
        }
        
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
        dateField.startDate = startDate?.convertFromBackendDateString() ?? Date()
        dateField.endDate = endDate?.convertFromBackendDateString() ?? Date()
        dateField.isSingleDate = true
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
        let selectedDishes = dishTypesField.selectedItems
        
        if selectedDishes.isEmpty {
            MiddleModal.show(title: "Select at least one dish", type: .error)
        } else {
            // Join multiple dish IDs with comma (adjust based on your API requirements)
            let dishIds = selectedDishes.map { $0.value }.joined(separator: ",")
            input.onNext(.findChef(dishIds))
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
                        self.coordinator?.gotoRecommentdations(propertyType: propertyType ?? "", bookingId: bookingId ?? "", data: chefResponse, provider: "Chef")
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
        
        let cellWidth = calculateItemWidth(for: name ?? "")
        
        let view = SelectableViewWithBg(frame: CGRect(x: 0, y: 0, width: cellWidth, height: 40))
        view.identifier = "Chefs " + indexPath.description
        view.titleOnlyMode = true
        view.model.title = name ?? ""
        view.model.state = (indexPath.item == Int(selectedNumber ?? "0"))
        view.setState()
        
        cell.applyView(view: view)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedNumber = numberOfPeople?[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width / 3) - 5, height: 40)
    }
    
    private func calculateItemWidth(for text: String) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 16, weight: .medium)
        let textSize = text.size(withAttributes: [NSAttributedString.Key.font: font])
        
        let horizontalPadding: CGFloat = 20
        let minimumWidth: CGFloat = 60
        let buffer: CGFloat = 8
        let calculatedWidth = textSize.width + horizontalPadding + buffer
        
        return max(calculatedWidth, minimumWidth)
    }
}

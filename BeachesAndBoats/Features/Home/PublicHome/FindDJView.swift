//
//  FindDJView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 30/01/2025.
//

import UIKit
import RxSwift

class FindDJView: BaseViewControllerPlain {
    var coordinator: ExploreCoordinator?
    
    @IBOutlet weak var dateField: HorizonDateField!
    @IBOutlet weak var numberOfPeopleCollectionView: UICollectionView!
    
    var numberOfPeople: [String]?
    var selectedNumber: String?
    
    let vm = FindServiceProviderVM()
    let disposeBag = DisposeBag()
    let input = PublishSubject<FindServiceProviderVM.Input>()
    
    var findDjResponse: FindServiceProviderResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Dj"
        
        bind()
        setup()
    }
    
    func setup(){
        
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
        
        numberOfPeopleCollectionView.delegate = self
        numberOfPeopleCollectionView.dataSource = self
        numberOfPeopleCollectionView.backgroundColor = .clear
        numberOfPeopleCollectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
    }
    
    @IBAction func findDjTapped(_ sender: Any) {
        input.onNext(.findDj)
        LoadingModal.show()
    }


    func bind(){
        vm.transform(input: input)
        
        vm.djOutput.subscribe(onNext: {[weak self] event in
            guard let self = self else { return }
            LoadingModal.dismiss()
            switch event {
            case .findDjSuccessful(let response):
                self.findDjResponse = response
                if let djResponse = findDjResponse{
                    self.coordinator?.gotoRecommentdations(data: djResponse, provider: "Dj")
                }
            case .findDjFailed(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
                
            }
        }).disposed(by: disposeBag)
    }

}

extension FindDJView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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

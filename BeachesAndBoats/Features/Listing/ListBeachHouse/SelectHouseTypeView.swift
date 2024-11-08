//
//  SelectHouseTypeView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 30/09/2024.
//

import UIKit
import RxSwift

class SelectHouseTypeView: BaseViewControllerPlain {

    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var beachDataR: BeachDatas?
    var houseTypes: [BeachCategory]?
    
    var vm = BeachDataViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beaches Houses"
        LoadingModal.show()
        vm.getBeachData()
        bindNetwork()
        setUp()
        
    }
    
    func setUp(){
        stepOneProgress.setProgress(0.1, animated: true)
        stepOneProgress.tintColor = .B_B
        stepTwoProgress.setProgress(0, animated: false)
        
        collectionView.backgroundColor = UIColor.background.lighter(by: 17)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "HouseTypeViewCell", bundle: nil), forCellWithReuseIdentifier: "HouseTypeViewCell")
    }
    
    func bindNetwork(){
        vm.output.subscribe(onNext: { [weak self] response in
            LoadingModal.dismiss()
            
            switch response {
            case .getBeachDataSuccess(let response):
                self?.beachDataR = response.data
                self?.houseTypes = response.data.categories
                self?.collectionView.reloadData()
            case .getBeachDataError(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
            
            
        }).disposed(by: disposeBag)
    }

}

extension SelectHouseTypeView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return houseTypes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HouseTypeViewCell", for: indexPath) as! HouseTypeViewCell
        
        cell.updateContent(data: houseTypes?[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Go to next screen")
        let cat = houseTypes?[indexPath.item].categoryID ?? ""
        if let beachDataR = beachDataR{
            coordinator?.gotoHouseTypeListView(beachData: beachDataR, cat: cat)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthOfScreen: CGFloat = collectionView.bounds.width - 80
        let heightOfScreen = collectionView.bounds.height
        return CGSize(width: widthOfScreen, height: heightOfScreen)
       
    }
    
    
}

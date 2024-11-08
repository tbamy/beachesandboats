//
//  TableViewCell.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 17/10/2024.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!

    var isBoat: Bool = false
    var isBeachHouse: Bool = false
    var cellData: [HomeViewData] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup(cellData: cellData)
    }
    
    func setup(cellData: [HomeViewData]){
        collectionView.backgroundColor = UIColor.background.lighter(by: 17)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension TableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
        
        cell.isUserInteractionEnabled = true
        let view = GeneralViewCell(frame: cell.bounds)
        view.identifier = "Beach and Boat Cell " + indexPath.description
        
//        if indexPath.row == 0{
//            view.is
//        }
        let theCellData = cellData[indexPath.item]
        view.isBoatMode = isBoat
        view.isBeachHouseMode = isBeachHouse
//        view.bannerImg =
        view.titleLabel.text = theCellData.title
        view.infoOneLabel.text = theCellData.infoOne
        view.infoTwoLabel.text = theCellData.infoTwo
        view.priceLabel.text = theCellData.price
        view.ratingLabel.text = theCellData.rating
        
        
        cell.applyView(view: view)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("Go to next screen")
//        let cat = houseTypes?[indexPath.item].categoryID ?? ""
//        if let beachDataR = beachDataR{
//            coordinator?.gotoHouseTypeListView(beachData: beachDataR, cat: cat)
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthOfScreen: CGFloat = collectionView.bounds.width - 80
        let heightOfScreen = collectionView.bounds.height
        return CGSize(width: widthOfScreen, height: heightOfScreen)
       
    }
    
    
}


struct HomeViewData{
    let title: String
    let price: String
    let rating: String
    let infoOne: String
    let infoTwo: String
    let bannerImg: String
}

//
//  TableViewCell.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 17/10/2024.
//

//import UIKit
//import Kingfisher
//
//class TableViewCell: UITableViewCell {
//    
//    @IBOutlet weak var collectionView: UICollectionView!
//
//    var isBoat: Bool = false
//    var isBeachHouse: Bool = false
//    
//    var cellData: [Listing] = [] {
//            didSet {
//                collectionView.reloadData()
//            }
//        }
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//        setup()
//    }
//    
//    func setup(){
//        collectionView.backgroundColor = UIColor.background.lighter(by: 17)
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//    
////    func updateTableCell(with data: Listing){
////        let view = GeneralViewCell()
////        self.cellData = data
////        view.isBoatMode = isBoat
////        view.isBeachHouseMode = isBeachHouse
////        view.titleLabel.text = data.name
////        
////        if isBoat{
////            var capacity = (data.noOfAdults ?? 0) + (data.noOfChildren ?? 0)
////            view.infoOneLabel.text = "Capacity of People: 1 - \(capacity)"
////            view.infoTwoLabel.text = "\(data.locations?.city ?? ""), \(data.locations?.state ?? "")"
////            view.priceLabel.text = ""
////            view.ratingLabel.text = "\(data.rating ?? 0)"
////            if let url = URL(string: data.images?.first?.url ?? "") {
////                view.bannerImg.kf.setImage(with: url)
////            }
////        }else{
////            view.infoOneLabel.text = "\(data.locations?.city ?? ""), \(data.locations?.state ?? "") \(data.locations?.country ?? "")"
////            view.infoTwoLabel.text = "\(data.availabilities?.availableFrom ?? "") - \(data.availabilities?.availableTo ?? "")"
////            view.priceLabel.text = "\(data.pricePerNight ?? "") /night"
////            view.ratingLabel.text = "\(data.rating ?? 0)"
////            if let url = URL(string: data.rooms?.first?.images?.first?.url ?? "") {
////                view.bannerImg.kf.setImage(with: url)
////            }
////        }
////    }
//    
//}
//
//extension TableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return cellData.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
//        
//        cell.isUserInteractionEnabled = true
//        let view = GeneralViewCell(frame: cell.bounds)
//        view.identifier = "Beach and Boat Cell " + indexPath.description
//        
////        if indexPath.row == 0{
////            view.is
////        }
//        let theCellData = cellData[indexPath.item]
//        view.isBoatMode = isBoat
//        view.isBeachHouseMode = isBeachHouse
//        view.titleLabel.text = theCellData.name
//        
//        if isBoat{
//            var capacity = (theCellData.noOfAdults ?? 0) + (theCellData.noOfChildren ?? 0)
//            view.infoOneLabel.text = "Capacity of People: 1 - \(capacity)"
//            view.infoTwoLabel.text = "\(theCellData.locations?.city ?? ""), \(theCellData.locations?.state ?? "")"
//            view.priceLabel.text = ""
//            view.ratingLabel.text = "\(theCellData.rating ?? 0)"
//            if let url = URL(string: theCellData.images?.first?.url ?? "") {
//                view.bannerImg.kf.setImage(with: url)
//            }
//        }else{
//            view.infoOneLabel.text = "\(theCellData.locations?.city ?? ""), \(theCellData.locations?.state ?? "") \(theCellData.locations?.country ?? "")"
//            view.infoTwoLabel.text = "\(theCellData.availabilities?.availableFrom ?? "") - \(theCellData.availabilities?.availableTo ?? "")"
//            view.priceLabel.text = "\(theCellData.pricePerNight ?? "") /night"
//            view.ratingLabel.text = "\(theCellData.rating ?? 0)"
//            if let url = URL(string: theCellData.rooms?.first?.images?.first?.url ?? "") {
//                view.bannerImg.kf.setImage(with: url)
//            }
//        }
//        
//        
//        
//        cell.applyView(view: view)
//        
//        
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////        print("Go to next screen")
////        let cat = houseTypes?[indexPath.item].categoryID ?? ""
////        if let beachDataR = beachDataR{
////            coordinator?.gotoHouseTypeListView(beachData: beachDataR, cat: cat)
////        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        let widthOfScreen: CGFloat = collectionView.bounds.width - 80
//        let heightOfScreen = collectionView.bounds.height
//        return CGSize(width: widthOfScreen, height: heightOfScreen)
//       
//    }
//    
//    
//}
//
//
////struct HomeViewData{
////    let title: String
////    let price: String
////    let rating: String
////    let infoOne: String
////    let infoTwo: String
////    let bannerImg: String
////}

//
//  HomePageViewController.swift
//  BeachesAndBoats
//
//  Created by WEMA on 26/05/2024.
//

import UIKit

class HomePageViewController: UIViewController {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var filterViewContainer: UIView!
    @IBOutlet weak var beachViewContainer: UIView!
    @IBOutlet weak var boatsViewContainer: UIView!
    @IBOutlet weak var servicesViewContainer: UIView!
    @IBOutlet weak var beachHouseImg: UIImageView!
    @IBOutlet weak var boatImg: UIImageView!
    @IBOutlet weak var serviceImg: UIImageView!
    @IBOutlet weak var subCategoryCollectionView: UICollectionView!
    @IBOutlet weak var topRatedCollectionView: UICollectionView!
    @IBOutlet weak var otherTableView: UITableView!
    @IBOutlet weak var boatLabel: UILabel!
    @IBOutlet weak var beachHouseLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    
    var coordinator: AppCoordinator?
    var subCategoryCoordinator: [SubCategoryPropeties] = SubCateogryModel().populateData()
    var topRatedCoordinator: [TopRatedProperties] = TopRatedModel().populateData()
    var boatTopRatedCoordinator: [TopRatedProperties] = BoatsTopRatedModel().populateData()
    var otherCoordinator: [TopRatedProperties] = OthersModel().populateData()
    var boatOtherCoordinator: [TopRatedProperties] = BoatsOthersModel().populateData()

    var selectedView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewContainerSetup()
        collectionViewSetup()
        gestureRecongnizers()
        
//        addFadeOverlay(to: boatsViewContainer)
        beachHouseImg.layer.borderWidth = 4
        beachHouseImg.layer.borderColor = UIColor.orange.cgColor
        selectedView = beachViewContainer
//        boatImg.image = UIImage(named: "unselectedBoat")
//        boatLabel.isHidden = true
//        serviceImg.image = UIImage(named: "unselectedServices")
//        serviceLabel.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTableViewHeight()
        updateOverlayFrames()
    }
    
    func viewContainerSetup() {
        
        filterViewContainer.layer.borderWidth = 1
        filterViewContainer.layer.borderColor = UIColor.lightGray.cgColor
        filterViewContainer.layer.cornerRadius = 10
        
        beachHouseImg.layer.cornerRadius = 10
        boatImg.layer.cornerRadius = 10
        serviceImg.layer.cornerRadius = 10
        
        searchView.layer.cornerRadius = 10
        searchView.layer.shadowColor = UIColor.black.cgColor
        searchView.layer.shadowOpacity = 0.1
        searchView.layer.shadowOffset = CGSize(width: 2, height: 2)
        searchView.layer.shadowRadius = 10
    }
    
    func gestureRecongnizers() {
        let search = UITapGestureRecognizer(target: self, action: #selector(searchTapped))
        searchView.isUserInteractionEnabled = true
        searchView.addGestureRecognizer(search)
        
        let beachView = UITapGestureRecognizer(target: self, action: #selector(beachViewTapped))
        beachViewContainer.isUserInteractionEnabled = true
        beachViewContainer.addGestureRecognizer(beachView)
        
        let boatView = UITapGestureRecognizer(target: self, action: #selector(boatViewTapped))
        boatsViewContainer.isUserInteractionEnabled = true
        boatsViewContainer.addGestureRecognizer(boatView)
        
        let serviceView = UITapGestureRecognizer(target: self, action: #selector(serviceViewTapped))
        servicesViewContainer.isUserInteractionEnabled = true
        servicesViewContainer.addGestureRecognizer(serviceView)
    }
    
    @objc func beachViewTapped() {
        print("beach view")
        selectedView = beachViewContainer
        beachHouseImg.layer.borderWidth = 4
        beachHouseImg.layer.borderColor = UIColor.orange.cgColor
        
        boatImg.layer.borderWidth = .nan
        boatImg.layer.borderColor = .none
        serviceImg.layer.borderWidth = .nan
        serviceImg.layer.borderColor = .none
        
//        boatImg.image = UIImage(named: "unselectedBoat")
//        boatLabel.isHidden = true
//        serviceImg.image = UIImage(named: "unselectedServices")
//        serviceLabel.isHidden = true
        otherTableView.reloadData()
        topRatedCollectionView.reloadData()
    }
    
    @objc func boatViewTapped() {
        print("boat view")

        selectedView = boatsViewContainer
        boatImg.layer.borderWidth = 4
        boatImg.layer.borderColor = UIColor.orange.cgColor
        
        beachHouseImg.layer.borderWidth = .nan
        beachHouseImg.layer.borderColor = .none
        serviceImg.layer.borderWidth = .nan
        serviceImg.layer.borderColor = .none
        
        otherTableView.reloadData()
        topRatedCollectionView.reloadData()
    }
    
    @objc func serviceViewTapped() {
        serviceImg.layer.borderWidth = 4
        serviceImg.layer.borderColor = UIColor.orange.cgColor
        
        beachHouseImg.layer.borderWidth = .nan
        beachHouseImg.layer.borderColor = .none
        boatImg.layer.borderWidth = .nan
        boatImg.layer.borderColor = .none
        
//        otherTableView.reloadData()
//        topRatedCollectionView.reloadData()
    }
    
    @objc func searchTapped() {
        let searchView = DestinationSearchViewController()
        searchView.modalPresentationStyle = .fullScreen
        present(searchView, animated: false)
    }
    
    func collectionViewSetup() {
        subCategoryCollectionView.delegate = self
        subCategoryCollectionView.dataSource = self
        subCategoryCollectionView.tag = 1
        subCategoryCollectionView.register(UINib(nibName: "subCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "subCategoryCollectionViewCell")
        
        topRatedCollectionView.delegate = self
        topRatedCollectionView.dataSource = self
        topRatedCollectionView.tag = 2
        topRatedCollectionView.register(UINib(nibName: "TopRatedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TopRatedCollectionViewCell")
        
        otherTableView.delegate = self
        otherTableView.dataSource = self
        otherTableView.register(UINib(nibName: "OthersTableViewCell", bundle: nil), forCellReuseIdentifier: "OthersTableViewCell" )
        otherTableView.separatorStyle = .none
    }
    
    func updateTableViewHeight() {
            otherTableView.layoutIfNeeded()
            let height = otherTableView.contentSize.height
            NSLayoutConstraint.deactivate(otherTableView.constraints.filter { $0.firstAttribute == .height })
            NSLayoutConstraint.activate([
                otherTableView.heightAnchor.constraint(equalToConstant: height)
            ])
        }
    
    func addFadeOverlay(to view: UIView) {
            let overlayView = UIView(frame: view.bounds)
            overlayView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
            overlayView.tag = 999 // Tag to identify the overlay view later
            
            // Optional: Add a gradient layer for more complex fading effects
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = overlayView.bounds
            gradientLayer.colors = [
                UIColor.clear.cgColor,
                UIColor.lightGray.withAlphaComponent(0.1).cgColor
            ]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            
            overlayView.layer.addSublayer(gradientLayer)
            view.addSubview(overlayView)
        }
    func updateOverlayFrames() {
        for subview in boatsViewContainer.subviews {
            if subview.tag == 999, let overlayView = subview as? UIView {
                overlayView.frame = boatsViewContainer.bounds
                if let gradientLayer = overlayView.layer.sublayers?.first as? CAGradientLayer {
                    gradientLayer.frame = overlayView.bounds
                }
            }
        }
        
        for subview in servicesViewContainer.subviews {
            if subview.tag == 999, let overlayView = subview as? UIView {
                overlayView.frame = servicesViewContainer.bounds
                if let gradientLayer = overlayView.layer.sublayers?.first as? CAGradientLayer {
                    gradientLayer.frame = overlayView.bounds
                }
            }
        }
    }
}


extension HomePageViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedView == beachViewContainer {
            return otherCoordinator.count
        } else if selectedView == boatsViewContainer {
            return boatOtherCoordinator.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedView == beachViewContainer {
            let cell = otherTableView.dequeueReusableCell(withIdentifier: "OthersTableViewCell", for: indexPath) as! OthersTableViewCell
            let cellAt = otherCoordinator[indexPath.item]
            cell.setup(with: cellAt)
            cell.selectionStyle = .none
            return cell
        } else if selectedView == boatsViewContainer {
            let cell = otherTableView.dequeueReusableCell(withIdentifier: "OthersTableViewCell", for: indexPath) as! OthersTableViewCell
            let cellAt = boatOtherCoordinator[indexPath.item]
            cell.setup(with: cellAt)
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    
}

extension HomePageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedView == beachViewContainer {
            if collectionView.tag == 1 {
                return subCategoryCoordinator.count
            } else if collectionView.tag == 2 {
                return topRatedCoordinator.count
            } else if collectionView.tag == 3 {
                return otherCoordinator.count
            }
        } else if selectedView == boatsViewContainer {
            if collectionView.tag == 1 {
                return subCategoryCoordinator.count
            } else if collectionView.tag == 2 {
                return boatTopRatedCoordinator.count
            } else if collectionView.tag == 3 {
                return boatOtherCoordinator.count
            }
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if selectedView == beachViewContainer {
            if collectionView.tag == 1 {
                let cell = subCategoryCollectionView.dequeueReusableCell(withReuseIdentifier: "subCategoryCollectionViewCell", for: indexPath) as! subCategoryCollectionViewCell
                let cellAt = subCategoryCoordinator[indexPath.item]
                cell.setup(with: cellAt)
                return cell
            } else if collectionView.tag == 2 {
                let cell = topRatedCollectionView.dequeueReusableCell(withReuseIdentifier: "TopRatedCollectionViewCell", for: indexPath) as! TopRatedCollectionViewCell
                let cellAt = topRatedCoordinator[indexPath.item]
                cell.setup(with: cellAt)
                return cell
            }
        } else if selectedView == boatsViewContainer {
            if collectionView.tag == 1 {
                let cell = subCategoryCollectionView.dequeueReusableCell(withReuseIdentifier: "subCategoryCollectionViewCell", for: indexPath) as! subCategoryCollectionViewCell
                let cellAt = subCategoryCoordinator[indexPath.item]
                cell.setup(with: cellAt)
                return cell
            } else if collectionView.tag == 2 {
                let cell = topRatedCollectionView.dequeueReusableCell(withReuseIdentifier: "TopRatedCollectionViewCell", for: indexPath) as! TopRatedCollectionViewCell
                let cellAt = boatTopRatedCoordinator[indexPath.item]
                cell.setup(with: cellAt)
                return cell
            }
        }
       
        return UICollectionViewCell()
    }
}

extension HomePageViewController: UICollectionViewDelegateFlowLayout {
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
            let widthOfScreen = collectionView.bounds.width
            let heightOfScreen = collectionView.bounds.height
            return CGSize(width: widthOfScreen, height: heightOfScreen)
        }
        return CGSize()
       
    }
}

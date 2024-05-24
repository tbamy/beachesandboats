//
//  BookingDetailsViewController.swift
//  BeachesAndBoats
//
//  Created by Paul Orimogunje on 20/05/2024.
//

import UIKit

class BookingDetailsViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var utilitiesCollectionView: UICollectionView!
    @IBOutlet weak var villaName: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var ratinglabel: UILabel!
    @IBOutlet weak var checkInDate: UILabel!
    @IBOutlet weak var checkOutDate: UILabel!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var reviewCollectionView: UICollectionView!
    @IBOutlet weak var writeReviewBtn: UIButton!
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var hostNameImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var perLabel: UILabel!
    @IBOutlet weak var bookAgainBtn: UIButton!
    @IBOutlet weak var backButton: UIImageView!

    
    var getData: BookingProperties?
    var utilitiesCoordinator: [UtilitiesProperties] = UtilitiesModel().populateData()
    var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        viewSetup()
//        navigationController?.navigationBar.isHidden = true
        navigationController?.isNavigationBarHidden = true

    }
    
    
    
    
        
   
    func viewSetup() {
        image.image = UIImage(named: getData?.image ?? "empty")
        villaName.text = getData?.name
        locationLabel.text = getData?.address
        
        let back = UITapGestureRecognizer(target: self, action: #selector(backClicked))
        backButton.isUserInteractionEnabled = true
        backButton.addGestureRecognizer(back)
    }
    
    @objc func backClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    
    func setupCollectionView() {
        utilitiesCollectionView.delegate = self
        utilitiesCollectionView.dataSource = self
        utilitiesCollectionView.register(UINib(nibName: "UtilitiesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UtilitiesCollectionViewCell")
        utilitiesCollectionView.tag = 1
        
    }
    
    
    
    
    @IBAction func writeReviewTapped(_ sender: Any) {
        let reviewView = ReviewViewController()
        reviewView.modalPresentationStyle = .overCurrentContext
        reviewView.modalTransitionStyle = .coverVertical
        present(reviewView, animated: true)
    }
    

    
    @IBAction func bookAgainTapped(_ sender: Any) {
    }
    
}

extension BookingDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return utilitiesCoordinator.count
        } else if collectionView.tag == 2 {
            print("second one")
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            let cell = utilitiesCollectionView.dequeueReusableCell(withReuseIdentifier: "UtilitiesCollectionViewCell", for: indexPath) as! UtilitiesCollectionViewCell
            let cellAt = utilitiesCoordinator[indexPath.item]
            cell.setup(with: cellAt)
            return cell
        }
        return UICollectionViewCell()
    }
}

extension BookingDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthOfTheScreen: CGFloat = 70
//        let widthOfTheScreen = collectionView.bounds.width
        let heightOfTheScreen = collectionView.bounds.height
        return CGSize(width: widthOfTheScreen, height: heightOfTheScreen)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        .init(top: 5, left: 10, bottom: 5, right: 10)
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0
        )
    }
}

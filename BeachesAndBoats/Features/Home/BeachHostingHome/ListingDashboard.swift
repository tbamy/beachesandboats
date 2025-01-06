//
//  ListingDashboard.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/10/2024.
//

import UIKit

class ListingDashboard: UIViewController {
    
    @IBOutlet weak var checkOutNoDataImg: UIImageView!
    @IBOutlet weak var checkOutCollectionView: UICollectionView!
    @IBOutlet weak var currentHostingNoDataImg: UIImageView!
    @IBOutlet weak var currentHostingCollectionView: UICollectionView!
    @IBOutlet weak var upcomingNoDataImg: UIImageView!
    @IBOutlet weak var upcomingCollectionView: UICollectionView!
    @IBOutlet weak var cancelBookingNoDataImg: UIImageView!
    @IBOutlet weak var cancelBookingCollectionView: UICollectionView!
    @IBOutlet var images: [UIImageView]!
    
    
    let noLabel = UILabel()
    let noImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkOutNoData()
        currentHostingNoData()
        upcomingNoData()
        cancelBookingNoData()
        imageDesign()
        
        checkOutCollectionView.isHidden = true
        currentHostingCollectionView.isHidden = true
        upcomingCollectionView.isHidden = true
        cancelBookingCollectionView.isHidden = true
    }
    
    func imageDesign() {
        for image in images {
            image.layer.cornerRadius = 20
        }
    }
    
    func checkOutNoData() {
        let noLabel = UILabel()
        let noImage = UIImageView()
        
        noLabel.text = "You dont have any checking out soon"
        noImage.image = UIImage(named: "noDataIcon")

        checkOutNoDataImg.addSubview(noLabel)
        checkOutNoDataImg.addSubview(noImage)
        noLabel.translatesAutoresizingMaskIntoConstraints = false
        noImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noImage.centerXAnchor.constraint(equalTo: checkOutNoDataImg.centerXAnchor),
            noImage.centerYAnchor.constraint(equalTo: checkOutNoDataImg.centerYAnchor, constant: -15),
            noLabel.topAnchor.constraint(equalTo: noImage.bottomAnchor, constant: 10),
            noLabel.leadingAnchor.constraint(equalTo: checkOutNoDataImg.leadingAnchor, constant: 30),
            noLabel.trailingAnchor.constraint(equalTo: checkOutNoDataImg.trailingAnchor, constant: -30)
        ])
    }
    
    func currentHostingNoData() {
        let noLabel = UILabel()
        let noImage = UIImageView()
        
        noLabel.text = "You dont have any checking out soon"
        noImage.image = UIImage(named: "noDataIcon")

        currentHostingNoDataImg.addSubview(noLabel)
        currentHostingNoDataImg.addSubview(noImage)
        noLabel.translatesAutoresizingMaskIntoConstraints = false
        noImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noImage.centerXAnchor.constraint(equalTo: currentHostingNoDataImg.centerXAnchor),
            noImage.centerYAnchor.constraint(equalTo: currentHostingNoDataImg.centerYAnchor, constant: -15),
            noLabel.topAnchor.constraint(equalTo: noImage.bottomAnchor, constant: 10),
            noLabel.leadingAnchor.constraint(equalTo: currentHostingNoDataImg.leadingAnchor, constant: 30),
            noLabel.trailingAnchor.constraint(equalTo: currentHostingNoDataImg.trailingAnchor, constant: -30)
        ])
    }

    func upcomingNoData() {
        let noLabel = UILabel()
        let noImage = UIImageView()
        
        noLabel.text = "You dont have any checking out soon"
        noImage.image = UIImage(named: "noDataIcon")

        upcomingNoDataImg.addSubview(noLabel)
        upcomingNoDataImg.addSubview(noImage)
        noLabel.translatesAutoresizingMaskIntoConstraints = false
        noImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noImage.centerXAnchor.constraint(equalTo: upcomingNoDataImg.centerXAnchor),
            noImage.centerYAnchor.constraint(equalTo: upcomingNoDataImg.centerYAnchor, constant: -15),
            noLabel.topAnchor.constraint(equalTo: noImage.bottomAnchor, constant: 10),
            noLabel.leadingAnchor.constraint(equalTo: upcomingNoDataImg.leadingAnchor, constant: 30),
            noLabel.trailingAnchor.constraint(equalTo: upcomingNoDataImg.trailingAnchor, constant: -30)
        ])
    }
    
    func cancelBookingNoData() {
        let noLabel = UILabel()
        let noImage = UIImageView()
        
        noLabel.text = "You dont have any checking out soon"
        noImage.image = UIImage(named: "noDataIcon")

        cancelBookingNoDataImg.addSubview(noLabel)
        cancelBookingNoDataImg.addSubview(noImage)
        noLabel.translatesAutoresizingMaskIntoConstraints = false
        noImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noImage.centerXAnchor.constraint(equalTo: cancelBookingNoDataImg.centerXAnchor),
            noImage.centerYAnchor.constraint(equalTo: cancelBookingNoDataImg.centerYAnchor, constant: -15),
            noLabel.topAnchor.constraint(equalTo: noImage.bottomAnchor, constant: 10),
            noLabel.leadingAnchor.constraint(equalTo: cancelBookingNoDataImg.leadingAnchor, constant: 30),
            noLabel.trailingAnchor.constraint(equalTo: cancelBookingNoDataImg.trailingAnchor, constant: -30)
        ])
    }

   

}

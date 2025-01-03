//
//  ServiceHostingDetailsView.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 31/12/2024.
//

import UIKit
import MapKit

class ServiceHostingDetailsView: UIViewController {
    
    @IBOutlet weak var beachImage: UIImageView!
    @IBOutlet weak var beachHouseNameLbl: UILabel!
    @IBOutlet weak var locationLbl: LightLabel!
    @IBOutlet weak var decriptionContainer: UIView!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    @IBOutlet weak var readMoreBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var guestName: UILabel!
    @IBOutlet weak var guesImg: UIImageView!
    @IBOutlet weak var sendMsgBtn: UIButton!
    @IBOutlet weak var descriptionLbl: RegularLabel!
    @IBOutlet weak var shareicon: UIImageView!
    @IBOutlet weak var backIcon: UIImageView!
    var coordinator: ServiceCoordinator?
    
    private var isExpanded = false
    
    var bookingServiceDetails: BeachHouseBookingDetails?
    let guestFirstName = UserSession.shared.userDetails
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        if coordinator == nil {
            coordinator = ServiceCoordinator(navigationController: self.navigationController, completion: nil)
        }
        gestureRecognizer()
        setupUI()
    }
    
    func setupUI() {
        beachImage.image = UIImage(named: bookingServiceDetails?.beachHouse?.image ?? "")
        beachHouseNameLbl.text = bookingServiceDetails?.beachHouse?.name
        descriptionLbl.text = bookingServiceDetails?.beachHouse?.description
        guestName.text = guestFirstName?.first_name
        
        if let latitude = Double(bookingServiceDetails?.beachHouse?.locations?.latitude ?? ""),
           let longitude = Double(bookingServiceDetails?.beachHouse?.locations?.longitude ?? "") {
           
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let span = MKCoordinateSpan(latitudeDelta: latitude, longitudeDelta: longitude)
            let region = MKCoordinateRegion(center: center, span: span)
            
            mapView.region = region
        }

        locationLbl.text = "\(bookingServiceDetails?.beachHouse?.locations?.city ?? ""), \(bookingServiceDetails?.beachHouse?.locations?.state ?? ""), \(bookingServiceDetails?.beachHouse?.locations?.country ?? "")"
        
        mapView.layer.cornerRadius = 10
    }
    
    func gestureRecognizer() {
        let goBack = UITapGestureRecognizer(target: self, action: #selector(backIconTapped))
        backIcon.isUserInteractionEnabled = true
        backIcon.addGestureRecognizer(goBack)
        
        let share = UITapGestureRecognizer(target: self, action: #selector(shareIconTapped))
        shareicon.isUserInteractionEnabled = true
        shareicon.addGestureRecognizer(share)
    }
    
    @objc func backIconTapped() {
        coordinator?.pop()
    }
    
    @objc func shareIconTapped() {
    }

    @IBAction func sendMsgBtnTapped(_ sender: Any) {
        coordinator?.gotoMessageView()
    }
    

}

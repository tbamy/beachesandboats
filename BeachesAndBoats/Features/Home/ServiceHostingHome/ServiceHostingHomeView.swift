//
//  ServiceHostingHomeView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 21/11/2024.
//

import UIKit
import RxSwift

class ServiceHostingHomeView: UIViewController {

    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var upcomingBookingCollectionView: UICollectionView!
    @IBOutlet weak var pastBookingCollectionView: UICollectionView!
    @IBOutlet weak var earningYearLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var noOfUpcomingBooking: UILabel!
    @IBOutlet weak var noOfPastBooking: UILabel!
    
    let vm = ServiceHostingHomeViewVM()
    let disposeBag = DisposeBag()
    let input = PublishSubject<ServiceHostingHomeViewVM.Input>()
    
    var coordinator: ServiceCoordinator?
    
    let userDetails = UserSession.shared.userDetails
    
    var upcomingBookingData: [BeachHouseBookingDetails] = []
    var pastBookingData: [BeachHouseBookingDetails] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        input.onNext(.upcomingBooking)
        LoadingModal.show(title: "Getting Hosting list...")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupCollectionView()
        setupUI()
        
        if coordinator == nil {
            coordinator = ServiceCoordinator(navigationController: self.navigationController, completion: nil)
        }
    }
    
    func setupUI() {
        welcomeLabel.text = "Welcomen \(userDetails?.first_name ?? "")"
    }

    func setupCollectionView() {
        upcomingBookingCollectionView.dataSource = self
        upcomingBookingCollectionView.delegate = self
        upcomingBookingCollectionView.tag = 1
        upcomingBookingCollectionView.register(UINib(nibName: "HostingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HostingCollectionViewCell")
//        upcomingBookingCollectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        
        pastBookingCollectionView.showsHorizontalScrollIndicator = false
        pastBookingCollectionView.delegate = self
        pastBookingCollectionView.dataSource = self
        pastBookingCollectionView.tag = 2
        pastBookingCollectionView.register(UINib(nibName: "HostingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HostingCollectionViewCell")

    }
}

//MARK: - Binding
extension ServiceHostingHomeView {
    func bind() {
        vm.transform(input: input)
        vm.output.subscribe(onNext: { [weak self] output in
            LoadingModal.dismiss()
            switch output {
            case .getUpcomingBookingSuccess(let response):
//                self?.upcomingBookingData = response.upcomingBookings?.compactMap { $0.beachHouseBooking } ?? []
                self?.pastBookingData = response.pastBookings?.compactMap { $0.beachHouseBooking } ?? []
                self?.noOfUpcomingBooking.text = "Upcoming Booking (\(self?.pastBookingData.count ?? 0))"
                self?.noOfPastBooking.text = "Past Booking (\(self?.pastBookingData.count ?? 0))"
                self?.upcomingBookingCollectionView.reloadData()
                self?.pastBookingCollectionView.reloadData()
            case .getUpcomingBookingFailure(let error):
                print(error)
            }
        }).disposed(by: disposeBag)
    }
}

//MARK: - CollectionView Delegate
extension ServiceHostingHomeView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return upcomingBookingData.isEmpty ? 2 :upcomingBookingData.count
        } else if collectionView.tag == 2 {
            return pastBookingData.isEmpty ? 2 : pastBookingData.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HostingCollectionViewCell", for: indexPath) as! HostingCollectionViewCell
            
            if upcomingBookingData.isEmpty {
                cell.setupHostingCell(with: nil)
            } else {
                let cellAt = upcomingBookingData[indexPath.item]
                cell.setupHostingCell(with: cellAt)
            }
            return cell
        } else if collectionView.tag == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HostingCollectionViewCell", for: indexPath) as! HostingCollectionViewCell
            
            if pastBookingData.isEmpty {
                cell.setupHostingCell(with: nil)
            } else {
                let cellAt = pastBookingData[indexPath.item]
                cell.setupHostingCell(with: cellAt)
            }
            cell.daysView.isHidden = true
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Hello")
//        coordinator?.gotoServiceHostingDetailsView()
        if collectionView.tag == 1 {
            if !upcomingBookingData.isEmpty {
                let upcomingBooking = upcomingBookingData[indexPath.item]
                coordinator?.gotoServiceHostingDetailsView(data: upcomingBooking)
            } else {
                collectionView.isUserInteractionEnabled = false
                Toast.show(message: "Information not available")
            }
        } else if collectionView.tag == 2 {
            if !pastBookingData.isEmpty {
                let pastBooking = pastBookingData[indexPath.item]
                coordinator?.gotoServiceHostingDetailsView(data: pastBooking)
            } else {
                collectionView.isUserInteractionEnabled = false
                Toast.show(message: "Information not available")
            }
        }
    }
}
    
extension ServiceHostingHomeView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Return the full width and height of the collection view
        return CGSize(width: collectionView.frame.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}


//
//  BookingViewController.swift
//  BeachesAndBoats
//
//  Created by Paul Orimogunje on 17/05/2024.
//

import UIKit

class BookingViewController: UIViewController {
    
    @IBOutlet weak var upcomingBookingBtn: UIButton!
    @IBOutlet weak var pastBookingBtn: UIButton!
    @IBOutlet weak var bookingCategories: UICollectionView!
    
    var coordinator: AppCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        ButtonBottomBorder.shared.addBottomBorder(to: upcomingBookingBtn)
        upcomingBookingBtn.tintColor = .black
        pastBookingBtn.tintColor = .lightGray
        NavigationUtility.shared.setupNavigation(for: self, backIcon: nil, navigationTitle: "Booking", rightIcon: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setupTable() {
        bookingCategories.delegate = self
        bookingCategories.dataSource = self
        bookingCategories.register(UINib(nibName: "UpcomingBookingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UpcomingBookingCollectionViewCell")
        bookingCategories.register(UINib(nibName: "PastBookingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PastBookingCollectionViewCell")
        bookingCategories.isScrollEnabled = false
    }
    
    @IBAction func upcomingButtonTapped(_ sender: Any) {
        ButtonBottomBorder.shared.addBottomBorder(to: upcomingBookingBtn)
        ButtonBottomBorder.shared.removeBottomBorder(from: pastBookingBtn)
        upcomingBookingBtn.tintColor = .black
        pastBookingBtn.tintColor = .lightGray
        let indexPath = IndexPath(item: 0, section: 0)
        bookingCategories.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        NavigationUtility.shared.setupNavigation(for: self, backIcon: nil, navigationTitle: "Booking", rightIcon: nil)
    }
    
    
    @IBAction func pastButtonTapped(_ sender: Any) {
        ButtonBottomBorder.shared.addBottomBorder(to: pastBookingBtn)
        ButtonBottomBorder.shared.removeBottomBorder(from: upcomingBookingBtn)
        upcomingBookingBtn.tintColor = .lightGray
        pastBookingBtn.tintColor = .black
        let indexPath = IndexPath(item: 1, section: 0)
        bookingCategories.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        NavigationUtility.shared.setupNavigation(for: self, backIcon: nil, navigationTitle: "Booking") { button in
            button.setImage(UIImage(named: "sort")?.withRenderingMode(.alwaysOriginal), for: .normal)
            button.addTarget(self, action: #selector(self.sortTapped), for: .touchUpInside)
        }
    }
    
    @objc func sortTapped() {
        let sortView = SortViewController()
        sortView.modalPresentationStyle = .overCurrentContext
        sortView.modalTransitionStyle = .coverVertical
        present(sortView, animated: true)
    }
}

extension BookingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = bookingCategories.dequeueReusableCell(withReuseIdentifier: "UpcomingBookingCollectionViewCell", for: indexPath) as! UpcomingBookingCollectionViewCell
            cell.cellTappedDelegate = self
            return cell
        } else if indexPath.item == 1 {
            let cell = bookingCategories.dequeueReusableCell(withReuseIdentifier: "PastBookingCollectionViewCell", for: indexPath) as! PastBookingCollectionViewCell
            cell.pastBookingDelegate = self
            return cell
        }
        return UICollectionViewCell()
    }
}

extension BookingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthOfScreen = collectionView.bounds.width
        let heightOfScreen = collectionView.bounds.height
        return CGSize(width: widthOfScreen, height: heightOfScreen)
    }
}

extension BookingViewController: PastBookingItemDelegate {
    func cellTapped(inCell: PastBookingCollectionViewCell, data: BookingProperties) {
        debugPrint("Pastbooking working")
        coordinator?.gotoPastBookingDetails(data: data)
    }
    
    
}

extension BookingViewController: ItemTappedDelegate {
    func cellTapped(inCell: UpcomingBookingCollectionViewCell, data: BookingProperties) {
        debugPrint("Working?")
        let bookDetailsView = BookingDetailsViewController()
        coordinator?.gotoBookingDetails(data: data)
        
//        let bookingDetails = BookingDetailsViewController()
//        bookingDetails.getData = data
//        print("book is \(bookingDetails.getData)")
//        if let data = bookingDetails.getData{
//            coordinator?.gotoBookingDetails(data: data)
//        }
    }
}

//
//  UpcomingBookingCollectionViewCell.swift
//  BeachesAndBoats
//
//  Created by Paul Orimogunje on 18/05/2024.
//

import UIKit

protocol ItemTappedDelegate: AnyObject {
    func cellTapped(inCell: UpcomingBookingCollectionViewCell, data: BookingProperties)
}

class UpcomingBookingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var upcomingTableView: UITableView!
    
    weak var cellTappedDelegate: ItemTappedDelegate?
    var upcomingCoordinator: [BookingProperties] = UpcomingBookingModel().populateData()
    var upcomingBookingData: BookingProperties?
    
    override func awakeFromNib() {
        super.awakeFromNib()
                
        upcomingTableView.dataSource = self
        upcomingTableView.delegate = self
        upcomingTableView.register(UINib(nibName: "BookingTableViewCell", bundle: nil), forCellReuseIdentifier: "BookingTableViewCell")
        upcomingTableView.separatorStyle = .none
    }

}

extension UpcomingBookingCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        upcomingCoordinator.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = upcomingTableView.dequeueReusableCell(withIdentifier: "BookingTableViewCell", for: indexPath) as! BookingTableViewCell
        let cellAT = upcomingCoordinator[indexPath.item]
        cell.setup(with: cellAT)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBookingData = upcomingCoordinator[indexPath.item]
        print("selecteBooking is \(selectedBookingData)")
        cellTappedDelegate?.cellTapped(inCell: self, data: selectedBookingData)
    }
    
    
}

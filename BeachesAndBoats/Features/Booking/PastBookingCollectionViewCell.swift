//
//  PastBookingCollectionViewCell.swift
//  BeachesAndBoats
//
//  Created by Paul Orimogunje on 18/05/2024.
//

import UIKit

protocol PastBookingItemDelegate: AnyObject {
    func cellTapped(inCell: PastBookingCollectionViewCell, data: BookingProperties)
}



class PastBookingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var pastBookingTableView: UITableView!
    
    var pastBookingCoordinator: [BookingProperties] = PastBookingModel().populateData()
    weak var pastBookingDelegate: PastBookingItemDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pastBookingTableView.dataSource = self
        pastBookingTableView.delegate = self
        pastBookingTableView.register(UINib(nibName: "BookingTableViewCell", bundle: nil), forCellReuseIdentifier: "BookingTableViewCell")
        pastBookingTableView.separatorStyle = .none
    }

}

extension PastBookingCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastBookingCoordinator.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = pastBookingTableView.dequeueReusableCell(withIdentifier: "BookingTableViewCell", for: indexPath) as! BookingTableViewCell
        let cellAT = pastBookingCoordinator[indexPath.item]
        cell.setup(with: cellAT)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBooking = pastBookingCoordinator[indexPath.item]
        pastBookingDelegate?.cellTapped(inCell: self, data: selectedBooking)
    }
    
    
}

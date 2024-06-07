//
//  NotificationViewController.swift
//  BeachesAndBoats
//
//  Created by Paul Orimogunje on 16/05/2024.
//

import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet weak var notificationSettings: UILabel!
    @IBOutlet weak var notificationTable: UITableView!
    
    var notificationCoordinator: [NotificationProperties] = NotificationModel().populateData()
    var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationUtility.shared.setupNavigation(for: self, backIcon: UIImage(named: "backButton"), navigationTitle: "Notifications", navigationSubtitle: nil, rightIcon: nil, secondRightIcon: nil)
        
//        NavigationUtility.shared.setupNavigation(for: self, backIcon: UIImage(named: "backButton"), navigationTitle: "Notifications", rightIcon: nil)
        tableViewSetup()
    }
    
    func tableViewSetup() {
        notificationTable.delegate = self
        notificationTable.dataSource = self
        notificationTable.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationTableViewCell")
    }
}

extension NotificationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationCoordinator.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        let cellAt = notificationCoordinator[indexPath.item]
        cell.setup(with: cellAt)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    
}

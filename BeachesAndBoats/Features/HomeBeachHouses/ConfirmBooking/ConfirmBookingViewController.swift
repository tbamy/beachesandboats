//
//  ConfirmBookingViewController.swift
//  BeachesAndBoats
//
//  Created by WEMA on 07/06/2024.
//

import UIKit

class ConfirmBookingViewController: UIViewController {
    
    @IBOutlet weak var luxuryTable: UITableView?
    
    var coordinator: AppCoordinator?
    var confirmBookingCoordinator: [ConfirmBookingProperties] = ConfirmBookingModel().populateData()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
        navigationController?.isNavigationBarHidden = false
        NavigationUtility.shared.setupNavigation(
            for: self,
            backIcon: UIImage(named: "backButton"),
            navigationTitle: "Select Stay",
            navigationSubtitle: "Marina Luxury Villa",
            rightIcon: { button in
                button.setImage(UIImage(named: "sort")?.withRenderingMode(.alwaysOriginal), for: .normal)
                button.addTarget(self, action: #selector(self.sort), for: .touchUpInside)
            },
            secondRightIcon: { button in
                button.setImage(UIImage(named: "sort")?.withRenderingMode(.alwaysOriginal), for: .normal)
                button.addTarget(self, action: #selector(self.sort), for: .touchUpInside)
            })
    }
    
    func tableViewSetup() {
        luxuryTable?.delegate = self
        luxuryTable?.dataSource = self
        luxuryTable?.register(UINib(nibName: "ConfirmBookingTableViewCell", bundle: nil), forCellReuseIdentifier: "ConfirmBookingTableViewCell")
    }
    
    @objc func sort(){
        let sortView = SortViewController()
        sortView.modalTransitionStyle = .coverVertical
        sortView.modalPresentationStyle = .overCurrentContext
        present(sortView, animated: false)
    }
}

extension ConfirmBookingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        confirmBookingCoordinator.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = luxuryTable?.dequeueReusableCell(withIdentifier: "ConfirmBookingTableViewCell", for: indexPath) as! ConfirmBookingTableViewCell
        let cellAT = confirmBookingCoordinator[indexPath.item]
        cell.setup(with: cellAT)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    
}

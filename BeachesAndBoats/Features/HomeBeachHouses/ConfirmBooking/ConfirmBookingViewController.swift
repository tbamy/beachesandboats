//
//  ConfirmBookingViewController.swift
//  BeachesAndBoats
//
//  Created by WEMA on 07/06/2024.
//

import UIKit

class ConfirmBookingViewController: UIViewController {
    
    @IBOutlet weak var luxuryTable: UITableView?
    @IBOutlet weak var reserveView: UIView!
    
    
    var coordinator: AppCoordinator?
    var confirmBookingCoordinator: [ConfirmBookingProperties] = ConfirmBookingModel().populateData()
    var getLuxuryName: String?
    var countOnSelect: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reserveView.isHidden = true
        tableViewSetup()
        navigationController?.isNavigationBarHidden = false
        NavigationUtility.shared.setupNavigation(
            for: self,
            backIcon: UIImage(named: "backButton"),
            navigationTitle: "Select Stay",
            navigationSubtitle: getLuxuryName,
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
    
    
    @IBAction func reserveButtonTapped(_ sender: Any) {
        coordinator?.gotoBookingConfirmation()
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
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}

extension ConfirmBookingViewController: SelectButtonDelegate {
    func onSelect() {
        countOnSelect += 1
        if countOnSelect == 1 {
            reserveView.isHidden = false
        } else {
            let selectQuanView = SelectQuantityViewController()
            selectQuanView.modalTransitionStyle = .coverVertical
            selectQuanView.modalPresentationStyle = .overCurrentContext
            present(selectQuanView, animated: true)
        }
    }
    
    
}

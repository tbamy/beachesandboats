//
//  ProfileViewController.swift
//  Beaches and Boats
//
//  Created by Paul Orimogunje on 11/05/2024.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var hAndSTableView: UITableView!
    @IBOutlet weak var hostTableView: UITableView!
    
    var coordinator: AppCoordinator?
    var settingCoordinator: [ProfileModel] = SettingModelArray().populateData()
    var helpCoordinator: [ProfileModel] = HelpModelArray().populateData()
    var hostCoordinator: [ProfileModel] = HelpModelArray().populateData()

    override func viewDidLoad() {
        super.viewDidLoad()
        let customFont = UIFont(name: "MontserratRoman-SemiBold", size: 16)
        if let customFont = customFont {
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: customFont]
        }
        navigationItem.title = "Account"

        tableViewSetup()
    }
    
    
    func tableViewSetup() {
        settingTableView.dataSource = self
        settingTableView.delegate = self
        settingTableView.tag = 1
        settingTableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        hAndSTableView.delegate = self
        hAndSTableView.dataSource = self
        hAndSTableView.tag = 2
        hAndSTableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

        
        hostTableView.delegate = self
        hostTableView.dataSource = self
        hostTableView.tag = 3
        hostTableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

        
        settingTableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingTableViewCell")
        hAndSTableView.register(UINib(nibName: "HelpAndSupportTableViewCell", bundle: nil), forCellReuseIdentifier: "HelpAndSupportTableViewCell")
        hostTableView.register(UINib(nibName: "HostTableViewCell", bundle: nil), forCellReuseIdentifier: "HostTableViewCell")
    }
    
    
    
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return settingCoordinator.count
        } else if tableView.tag == 2 {
            return helpCoordinator.count
        } else if tableView.tag == 3 {
            return hostCoordinator.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1 {
            let cell = settingTableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
            let cellAt = settingCoordinator[indexPath.item]
            cell.setupData(with: cellAt)
            cell.selectionStyle = .none
            return cell
        } else if tableView.tag == 2 {
            let cell = hAndSTableView.dequeueReusableCell(withIdentifier: "HelpAndSupportTableViewCell", for: indexPath) as! HelpAndSupportTableViewCell
            let cellAt = helpCoordinator[indexPath.item]
            cell.setupData(with: cellAt)
            cell.selectionStyle = .none
            return cell
        } else if tableView.tag == 3 {
            let cell = hostTableView.dequeueReusableCell(withIdentifier: "HostTableViewCell", for: indexPath) as! HostTableViewCell
            let cellAt = settingCoordinator[indexPath.item]
            cell.setupData(with: cellAt)
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1 {
            if indexPath.item == 0 {
                coordinator?.gotoManageAccount()
            } else if indexPath.item == 1 {
                print("go to save view")
            } else if indexPath.item == 2 {
                coordinator?.gotoPayments()
            } else if indexPath.item == 3 {
                coordinator?.gotoNotification()
            } else if indexPath.item == 4 {
                coordinator?.gotoLoginSecurityView()
            }
        } else if tableView.tag == 2 {
            if indexPath.item == 0 {
                coordinator?.gotoContactSupport()
            } else if indexPath.item == 1 {
                coordinator?.gotoSafetyAndGuidelines()
            }
        } else if tableView.tag == 3 {
            if indexPath.item == 0 {
                print("go to list properties")
            } else if indexPath.item == 1 {
                print("go to switch hosting")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 1 {
            return 50
        }
        return 50
    }
    
}

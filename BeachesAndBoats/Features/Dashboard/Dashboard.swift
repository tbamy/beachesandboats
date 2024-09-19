//
//  Dashboard.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 15/09/2024.
//

import UIKit

class Dashboard: UITabBarController {
    private var selectorView: UIView!
    
//    var userConstent: Bool
//    
//    init(userConstents: Bool) {
//        self.userConstent = userConstents
//        super.init(nibName: nil, bundle: nil)
//    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        viewControllers = [ExploreController(), SavedController(), BookingsController(), MessagesController(), AccountController()]
//        if userConstent == true {
//            print("yess")
//        } else {
            setup()
//        }
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let selectorStartX = CGFloat(self.tabBar.items!.firstIndex(of: item)!) * selectorView.frame.width
        UIView.animate(withDuration: 0.3) {
            self.selectorView.frame.origin.x = selectorStartX
        }
    }
    
    func setup() {
        let pathView = UIView(frame: CGRect(x: 0, y: 0, width: self.tabBar.frame.width, height: 1))
        pathView.backgroundColor = .background.lighter(by: 10)
        let selectorWidth = self.tabBar.frame.width / CGFloat(self.tabBar.items?.count ?? 1)
        selectorView = UIView(frame: CGRect(x: 0, y: 0, width: selectorWidth, height: 1))
        selectorView.backgroundColor = UIColor.white
        tabBar.barTintColor = .white
        self.tabBar.addSubview(pathView)
        self.tabBar.addSubview(selectorView)
    }
    
    func wrapInNavigationController(_ viewController: UIViewController) -> BaseNavigationController {
        return BaseNavigationController(rootViewController: viewController)
    }
    
    func ExploreController() -> UINavigationController {
        let navController = BaseNavigationController()
        let coordinator = ExploreCoordinator(navigationController: navController, completion: nil)
        coordinator.start()
        return navController
    }
    
    func SavedController() -> UINavigationController {
        let navController = BaseNavigationController()
        let coordinator = SavedCoordinator(navigationController: navController, completion: nil)
        coordinator.start()
        return navController
    }
      
    func BookingsController() -> UINavigationController {
        let navController = BaseNavigationController()
        let coordinator = BookingsCoordinator(navigationController: navController, completion: nil)
        coordinator.start()
        return navController
    }
    
    func MessagesController() -> UINavigationController {
        let navController = BaseNavigationController()
        let coordinator = MessagesCoordinator(navigationController: navController, completion: nil)
        coordinator.start()
        return navController
    }
    
    func AccountController() -> UINavigationController {
        let navController = BaseNavigationController()
        let coordinator = AccountCoordinator(navigationController: navController, completion: nil)
        coordinator.start()
        return navController
    }
}

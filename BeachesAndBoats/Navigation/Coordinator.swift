//
//  Coordinator.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 12/05/2024.
//

import UIKit

protocol CoordinatorDelegate: AnyObject {
    func didFinishWorkflow()
}

class Coordinator {
    
    // MARK: - Properties
    
    weak var delegate: CoordinatorDelegate?
//    private var modalCoordinator: ModalCoordinator?
    private let navigationController: UINavigationController?
    private let completion: (() -> Void)?
    
    // MARK: - Initialization
    
    init(navigationController: UINavigationController?, completion: (() -> Void)? = nil) {
        self.navigationController = navigationController
        self.completion = completion
    }

    // MARK: - Navigation Methods
    
    func start() {
        // Abstract method to be overridden by subclasses
    }
    
//    let modalCoordinator = ModalCoordinator()
//    
//    func showConfirmAccountModal() {
//        modalCoordinator.start()
//    }
//    
//    func showUserInfoModal(email: String, phone: String){
//        modalCoordinator.presentUserInformationModal(email: email, phone: phone)
//    }
//    
    func finishWorkflow() {
        if let parentDelegate = delegate {
            parentDelegate.didFinishWorkflow()
        } else {
            completion?()
        }
    }
    
    // MARK: - Navigation Operations
    
    func present(viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController?.present(viewController, animated: animated, completion: completion)
    }
    
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController?.dismiss(animated: animated, completion: completion)
    }
    
    func set(viewControllers: [UIViewController], animated: Bool = true) {
        navigationController?.setViewControllers(viewControllers, animated: animated)
    }
    
    func push(viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    func popToRoot(animated: Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
    }
    
    func topViewController() -> UIViewController? {
        return navigationController?.topViewController
    }
    
    func popBack<T: UIViewController>(toControllerType type: T.Type) {
        if let viewController = navigationController?.viewControllers.first(where: { $0.isKind(of: type) }) {
            navigationController?.popToViewController(viewController, animated: true)
        }
    }

    // MARK: - Deinitializer
    
    deinit {
        print("--- \(self) deinit")
    }
}

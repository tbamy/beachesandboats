//
//  WithdrawalMainView.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 02/01/2025.
//

import UIKit

class WithdrawalMainView: BaseViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var parentView: UIView!
    
    private var historyViewController: UIViewController!
    private var makeWithdrawViewController: UIViewController!
    
    var coordinator: EarningCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        title = "Withdrawals"
        setupUI()
    }
    
    func setupUI() {
        // Set title text attributes for normal (unselected) state
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black // Color for unselected segment
        ]
        segmentedControl.setTitleTextAttributes(normalAttributes, for: .normal)
        
        // Set title text attributes for selected state
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white
        ]
        segmentedControl.setTitleTextAttributes(selectedAttributes, for: .selected)
        historyViewController = WithdrawHistoryView()
        makeWithdrawViewController = MakeWithdrawView()
        add(asChildViewController: historyViewController)
    }
    
    
    @IBAction func segmentSelected(_ sender: Any) {
        if (sender as AnyObject).selectedSegmentIndex == 0 {
            remove(asChildViewController: makeWithdrawViewController)
            add(asChildViewController: historyViewController)
        } else {
            remove(asChildViewController: historyViewController)
            add(asChildViewController: makeWithdrawViewController)
        }
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add the child view controller to the container
        addChild(viewController)
        parentView.addSubview(viewController.view)
        
        // Set up the child view's frame and constraints
        viewController.view.frame = parentView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Remove the child view controller from the container
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }

}

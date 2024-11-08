//
//  BookingsView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 03/10/2024.
//

import UIKit

class BookingsView: BaseViewControllerPlain {

    var coordinator: BookingsCoordinator?
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Booking"
        setupCustomNavigationButton()
        
    }


}

extension BookingsView{
    func setupCustomNavigationButton() {
        let customButtonRight = UIButton(type: .custom)
        customButtonRight.setImage(Assets.sortIcon.image, for: .normal)
//        customButtonRight.addTarget(self, action: #selector(addNewBtnTapped), for: .touchUpInside)
        let customRightBarButtonItem = UIBarButtonItem(customView: customButtonRight)
        navigationItem.rightBarButtonItem = customRightBarButtonItem
        
        let customButtonLeft = UIButton(type: .custom)
        customButtonLeft.setImage(Assets.filterIcon2.image, for: .normal)
//        customButtonLeft.addTarget(self, action: #selector(addNewBtnTapped), for: .touchUpInside)
        let customLeftBarButtonItem = UIBarButtonItem(customView: customButtonLeft)
        navigationItem.leftBarButtonItem = customLeftBarButtonItem
    }
}

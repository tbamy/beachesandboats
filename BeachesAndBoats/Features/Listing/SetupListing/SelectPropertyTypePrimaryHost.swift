//
//  SelectPropertyTypePrimaryHost.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 27/09/2024.
//

import UIKit

class SelectPropertyTypePrimaryHost: BaseViewControllerPlain {

    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var beachHouseStack: UIStackView!
    @IBOutlet weak var boatStack: UIStackView!
    
    var tag: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        switch tag {
        case 0:
            //beachOnly
            boatStack.isHidden = true
            beachHouseStack.isHidden = false
        case 1:
            //boatOnly
            boatStack.isHidden = false
            beachHouseStack.isHidden = true
        case 2:
            //beach and boat
            beachHouseStack.isHidden = false
            boatStack.isHidden = false
        default:
            beachHouseStack.isHidden = false
            boatStack.isHidden = false
        }
        
        beachHouseStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoBeach)))
        boatStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoBoat)))

    }
    
    @objc func gotoBeach(){
        coordinator?.gotoSelectHouseTypeView()
    }

    @objc func gotoBoat(){
        print("Go to Boat")
        coordinator?.gotoBoatHouseTypeView()
    }
}

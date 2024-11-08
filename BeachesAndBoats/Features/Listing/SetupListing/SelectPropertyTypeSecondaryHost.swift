//
//  SelectPropertyTypeSecondaryHost.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 27/09/2024.
//

import UIKit

class SelectPropertyTypeSecondaryHost: BaseViewControllerPlain {

    @IBOutlet weak var propertyField: PropertyListField!
    
    var coordinator: AccountCoordinator?
    override func viewDidLoad() {
        super.viewDidLoad()

        propertyField.fieldEdited = { [weak self] in
            self?.showNotification()
        }
    }


    func showNotification(){
//        guard let selectedItem = propertyField.selectedItem else { return }
        ListingNotif.show(onConfirm: gotoNextScreen)
        
    }
    
    func gotoNextScreen(){
        guard let selectedItem = propertyField.selectedItem else { return }
        
        switch selectedItem.value {
        case "1":
            print("Beach only")
            coordinator?.gotoSelectPropertyTypePrimaryHost(tag: 0)
        case "2":
            print("Boat only")
            coordinator?.gotoSelectPropertyTypePrimaryHost(tag: 1)
        case "3":
            print("Beach and Boat")
            coordinator?.gotoSelectPropertyTypePrimaryHost(tag: 2)
        default:
            print("Beach and Boat")
            coordinator?.gotoSelectPropertyTypePrimaryHost(tag: 2)
        }
    }

}

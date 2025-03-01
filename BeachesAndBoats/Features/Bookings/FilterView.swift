//
//  FilterView.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 01/03/2025.
//

import UIKit

protocol FilterDelegate: AnyObject {
    func getSelectedItem(selectedItem: String)
}

class FilterView: UIViewController {
    
    @IBOutlet weak var cancelIcon: UIImageView!
    @IBOutlet weak var beachHouseStack: UIStackView!
    @IBOutlet weak var boatStack: UIStackView!
    @IBOutlet weak var servicesStack: UIStackView!
    @IBOutlet weak var beachRadioBtn: CheckboxButton!
    @IBOutlet weak var boatRadioBtn: CheckboxButton!
    @IBOutlet weak var serviceRadioBtn: CheckboxButton!
    
    var selectedItem: String?
    weak var filterDelegate: FilterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gestureRecognizers()
        setupRadioButtons()
    }
    
    func gestureRecognizers() {
        let beachHouseBtn = UITapGestureRecognizer(target: self, action: #selector(stackTapped(_:)))
        beachHouseStack.isUserInteractionEnabled = true
        beachHouseStack.addGestureRecognizer(beachHouseBtn)
        
        let boatBtn = UITapGestureRecognizer(target: self, action: #selector(stackTapped(_:)))
        boatStack.isUserInteractionEnabled = true
        boatStack.addGestureRecognizer(boatBtn)
        
        let serviceBtn = UITapGestureRecognizer(target: self, action: #selector(stackTapped(_:)))
        servicesStack.isUserInteractionEnabled = true
        servicesStack.addGestureRecognizer(serviceBtn)
        
        let cancel = UITapGestureRecognizer(target: self, action: #selector(cancelIconTapped))
        cancelIcon.isUserInteractionEnabled = true
        cancelIcon.addGestureRecognizer(cancel)
    }
    
    @objc func cancelIconTapped() {
        self.dismiss(animated: true)
    }
    
    func setupRadioButtons() {
        beachRadioBtn.stateChanged = { [weak self] _ in self?.selectRadioButton(self?.beachRadioBtn, selectedItem: "BeachHouse") }
        boatRadioBtn.stateChanged = { [weak self] _ in self?.selectRadioButton(self?.boatRadioBtn, selectedItem: "Boat") }
        serviceRadioBtn.stateChanged = { [weak self] _ in self?.selectRadioButton(self?.serviceRadioBtn, selectedItem: "Service") }
    }
    
    @objc func stackTapped(_ sender: UITapGestureRecognizer) {
        if sender.view == beachHouseStack {
            selectRadioButton(beachRadioBtn, selectedItem: "BeachHouse")
        } else if sender.view == boatStack {
            selectRadioButton(boatRadioBtn, selectedItem: "Boat")
        } else if sender.view == servicesStack {
            selectRadioButton(serviceRadioBtn, selectedItem: "Service")
        }
    }

    func selectRadioButton(_ selectedButton: CheckboxButton?, selectedItem: String) {
        beachRadioBtn.isChecked = (selectedButton == beachRadioBtn)
        boatRadioBtn.isChecked = (selectedButton == boatRadioBtn)
        serviceRadioBtn.isChecked = (selectedButton == serviceRadioBtn)
        self.selectedItem = selectedItem
    }

    @IBAction func applyBtnTapped(_ sender: Any) {
        filterDelegate?.getSelectedItem(selectedItem: selectedItem ?? "")
        self.dismiss(animated: true)
    }
}

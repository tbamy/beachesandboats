//
//  HostListingSortView.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 11/01/2025.
//

import UIKit

protocol SortDelegate: AnyObject {
    func getSelectedOption(selectedOption: String)
}

class HostListingSortView: UIViewController {
    
    @IBOutlet weak var sortTitle: UILabel!
    @IBOutlet weak var cancelIcon: UIImageView!
    @IBOutlet weak var newToOldDate: UIStackView!
    @IBOutlet weak var newToOldDateBtn: CheckboxButton!
    @IBOutlet weak var oldToNewDateStack: UIStackView!
    @IBOutlet weak var oldToNewDateBtn: CheckboxButton!
    @IBOutlet weak var bookNewToOldDateStack: UIStackView!
    @IBOutlet weak var bookNewToOldDateBtn: CheckboxButton!
    @IBOutlet weak var bookOldToNewDateStack: UIStackView!
    @IBOutlet weak var bookOldToNewDateBtn: CheckboxButton!
    
    
    var coordinator: HostingHouseAndBoatListingCoordinator?
    var isFromBooking: Bool = false
    var selectedItem: String?
    weak var sortDelegate: SortDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationButton()
        setupView()
        gestureRecognizer()
        setupRadioButtons()
    }
    
    func gestureRecognizer() {
        let cancel = UITapGestureRecognizer(target: self, action: #selector(closeTapped))
        cancelIcon.isUserInteractionEnabled = true
        cancelIcon.addGestureRecognizer(cancel)
        
        let newToOld = UITapGestureRecognizer(target: self, action: #selector(stackTapped(_:)))
        newToOldDate.isUserInteractionEnabled = true
        newToOldDate.addGestureRecognizer(newToOld)
        
        let oldToNew = UITapGestureRecognizer(target: self, action: #selector(stackTapped(_:)))
        oldToNewDateStack.isUserInteractionEnabled = true
        oldToNewDateStack.addGestureRecognizer(oldToNew)
        
        let bookNewToOld = UITapGestureRecognizer(target: self, action: #selector(stackTapped(_:)))
        bookNewToOldDateStack.isUserInteractionEnabled = true
        bookNewToOldDateStack.addGestureRecognizer(bookNewToOld)
        
        let bookOldToNew = UITapGestureRecognizer(target: self, action: #selector(stackTapped(_:)))
        bookOldToNewDateStack.isUserInteractionEnabled = true
        bookOldToNewDateStack.addGestureRecognizer(bookOldToNew)
    }
    
    func setupRadioButtons() {
        newToOldDateBtn.stateChanged = { [weak self] _ in self?.selectRadioButton(self?.newToOldDateBtn, selectedItem: "CheckNewToOld") }
        oldToNewDateBtn.stateChanged = { [weak self] _ in self?.selectRadioButton(self?.oldToNewDateBtn, selectedItem: "CheckOldToNew") }
        bookNewToOldDateBtn.stateChanged = { [weak self] _ in self?.selectRadioButton(self?.bookNewToOldDateBtn, selectedItem: "BookNewToOld") }
        bookOldToNewDateBtn.stateChanged = { [weak self] _ in self?.selectRadioButton(self?.bookOldToNewDateBtn, selectedItem: "BookOldToNew") }
    }
    
    @objc func stackTapped(_ sender: UITapGestureRecognizer) {
        if sender.view == newToOldDate {
            selectRadioButton(newToOldDateBtn, selectedItem: "CheckNewToOld")
        } else if sender.view == oldToNewDateStack {
            selectRadioButton(oldToNewDateBtn, selectedItem: "CheckOldToNew")
        } else if sender.view == bookNewToOldDateStack {
            selectRadioButton(bookNewToOldDateBtn, selectedItem: "BookNewToOld")
        } else if sender.view == bookOldToNewDateStack {
            selectRadioButton(bookNewToOldDateBtn, selectedItem: "BookOldToNew")
        }
    }

    func selectRadioButton(_ selectedButton: CheckboxButton?, selectedItem: String) {
        newToOldDateBtn.isChecked = (selectedButton == newToOldDateBtn)
        oldToNewDateBtn.isChecked = (selectedButton == oldToNewDateBtn)
        bookNewToOldDateBtn.isChecked = (selectedButton == bookNewToOldDateBtn)
        bookOldToNewDateBtn.isChecked = (selectedButton == bookOldToNewDateBtn)

        self.selectedItem = selectedItem
    }
    
    func setupNavigationButton() {
        let leftButton = UIBarButtonItem(image: UIImage(named: "close_icon")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(closeTapped))
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    func setupView() {
        if isFromBooking {
            cancelIcon.isHidden = false
            sortTitle.isHidden = false
        } else {
            cancelIcon.isHidden = true
            sortTitle.isHidden = true
        }
    }
    
    @objc func closeTapped() {
        self.dismiss(animated: true)
    }


    @IBAction func applyBtnTapped(_ sender: Any) {
        sortDelegate?.getSelectedOption(selectedOption: selectedItem ?? "")
        self.dismiss(animated: true)
    }
    
}

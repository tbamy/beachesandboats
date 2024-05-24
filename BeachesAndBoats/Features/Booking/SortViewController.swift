//
//  SortViewController.swift
//  BeachesAndBoats
//
//  Created by Paul Orimogunje on 18/05/2024.
//

import UIKit

class SortViewController: UIViewController {
    
    @IBOutlet weak var checkNewToOld: UIView!
    @IBOutlet weak var checkOldToNew: UIView!
    @IBOutlet weak var bookNewToOld: UIView!
    @IBOutlet weak var bookOldToNew: UIView!
    @IBOutlet var allOptions: [UIView]!
    @IBOutlet var allButtons: [UIButton]!
    @IBOutlet weak var closeIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        optionsSetup()
        setup()
        viewTapped(view: checkNewToOld)
    }
    
    func setup() {
        
        view.backgroundColor = UIColor(red: 0.102, green: 0.102, blue: 0.102, alpha: 0.2).withAlphaComponent(0.2)
        
        let cNewToOld = UITapGestureRecognizer(target: self, action: #selector(cNewToOldTapped))
        checkNewToOld.isUserInteractionEnabled = true
        checkNewToOld.addGestureRecognizer(cNewToOld)
        
        let cOldToNew = UITapGestureRecognizer(target: self, action: #selector(cOldToNewTapped))
        checkOldToNew.isUserInteractionEnabled = true
        checkOldToNew.addGestureRecognizer(cOldToNew)
        
        let bNewToOld = UITapGestureRecognizer(target: self, action: #selector(bNewToOldTapped))
        bookNewToOld.isUserInteractionEnabled = true
        bookNewToOld.addGestureRecognizer(bNewToOld)
        
        let bOldToNew = UITapGestureRecognizer(target: self, action: #selector(bOldToNewTapped))
        bookOldToNew.isUserInteractionEnabled = true
        bookOldToNew.addGestureRecognizer(bOldToNew)
        
        let close = UITapGestureRecognizer(target: self, action: #selector(close))
        closeIcon.isUserInteractionEnabled = true
        closeIcon.addGestureRecognizer(close)
    }
    
    @objc func close() {
        dismiss(animated: true)
    }
    
    @objc func cNewToOldTapped() {
        viewTapped(view: checkNewToOld)
    }
    
    @objc func cOldToNewTapped() {
        viewTapped(view: checkOldToNew)
    }
    
    @objc func bNewToOldTapped() {
        viewTapped(view: bookNewToOld)
    }
    
    @objc func bOldToNewTapped() {
        viewTapped(view: bookOldToNew)
    }
    
    func viewTapped(view: UIView) {
        allButtons.forEach { $0.isSelected = false }
        if let button = view.subviews.first(where: { $0 is UIButton }) as? UIButton {
            button.isSelected = true
        }
    }
    
    
    @IBAction func checkNewOldTapped(_ sender: UIButton) {
        allButtons.forEach {
            $0.isSelected = false
        }
        sender.isSelected = true
    }
    
    
    @IBAction func checkOldNewTapped(_ sender: UIButton) {
        allButtons.forEach {
            $0.isSelected = false
        }
        sender.isSelected = true
    }
    
    
    @IBAction func bookNewOldTapped(_ sender: UIButton) {
        allButtons.forEach {
            $0.isSelected = false
        }
        sender.isSelected = true
    }
    
    
    @IBAction func bookOldNew(_ sender: UIButton) {
        allButtons.forEach {
            $0.isSelected = false
        }
        sender.isSelected = true
    }
    
    func buttonSetup() {
        for buttons in allButtons {
            buttons.layer.cornerRadius = buttons.frame.height / 2
            buttons.setImage(UIImage(named: "radioOff")?.withRenderingMode(.alwaysTemplate), for: .normal)
            buttons.setImage(UIImage(named: "radioOn")?.withRenderingMode(.alwaysOriginal), for: .selected)
        }
    }
    
    func optionsSetup() {
        buttonSetup()
    }
}

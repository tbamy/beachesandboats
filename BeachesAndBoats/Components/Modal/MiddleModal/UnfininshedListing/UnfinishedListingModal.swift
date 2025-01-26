//
//  UnfinishedListingModal.swift
//  BeachesAndBoats
//
//  Created by WEMA on 17/01/2025.
//

import UIKit

class UnfinishedListingModal: UIView {
    
    @IBOutlet weak var closeIcon: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubtitle: UILabel!
    @IBOutlet weak var deleteTitleStack: UIStackView!
    @IBOutlet weak var listingName: UILabel!
    @IBOutlet weak var listingLocation: UILabel!
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    
    private var buttonOneAction: (() -> Void)?
    private var buttonTwoAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        guard let view = loadFromNib() else { return }
        view.frame = self.bounds
        addSubview(view)
        
        setupView()
    }
    
    private func loadFromNib() -> UIView? {
        let nibName = String(describing: UnfinishedListingModal.self)
        let bundle = Bundle(for: type(of: self))
        return bundle.loadNibNamed(nibName, owner: self)?.first as? UIView
    }
    
    private func setupView() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.6) // Semi-transparent background
        backgroundView.layer.cornerRadius = 12
        backgroundView.clipsToBounds = true
        backgroundView.backgroundColor = .white // Modal content background
        
        // Add gesture recognizer for the close icon
        closeIcon.isUserInteractionEnabled = true
        closeIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeModal)))
        
        // Ensure the modal is centered
        centerModal()
    }
    
    private func centerModal() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
    
    @objc private func closeModal() {
        self.removeFromSuperview()
    }
    
    // Configure the modal's content and actions
    func configure(
        listingName: String?,
        listingLocation: String?,
        showDeleteStack: Bool = true,
        buttonOneTitle: String?,
        buttonOneAction: (() -> Void)?,
        buttonTwoTitle: String?,
        buttonTwoAction: (() -> Void)?
    ) {
        
        deleteTitleStack.isHidden = !showDeleteStack
        self.listingName.text = listingName
        self.listingLocation.text = listingLocation
        
        self.buttonOne.setTitle(buttonOneTitle, for: .normal)
        self.buttonTwo.setTitle(buttonTwoTitle, for: .normal)
        
        self.buttonOneAction = buttonOneAction
        self.buttonTwoAction = buttonTwoAction
        
        buttonOne.addTarget(self, action: #selector(handleButtonOneAction), for: .touchUpInside)
        buttonTwo.addTarget(self, action: #selector(handleButtonTwoAction), for: .touchUpInside)
        
        // Adjust height based on showDeleteStack
        if !showDeleteStack {
            backgroundView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        }
    }
    
    @objc private func handleButtonOneAction() {
        buttonOneAction?()
        closeModal()
    }
    
    @objc private func handleButtonTwoAction() {
        buttonTwoAction?()
        closeModal()
    }
}

// Extension to present the modal in any view controller
extension UIViewController {
    func showUnfinishedListingModal(
        listingName: String?,
        listingLocation: String?,
        showDeleteStack: Bool = true,
        buttonOneTitle: String?,
        buttonOneAction: (() -> Void)?,
        buttonTwoTitle: String?,
        buttonTwoAction: (() -> Void)?
    ) {
        let modal = UnfinishedListingModal()
        modal.configure(
            listingName: listingName,
            listingLocation: listingLocation,
            showDeleteStack: showDeleteStack,
            buttonOneTitle: buttonOneTitle,
            buttonOneAction: buttonOneAction,
            buttonTwoTitle: buttonTwoTitle,
            buttonTwoAction: buttonTwoAction
        )
        
        modal.frame = self.view.bounds
        self.view.addSubview(modal)
    }
}

//
//  HorizonDateField.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 13/10/2024.
//

import Foundation
import UIKit

public class HorizonDateField: UIView {
    // MARK: - UI Components
    private let titleLabel = UILabel()
    private let textField = UITextField()
    private let calendarIcon = UIImageView()

    // Callback to handle date selection
    public var onDateSelected: ((String) -> Void)?

    // MARK: - Properties
    public var titleText: String = "" {
        didSet { titleLabel.text = titleText }
    }

    public var placeholder: String = "" {
        didSet {
            textField.placeholder = placeholder
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            )
        }
    }

    public var text: String {
        get { textField.text ?? "" }
        set { textField.text = newValue }
    }

    public var icon: UIImage? {
        didSet { calendarIcon.image = icon }
    }

    // MARK: - Initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Setup
    private func setup() {
        // Configure title label
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .darkGray

        // Configure text field
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 12)
        textField.isUserInteractionEnabled = false // User selects date via modal
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.rightViewMode = .always

        // Configure calendar icon
        calendarIcon.image = UIImage(named: "calendar")
        calendarIcon.contentMode = .scaleAspectFit
        calendarIcon.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showCalendarModal))
        calendarIcon.addGestureRecognizer(tapGesture)

        // Add subviews and layout
        let stackView = UIStackView(arrangedSubviews: [titleLabel, textField])
        stackView.axis = .vertical
        stackView.spacing = 4

        addSubview(stackView)
        addSubview(calendarIcon)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        calendarIcon.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: calendarIcon.leadingAnchor, constant: -8),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            calendarIcon.widthAnchor.constraint(equalToConstant: 24),
            calendarIcon.heightAnchor.constraint(equalToConstant: 24),
            calendarIcon.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            calendarIcon.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    // MARK: - Actions
    @objc private func showCalendarModal() {
        HorizonCalendarModal.show { [weak self] selectedDateRange in
            guard let self = self, let dateRange = selectedDateRange else { return }
            self.text = dateRange
            self.onDateSelected?(dateRange)
        }
    }
}



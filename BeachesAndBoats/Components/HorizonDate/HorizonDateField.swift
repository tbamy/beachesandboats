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
//    private let calendarIcon = UIImageView()

    // Callback to handle date selection
    public var onDateSelected: ((Date) -> Void)?
    public var onDatesSelected: ((Date, Date?) -> Void)?
    var isSingleDate: Bool = false
    
    public var startDate: Date = Date()
    public var endDate: Date = Calendar.current.date(byAdding: .month, value: 6, to: Date()) ?? Date()

    // MARK: - Properties
    public var titleText: String = "" {
        didSet { titleLabel.text = titleText }
    }

    public var placeholder: String = "" {
        didSet {
//            textField.placeholder = placeholder
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            )
        }
    }
    
    public var placeHolderColor: UIColor = .darkGray {
        didSet {
            titleLabel.textColor = placeHolderColor
        }
    }

    public var text: String {
        get { textField.text ?? "" }
        set {
//            textField.text = newValue
            textField.attributedText = underlinedText(newValue)
        }
    }

//    public var icon: UIImage? {
//        didSet { calendarIcon.image = icon }
//    }

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
        

        // Configure text field
//        textField.borderStyle = .roundedRect
        textField.toggleUnderline(self)
        textField.font = UIFont.systemFont(ofSize: 12)
        textField.isUserInteractionEnabled = false
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.rightViewMode = .always

//        // Configure calendar icon
//        calendarIcon.image = UIImage(named: "calendar")
//        calendarIcon.contentMode = .scaleAspectFit
        textField.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showCalendarModal))
        textField.addGestureRecognizer(tapGesture)

        // Add subviews and layout
        let stackView = UIStackView(arrangedSubviews: [titleLabel, textField])
        stackView.axis = .vertical
        stackView.spacing = 4

        addSubview(stackView)
//        addSubview(calendarIcon)

        stackView.translatesAutoresizingMaskIntoConstraints = false
//        calendarIcon.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)

//            calendarIcon.widthAnchor.constraint(equalToConstant: 24),
//            calendarIcon.heightAnchor.constraint(equalToConstant: 24),
//            calendarIcon.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
//            calendarIcon.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    // MARK: - Actions
    @objc private func showCalendarModal() {
        HorizonCalendarModal.show (start: startDate, end: endDate, isSingleDate: isSingleDate){ [weak self] startDate, endDate in
            guard let self = self else { return }
            if endDate == nil{
                if let startDate = startDate{
                    print("\(startDate)")
//                    self.text = "\(startDate)"
                    self.onDateSelected?(startDate)
                }
            }else{
                if let startDate = startDate, let endDate = endDate{
                    print("\(startDate) - \(endDate)")
//                    self.text = "\(startDate) - \(endDate)"
                    self.onDatesSelected?(startDate, endDate)
                }
            }
            
            
        }
    }
    
    
    func underlinedText(_ text: String, color: UIColor = .black, style: NSUnderlineStyle = .single) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: style.rawValue,
            .foregroundColor: color
        ]
        return NSAttributedString(string: text, attributes: attributes)
    }


}



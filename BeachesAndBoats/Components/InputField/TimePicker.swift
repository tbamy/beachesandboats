//
//  TimePicker.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 07/10/2024.
//

import UIKit

@IBDesignable public class TimePicker: InputField {
    var picker = UIDatePicker()
    
    public var selectedTime: Date? {
        didSet {
            if let selectedTime {
                // Format the time as HH:mm and set it to the textField
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                textField.text = formatter.string(from: selectedTime)
            } else {
                textField.text = ""
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func setup() {
        super.setup()
        setLeftImage()
        
        textBlocker.isHidden = false
        picker.timeZone = .current
        picker.tintColor = .B_B
        picker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels // Time pickers typically use the 'wheels' style
        }

        // Create a toolbar with a 'Done' button
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonTapped(_:)))
        doneButton.tintColor = .white
        let toolBar = UIToolbar()
        toolBar.barTintColor = .B_B
        toolBar.isTranslucent = true
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil), doneButton], animated: true)
        toolBar.sizeToFit()
        
        textField.inputAccessoryView = toolBar
        textField.inputView = picker
        textBlocker.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(self.pickerTapped(_:))))
    }
    
    func setLeftImage() {
        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 12))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
        imageView.image = Assets.dropdownIcon.image
        imageView.tintColor = .background
        imageView.contentMode = .scaleAspectFit
        iconContainer.addSubview(imageView)
        textField.rightViewMode = UITextField.ViewMode.always
        textField.rightView = iconContainer
    }

    // When the 'Done' button is tapped, set the selected time
    @objc func doneButtonTapped(_ sender: UIBarButtonItem) {
//        if picker.date != nil {
            textField.resignFirstResponder()
            selectedTime = picker.date
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            textField.text = formatter.string(from: picker.date)
//        }
    }
    
    @objc func pickerTapped(_ sender: UITapGestureRecognizer) {
        textField.becomeFirstResponder()
    }
}


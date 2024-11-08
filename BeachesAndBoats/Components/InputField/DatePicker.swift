//
//  DatePicker.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 12/05/2024.
//


//import UIKit
//
//@IBDesignable public class DatePicker: InputField {
//    var startDatePicker = UIDatePicker()
//    var endDatePicker = UIDatePicker()
//    
//    public var minimumDate: Date? {
//        didSet {
//            startDatePicker.minimumDate = minimumDate
//            endDatePicker.minimumDate = minimumDate
//        }
//    }
//    
//    public var maximumDate: Date? {
//        didSet {
//            startDatePicker.maximumDate = maximumDate
//            endDatePicker.maximumDate = maximumDate
//        }
//    }
//    
//    public var selectedStartDate: Date? {
//        didSet {
//            if let startDate = selectedStartDate, let endDate = selectedEndDate {
//                textField.text = "\(String.toReadableDate(date: startDate)) - \(String.toReadableDate(date: endDate))"
//            }
//        }
//    }
//    
//    public var selectedEndDate: Date? {
//        didSet {
//            if let endDate = selectedEndDate, let startDate = selectedStartDate {
//                textField.text = "\(String.toReadableDate(date: startDate)) - \(String.toReadableDate(date: endDate))"
//            }
//        }
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setup()
//    }
//    
//    override func setup() {
//        super.setup()
//        setLeftImage()
//        
//        textBlocker.isHidden = false
//        
//        configureDatePicker(startDatePicker)
//        configureDatePicker(endDatePicker)
//        
//        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonTapped(_:)))
//        doneButton.tintColor = .white
//        let toolBar = UIToolbar()
//        toolBar.barTintColor = .B_B
//        toolBar.isTranslucent = true
//        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil), doneButton], animated: true)
//        toolBar.sizeToFit()
//        textField.inputAccessoryView = toolBar
//        
//        // Display both date pickers as input views
//        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300))
//        containerView.addSubview(startDatePicker)
//        containerView.addSubview(endDatePicker)
//        
//        // Layout the date pickers side by side
//        let pickerWidth = containerView.frame.width / 2
//        startDatePicker.frame = CGRect(x: 0, y: 0, width: pickerWidth, height: containerView.frame.height)
//        endDatePicker.frame = CGRect(x: pickerWidth, y: 0, width: pickerWidth, height: containerView.frame.height)
//        
//        textField.inputView = containerView
//        textBlocker.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.pickerTapped(_:))))
//    }
//    
//    private func configureDatePicker(_ datePicker: UIDatePicker) {
//        datePicker.timeZone = .current
//        datePicker.tintColor = .B_B
//        datePicker.datePickerMode = .date
//        if #available(iOS 13.4, *) {
//            if #available(iOS 14.0, *) {
//                datePicker.preferredDatePickerStyle = .inline
//            } else {
//                datePicker.preferredDatePickerStyle = .wheels
//            }
//        }
//    }
//    
//    func setLeftImage() {
//        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 12))
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
//        imageView.image = Assets.dropdownIcon.image
//        imageView.tintColor = .background
//        imageView.contentMode = .scaleAspectFit
//        iconContainer.addSubview(imageView)
//        textField.rightViewMode = UITextField.ViewMode.always
//        textField.rightView = iconContainer
//    }
//    
//    @objc func doneButtonTapped(_ sender: UIBarButtonItem) {
//        if startDatePicker.date <= endDatePicker.date {
//            textField.resignFirstResponder()
//            selectedStartDate = startDatePicker.date
//            selectedEndDate = endDatePicker.date
//            textField.text = "\(String.toReadableDate(date: startDatePicker.date)) - \(String.toReadableDate(date: endDatePicker.date))"
//        }
//    }
//
//    @objc func pickerTapped(_ sender: UITapGestureRecognizer) {
//        textField.becomeFirstResponder()
//    }
//}






import UIKit

@IBDesignable public class DatePicker: InputField {
    var picker = UIDatePicker()
    
    public var minimumDate: Date? {
        didSet {
            picker.minimumDate = minimumDate
        }
    }
    
    public var maximumDate: Date? {
        didSet {
            picker.maximumDate = maximumDate
        }
    }
    
    public var selectedDate: Date? {
        didSet {
            if let selectedDate {
                textField.text = String.toReadableDate(date: selectedDate)
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
        //picker.backgroundColor = .white
        picker.timeZone = .current
        picker.tintColor = .B_B
        picker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            if #available(iOS 14.0, *) {
                picker.preferredDatePickerStyle = .inline
            } else {
                picker.preferredDatePickerStyle = .wheels
            }
        } else {
            // Fallback on earlier versions
        }
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.donButtonTapped(_:)))
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
    
    public func setItem(with item: PickerItem) {
        
    }
    
    @objc func donButtonTapped(_ sender: UIBarButtonItem) {
//        if picker.date {
            textField.resignFirstResponder()
            selectedDate = picker.date
            textField.text = String.toReadableDate(date: picker.date)
//        }
    }

    @objc func pickerTapped(_ sender: UITapGestureRecognizer) {
        textField.becomeFirstResponder()
    }
}

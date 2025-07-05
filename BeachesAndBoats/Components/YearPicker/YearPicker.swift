//
//  YearPicker.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 01/01/2025.
//

import UIKit

class YearPickerButton: UIButton {
    private let years: [String]
    private var pickerView: UIPickerView!
    private var toolbar: UIToolbar!
    private var textField: UITextField!
    
    private(set) var selectedYear: String?
    var onYearSelected: ((String) -> Void)?
      
    
    init(frame: CGRect, startYear: Int = 2000, endYear: Int = 2280) {
        self.years = Array(startYear...endYear).map { String($0) }
        super.init(frame: frame)
        setupButton()
        setupPickerView()
    }
    
    required init?(coder: NSCoder) {
        self.years = Array(2000...2280).map { String($0) }
        super.init(coder: coder)
        setupButton()
        setupPickerView()
    }
    
    private func setupButton() {
        setTitle("Select Year", for: .normal)
        setTitleColor(.white, for: .normal)
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    private func setupPickerView() {
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        textField = UITextField()
        textField.inputView = pickerView
        addSubview(textField)
        textField.isHidden = true
        
        toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceButton, doneButton], animated: false)
        textField.inputAccessoryView = toolbar
    }
    
    @objc private func buttonTapped() {
        textField.becomeFirstResponder()
    }
    
    @objc private func doneTapped() {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        selectedYear = years[selectedRow]
        setTitle(selectedYear, for: .normal)
        onYearSelected?(selectedYear!)
        textField.resignFirstResponder()
    }
}

extension YearPickerButton: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return years[row]
    }
}

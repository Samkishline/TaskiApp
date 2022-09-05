//
//  AddTaskView.swift
//  Taski
//
//  Created by Sam Kishline
//

import UIKit

class AddTaskView: UIView {
    
    @IBOutlet weak var addTaskTextView: UITextView!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var topView: UIView!
    
    private var datePicker: UIDatePicker!
    var selectedDate: Date = Date()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupDatePicker()
    }
    
    @IBAction func notificationSwitchValueChanged(_ sender: UISwitch) {
        
        self.dateTextField.text = ""
        self.dateTextField.isHidden = !notificationSwitch.isOn
    }
    
    private func setupDatePicker() {
        
        self.topView.cornerRadius = 8
        self.topView.layer.borderColor = UIColor.lightGray.cgColor
        self.topView.layer.borderWidth = 1.0
        
        self.addTaskTextView.text = "Add task details"
        self.addTaskTextView.textColor = .lightGray
        
        // Create Date Picker
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker?.addTarget(self, action: #selector(handleDatePickerValueChanged), for: .valueChanged)
        dateTextField.delegate = self
        
        // Create Toolbar
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(dismissPicker))
        
        // Add Toolbar To TextField
        dateTextField.inputAccessoryView = toolBar
        
        // Add Date Picker To TextField
        dateTextField.inputView = datePicker
        self.dateTextField.isHidden = !notificationSwitch.isOn
    }
    
    @objc private func handleDatePickerValueChanged(_ datePicker: UIDatePicker) {
        self.selectedDate = datePicker.date
        self.dateTextField.text = datePicker.date.convertDateTimeInFormat()
    }
    
    @objc private func dismissPicker() {
        self.endEditing(true)
    }
    
    class func instantiateFromNib() -> AddTaskView {
        return Bundle.main.loadNibNamed("AddTaskView", owner: nil, options: nil)!.first as! AddTaskView
    }
}

extension AddTaskView: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == "Add task details" {
            self.addTaskTextView.text = ""
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == self.addTaskTextView && textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == self.addTaskTextView && textView.text.isEmpty {
            textView.text = "Add task details"
            textView.textColor = .lightGray
        }
    }
}

// MARK: - UITextFieldDelegate
extension AddTaskView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == dateTextField {
            return false
        }
        return true
    }
}

extension Date {
    func convertDateTimeInFormat() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "E, d MMM yyyy HH:mm"
        let newTime = formatter.string(from: self)
        return newTime
    }
}

extension UIToolbar {
    
    func ToolbarPiker(mySelect: Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: mySelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
}

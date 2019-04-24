//
//  AddEventViewController.swift
//  Calendar
//
//  Created by WY NG on 20/4/2019.
//  Copyright © 2019 lumanmann. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController {
    
    let eventTitleTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Event Title"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        
        tf.textContentType = UITextContentType.emailAddress
        
        return tf
    }()
    
    let dateTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
       
        return tf
    }()
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
        datePicker.date = Date()
        datePicker.locale = Locale(
            identifier: "zh_TW")
        
        return datePicker
    }()
    
    let toolbar: UIToolbar = {
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(finishTexting))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceItem, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Event", for: .normal)
        button.layer.cornerRadius = 5.0
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.darkGray
        
        button.isEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(addClicked), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setupInputFields()
        
    }
    
    @objc func addClicked(sender: UIButton) {
        guard let title = eventTitleTextField.text, title.count > 0 else {
            print("Wrong input")
           return
        }
        events.append(Event(date: datePicker.date, title: title))
        
    }
    
    @objc func finishTexting(sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
        let date = dateFormatter.string(from: datePicker.date)
        dateTextField.text = date
        
        // dismiss
        view.endEditing(true)
    }
    
    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [eventTitleTextField, dateTextField, addButton])
        
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.axis = .vertical
        
        view.addSubview(stackView)
        
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, bottom: nil, paddingTop: 40, paddingLeading: 40, paddingTrailing: 40, paddingBottom: 0, width: 0, height: 150)
        
        dateTextField.inputView = self.datePicker
        dateTextField.inputAccessoryView = self.toolbar
    }

    

   

}


//
//  SettingsViewController.swift
//  PCCS
//
//  Created by sahil.khanna on 21/10/18.
//  Copyright © 2018 sahil.khanna. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet var username: UITextField!;
    @IBOutlet var password: UITextField!;
    @IBOutlet var url: UITextField!;
    @IBOutlet var date: UITextField!;
    
    //MARK: UIViewController Delegate
    override func viewDidLoad() {
        super.viewDidLoad();
                
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveData));
        populateFields();
    }
        
    @objc func saveData() {
        username.text = Utils.instance.trimString(string: username.text);
        password.text = Utils.instance.trimString(string: password.text);
        url.text = Utils.instance.trimString(string: url.text);
        date.text = Utils.instance.trimString(string: date.text);
        
        if (username.text?.count == 0 || password.text?.count == 0 || url.text?.count == 0) {
            let alertController = UIAlertController(title: "Alert", message: "All fields are mandatory", preferredStyle: .alert);
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil));
            present(alertController, animated: true, completion: nil);
        }
        else if (!isURLValid(urlString: url.text!)) {
            let alertController = UIAlertController(title: "Alert", message: "URL is invalid", preferredStyle: .alert);
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil));
            present(alertController, animated: true, completion: nil);
        }
        else {
            let storage = Storage.instance;
            storage.set(value: username.text, forKey: "username");
            storage.set(value: password.text, forKey: "password");
            storage.set(value: url.text, forKey: "url");
            storage.set(value: date.text, forKey: "date");
            navigationController?.popViewController(animated: true);
        }
    }
    
    //MARK: UIButton Action
    @IBAction func showPassword(sender: UIButton) {
        if (sender.tag == 0) {
            sender.setImage(UIImage(named: "eye"), for: .normal);
            password.isSecureTextEntry = false;
            sender.tag = 1;
        }
        else {
            sender.setImage(UIImage(named: "eye-hidden"), for: .normal);
            password.isSecureTextEntry = true;
            sender.tag = 0;
        }
    }
    
    @IBAction func dateTapped() {
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 30, width: view.frame.size.width, height: 162));
        datePicker.datePickerMode = .date;
        datePicker.maximumDate = Date();
        
        if ((date.text?.count)! > 0) {
            datePicker.date = Utils.instance.stringToDate(date: date.text!, format: Constants.DATE_FORMAT_DD_MM_YYYY)!;
        }

        let alertController = UIAlertController(title: "Select Date", message: "\n\n\n\n\n\n\n", preferredStyle: .actionSheet);
        alertController.view.addSubview(datePicker);
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.date.text = Utils.instance.dateToString(date: datePicker.date, format: Constants.DATE_FORMAT_DD_MM_YYYY);
        }));
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil));
        present(alertController, animated: true, completion: nil);
    }
    
    //MARK: Other Methods
    private func populateFields() {
        let userDefaults = UserDefaults.standard;
        username.text = userDefaults.string(forKey: "username");
        password.text = userDefaults.string(forKey: "password");
        url.text = userDefaults.string(forKey: "url");
        date.text = userDefaults.string(forKey: "date");
    }
    
    private func isURLValid(urlString: String) -> Bool {
        let url = NSURL(string: urlString);
        return (url != nil) && (url?.host != nil) && (url?.scheme != nil) && (urlString.contains("http://") || (urlString.contains("https://")));
//        let urlRegEx = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
//        let urlTest = NSPredicate.init(format: "SELF MATCHES %@", urlRegEx);
//        return urlTest.evaluate(with: url);
    }
}

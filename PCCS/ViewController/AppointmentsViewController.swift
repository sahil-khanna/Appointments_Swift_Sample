//
//  AppointmentsViewController.swift
//  PCCS
//
//  Created by sahil.khanna on 21/10/18.
//  Copyright © 2018 sahil.khanna. All rights reserved.
//

import UIKit
import SWXMLHash

class AppointmentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var appointments: [XMLIndexer] = [];
    @IBOutlet var name: UILabel!;
    @IBOutlet var date: UILabel!;
    @IBOutlet var tableView: UITableView!

    //MARK: UIViewController Delegate
    override func viewDidLoad() {
        super.viewDidLoad();
        
        navigationController?.navigationBar.tintColor = UIColor.white;
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil);
        tableView.tableFooterView = UIView(frame: .zero);
        
        refresh();
    }
    
    //MARK: UIButton Action
    @IBAction func refresh() {
        if (UserDefaults.standard.string(forKey: "url") == nil) {
            performSegue(withIdentifier: "SettingsSegue", sender: self);
            return;
        }
        
        Utils.instance.showLoadingIndicator(value: true);
        
        let storage = Storage.instance;
        date.text = storage.value(forKey: "date") as? String;
        date.isHidden = true;
        name.text = "";
        tableView.isHidden = true;
        
        let payload = [
            "GetAppointmentDetails": [
                "SLUsername": storage.value(forKey: "username"),
                "SLPassword": storage.value(forKey: "password"),
                "CurrentDate": storage.value(forKey: "date")
            ]
        ];
        
        WebServiceHandler.instance.execute(url: storage.value(forKey: "url") as! String, method: .APPOINTMENT_DETAILS, payload: payload as NSDictionary) { (response) in
            
            Utils.instance.showLoadingIndicator(value: false);
            if (response.code != 0) {
                let alertController = UIAlertController(title: "Alert", message: response.message, preferredStyle: .alert);
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil));
                self.present(alertController, animated: true, completion: nil);
                return;
            }
            
            let responseXML = (response.data as! XMLIndexer)["Response"];
            if (responseXML["ResponseCode"].element?.text == "SC0001") {
                self.appointments = responseXML["Appointments"].children;
                self.tableView.reloadData();
                self.name.text = Utils.instance.trimString(string: (responseXML["Defaults"]["FullName"].element?.text)!);
                self.date.isHidden = false;
                self.tableView.isHidden = false;
            }
            else {
                let alertController = UIAlertController(title: "Alert", message: responseXML["ResponseDescription"].element?.text, preferredStyle: .alert);
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil));
                self.present(alertController, animated: true, completion: nil);
                
                self.appointments = responseXML["Appointments"].children;
                self.tableView.reloadData();
                self.name.text = "";
                self.date.isHidden = true;
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "AppointmentSegue") {
            let appointmentViewController = segue.destination as! AppointmentViewController;
            appointmentViewController.appointment = sender as! XMLIndexer;
        }
    }
    
    //MARK: UITableView Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath);
        
        let appointment = appointments[indexPath.row];
        cell.textLabel?.text = Utils.instance.trimString(string: (appointment["CustomerDetails"]["CustomerTitle"].element?.text)! + " " + (appointment["CustomerDetails"]["CustomerForename"].element?.text)! + " " + (appointment["CustomerDetails"]["CustomerSurname"].element?.text)!);
        cell.detailTextLabel?.text = Utils.instance.trimString(string: (appointment["JobDetails"]["AppointmentTime"].element?.text)!);
        return cell;
    }
    
    //MARK: UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        
        performSegue(withIdentifier: "AppointmentSegue", sender: appointments[indexPath.row]);
    }
}

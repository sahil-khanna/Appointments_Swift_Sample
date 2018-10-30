//
//  AppointmentViewController.swift
//  PCCS
//
//  Created by sahil.khanna on 29/10/18.
//  Copyright © 2018 sahil.khanna. All rights reserved.
//

import Foundation
import SWXMLHash
import MapKit

class AppointmentViewController: UIViewController {
    
    // TODO: Show Time
    
    var appointment: XMLIndexer!;
    @IBOutlet var name: UILabel!;
    @IBOutlet var address: UILabel!;
    @IBOutlet var appointmentDetails: UILabel!
    @IBOutlet var phone: UILabel!;
    @IBOutlet var map: MKMapView!;
    @IBOutlet var phoneButton: UIButton!;
    
    //MARK: UIViewController Delegate
    override func viewDidLoad() {
        super.viewDidLoad();
        
        title = "Appointment";
        
        populateFields();
    }
    
    //MARK: Other Methods
    private func populateFields() {
        let customerDetails = appointment["CustomerDetails"];
        
        name.text = Utils.instance.trimString(string: (customerDetails["CustomerTitle"].element?.text)! + " " + (customerDetails["CustomerForename"].element?.text)! + " " + (customerDetails["CustomerSurname"].element?.text)!);
        address.text = Utils.instance.trimString(string: (customerDetails["CustomerCompanyName"].element?.text)! + " " + (customerDetails["CustomerBuildingName"].element?.text)! + " " + (customerDetails["CustomerStreet"].element?.text)! + " " + (customerDetails["CustomerAddressArea"].element?.text)! + " " + (customerDetails["CustomerAddressTown"].element?.text)! + " " + (customerDetails["CustomerCounty"].element?.text)!);
        appointmentDetails.text = Utils.instance.trimString(string: (appointment["WarrantyDetails"]["ChargeType"].element?.text)! + " " + (appointment["WarrantyDetails"]["JobType"].element?.text)!);
        phone.text = Utils.instance.trimString(string: (customerDetails["CustomerMobileNo"].element?.text)!);
        
        if ((phone.text?.count)! > 0) {
            phoneButton.isHidden = false;
        }
        
        // Show Map
        let location = CLLocation(latitude: Utils.instance.numberFromString(text: (customerDetails["ApptLatitude"].element?.text)!) as! CLLocationDegrees, longitude: Utils.instance.numberFromString(text: (customerDetails["ApptLatitude"].element?.text)!) as! CLLocationDegrees);
        
        map.setCenter(location.coordinate, animated: true);

        let annotation = MKPointAnnotation();
        annotation.title = customerDetails["CustomerPostcode"].element?.text;
        annotation.coordinate = location.coordinate;
        map.addAnnotation(annotation);
    }
    
    //MARK: UIButton Action
    @IBAction func callNumber() {
        let url = URL(string: "tel://" + phone.text!);
        if (url != nil && UIApplication.shared.canOpenURL(url!)) {
            UIApplication.shared.open(url!);
        }
    }
}

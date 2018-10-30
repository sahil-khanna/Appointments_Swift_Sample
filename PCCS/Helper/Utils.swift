//
//  Utils.swift
//  PCCS
//
//  Created by sahil.khanna on 22/10/18.
//  Copyright © 2018 sahil.khanna. All rights reserved.
//

import Foundation
import AEXML

class Utils {
    
    static let instance = Utils();
    
    private var loadingViewController: LoadingViewController?;
    
    private init() {}
    
    func trimString(string: String?) -> String {
        if (string == nil) {
            return "";
        }
        else {
            return string!.trimmingCharacters(in: .whitespacesAndNewlines);
        }
    }
    
    func dateToString(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = format;
        return dateFormatter.string(from: date);
    }
    
    func stringToDate(date: String, format: String) -> Date? {
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = format;
        return dateFormatter.date(from: date);
    }
    
    func numberFromString(text: String) -> NSNumber? {
        return NumberFormatter().number(from: text);
    }
    
    func showLoadingIndicator(value: Bool) {
        if (value) {
            loadingViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoadingViewController") as? LoadingViewController;
            UIApplication.shared.keyWindow?.addSubview((loadingViewController?.view)!);
        }
        else {
            loadingViewController?.view.removeFromSuperview();
            loadingViewController = nil;
        }
    }
    
    func dictionaryToXML(dictionary: NSDictionary) -> AEXMLDocument {
        let xml = AEXMLDocument();
        let rootNode: AEXMLElement;
        
        func iterateDictionary(parentNode: AEXMLElement, dict: NSDictionary) {
            for key in dict.allKeys {
                let element = dict.value(forKey: key as! String);
                
                if let value = element as? String {
                    parentNode.addChild(name: key as! String, value: value, attributes: [:]);
                }
                else if let value = element as? NSNumber {
                    parentNode.addChild(name: key as! String, value: value.stringValue, attributes: [:]);
                }
                else if let value = element as? Bool {
                    parentNode.addChild(name: key as! String, value: String(value), attributes: [:]);
                }
                else if let value = element as? NSDictionary {
                    let newNode = AEXMLElement(name: key as! String);
                    parentNode.addChild(newNode);
                    iterateDictionary(parentNode: newNode, dict: value);
                }
                else if let value = element as? [NSDictionary] {
                    // TODO: Test this section
                    let newNode = AEXMLElement(name: key as! String);
                    parentNode.addChild(newNode);
                    for childDict in value {
                        iterateDictionary(parentNode: newNode, dict: childDict);
                    }
                }
            }
        }
        
        if (dictionary.count > 1) {
            rootNode = AEXMLElement(name: "root");
            xml.addChild(rootNode);
            iterateDictionary(parentNode: rootNode, dict: dictionary);
        }
        else {
            iterateDictionary(parentNode: xml, dict: dictionary);
        }
        
        return xml;
        
        /* SAMPLE TO TEST
         let payload = [
         "GetAppointmentDetails": [
         "SLUsername": "Hello",
         "SLPassword": "Password",
         "CurrentDate": "DD_MM_YYYY"
         ],
         "Name": "Sahil",
         "Roll No": 100121,
         "isValid": true,
         "Subjects": [
         ["name": "English", "marks": 55],
         ["name": "Maths", "marks": 20],
         ["name": "Hindi", "marks": 76]
         ],
         "grades": [
         "A",
         "B",
         "C"
         ],
         "years": [2006, 2007, 2008]
         ] as [String : Any];

         */
    }
}

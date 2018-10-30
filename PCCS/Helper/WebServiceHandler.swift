//
//  WebServiceHandler.swift
//  PCCS
//
//  Created by sahil.khanna on 23/10/18.
//  Copyright © 2018 sahil.khanna. All rights reserved.
//

import Foundation
import Alamofire
import AEXML
import SWXMLHash

class WebServiceHandler {
    
    struct WebserviceResponse {
        var code: Int?;
        var message: String?;
        var data: Any?;
    }
    
    typealias Callback = (WebserviceResponse) -> Void;
    
    enum Method: String {
        case APPOINTMENT_DETAILS = "GetAppointmentDetails"
    }
    
    public static let instance = WebServiceHandler();
    
    private init() {}
    
    func execute(url: String, method: Method, payload: NSDictionary, callback: @escaping Callback) {
        let xml = Utils.instance.dictionaryToXML(dictionary: payload);
        
        var httpMethod: HTTPMethod;
        switch method {
        case .APPOINTMENT_DETAILS:
            httpMethod = .post
            
        }
        
        var urlRequest = URLRequest(url: URL(string: url + "/" + method.rawValue)!)
        urlRequest.addValue("application/xml", forHTTPHeaderField: "Content-Type");
        urlRequest.httpMethod = httpMethod.rawValue;
        urlRequest.httpBody = xml.xml.data(using: .utf8, allowLossyConversion: true);
        
        Alamofire.request(urlRequest)
            .responseData { (response) in
                switch response.result {
                case .success(_):
                    let stringResponse: String = (String(data: response.data!, encoding: String.Encoding.utf8) as String?)!
                    callback(WebserviceResponse(code: 0, message: nil, data: SWXMLHash.parse(stringResponse)));
                case .failure(_):
                    callback(WebserviceResponse(code: -1, message: response.error?.localizedDescription, data: nil));
                }
        }
    }
}

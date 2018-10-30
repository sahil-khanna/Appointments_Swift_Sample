//
//  Storage.swift
//  PCCS
//
//  Created by sahil.khanna on 27/10/18.
//  Copyright © 2018 sahil.khanna. All rights reserved.
//

import Foundation

class Storage {
    
    static let instance = Storage();
    
    private init() {};
    
    func value(forKey: String) -> Any? {
        return UserDefaults.standard.value(forKey: forKey);
    }
    
    func set(value: Any?, forKey: String) {
        UserDefaults.standard.setValue(value, forKey: forKey);
        UserDefaults.standard.synchronize();
    }
}

//
//  LoadingViewController.swift
//  PCCS
//
//  Created by sahil.khanna on 30/10/18.
//  Copyright © 2018 sahil.khanna. All rights reserved.
//

import UIKit
import Lottie

class LoadingViewController: UIViewController {
    
    @IBOutlet var loadingIndicator: LOTAnimationView!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        loadingIndicator.setAnimation(named: "loading");
        loadingIndicator.loopAnimation = true;
        loadingIndicator.play();
    }
}

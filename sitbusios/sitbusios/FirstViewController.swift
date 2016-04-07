//
//  FirstViewController.swift
//  sitbusios
//
//  Created by lpcm on 06/04/2016.
//  Copyright © 2016 lpcm. All rights reserved.
//

import UIKit

var token = "5beafb4a-b02f-429c-8222-cd92d1c20355";
var baseUrl = "https://"+token+"@api.navitia.io/v1/coverage/fr-idf/networks";

class FirstViewController: UIViewController {
    
    var loc = CoreLocationController();
    

    @IBOutlet weak var stopTimeRemaining: UILabel!
    
    @IBOutlet weak var stopDetailsLabel: UILabel!
    let stopDetailsBase = "Avant le prochains passage à ";
    override func viewDidLoad() {
        print(baseUrl);
        super.viewDidLoad()
        stopTimeRemaining.text = "8 minutes";
        stopDetailsLabel.text = stopDetailsBase+"Grand Champs";
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


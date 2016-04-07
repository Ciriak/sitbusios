//
//  FirstViewController.swift
//  sitbusios
//
//  Created by lpcm on 06/04/2016.
//  Copyright © 2016 lpcm. All rights reserved.
//

import UIKit
//import Alamofire  <-Pas moyen, même avec un Podfile il veut pas


var token = "5beafb4a-b02f-429c-8222-cd92d1c20355";
var baseUrl = "https://"+token+"@api.navitia.io/v1/coverage/fr-idf/";

class FirstViewController: UIViewController {
    
    var loc = CoreLocationController();
    
    // Coup de gueule :
    /* C'est quoi ce bordel pour récupérer un pauvre JSON ??? Sur mobile c'est genre le truc DE BASE dire qu'en web on peut faire $.getJSON('xx');, tsss c'est vraiment pourrie SWIFT !!!*/
    
    // Pas moyen de
    

    @IBOutlet weak var stopTimeRemaining: UILabel!
    
    @IBOutlet weak var stopDetailsLabel: UILabel!
    let stopDetailsBase = "Avant le prochains passage à ";
    override func viewDidLoad() {
        
        
        let requestURL: NSURL = NSURL(string: baseUrl+"coords/2.637192;48.804668/stop_areas?distance=500")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
            }
            else {
                print("HTTP error "+String(statusCode)+" "+String(httpResponse));
            }

        }
        
        task.resume();
    
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


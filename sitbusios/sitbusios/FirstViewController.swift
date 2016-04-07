//
//  FirstViewController.swift
//  sitbusios
//
//  Created by lpcm on 06/04/2016.
//  Copyright © 2016 lpcm. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


var token = "5beafb4a-b02f-429c-8222-cd92d1c20355";
var baseUrl = "https://api.navitia.io/v1/coverage/fr-idf/";

class FirstViewController: UIViewController {
    
    var loc = CoreLocationController();
    
    // Coup de gueule :
    /* C'est quoi ce bordel pour récupérer un pauvre JSON ??? Sur mobile c'est genre le truc DE BASE dire qu'en web on peut faire $.getJSON('xx');, tsss c'est vraiment pourrie SWIFT !!!*/
    
    // Poursuivont :) ...

    @IBOutlet weak var stopTimeRemaining: UILabel!
    
    @IBOutlet weak var stopDetailsLabel: UILabel!
    var stopDetailsBase = "Avant le prochains passage à ";
    override func viewDidLoad() {
        
        
        let requestUrl = baseUrl+"coords/2.637192;48.804668/stop_areas?distance=500";
        //on récupère les informations sur les arrêts les plus proches
        Alamofire.request(.GET, requestUrl, encoding:.JSON)
            .authenticate(user: token, password: "")
            .responseJSON
            { response in switch response.result {
            case .Success(let JSON):
                let response = JSON as? [NSObject: AnyObject]
                //print(response["stop_areas"]![0]["label"]);
                let s = response!["stop_areas"]![0]["label"];
                self.stopDetailsLabel.text = self.stopDetailsBase+String(s);
                
                
                case .Failure(let error):
                print("Request failed with error: \(error)")
                }
        }
        
        // on récuère les horaires de l'arrêt le plus proche
        let requestUrl2 = baseUrl+"stop_areas/stop_area:OIF:SA:48:7133/stop_schedules";
        
        Alamofire.request(.GET, requestUrl2, encoding:.JSON)
            .authenticate(user: token, password: "")
            .responseJSON
            { response in switch response.result {
            case .Success(let JSON):
                let response = JSON as? [NSObject: AnyObject]
                //print(response["stop_areas"]![0]["label"]);
                let s = response!["stop_schedules"]![0]["date_times"]!![0]["date_time"];
                let stopTime = String(s);
                
                // on convertit la date en format lisible
                let dateFormatter = NSDateFormatter()
                dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                dateFormatter.timeZone = NSTimeZone.localTimeZone()
                dateFormatter.dateFormat = "yyyyMMdd'T'HHmmssZZZ"
                let dateObject = dateFormatter.dateFromString(stopTime);
                
                print(dateObject);
                
                
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
                }
        }
    
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


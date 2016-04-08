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
import CoreLocation


var token = "5beafb4a-b02f-429c-8222-cd92d1c20355";
var baseUrl = "https://api.navitia.io/v1/coverage/fr-idf/";



class FirstViewController: UIViewController,CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    var currentLoc = CLLocationCoordinate2D();
    
    // Coup de gueule :
    /* C'est quoi ce bordel pour récupérer un pauvre JSON ??? Sur mobile c'est genre le truc DE BASE dire qu'en web on peut faire $.getJSON('xx');, tsss c'est vraiment pourrie SWIFT !!!*/
    
    // Poursuivont :) ...

    @IBOutlet weak var stopTimeRemaining: UILabel!
    
    @IBOutlet weak var stopDetailsLabel: UILabel!
    var stopDetailsBase = "Avant le prochains passage à ";
    override func viewDidLoad() {
        
        // la position courante est actualisée toues les 10 secondes (ainsi que les infos sur l'arrêt le plus proche)
        
        // a noter que la localisation est intérprétée seulement eu deuxième essai (mais je ne pige pas pk)
        _ = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: #selector(FirstViewController.retreiveLoc), userInfo: nil, repeats: true)
        
        manager.delegate = self;
        self.retreiveLoc();
    
        super.viewDidLoad()
        
    }
    
    // cette fonction est appelée losque la position est déterminée, elle contacte l'API et applique les données reçu
    func refreshLocInfo(){
        print("Refreshing stop info...");
        let requestUrl = baseUrl+"coords/"+String(currentLoc.longitude)+";"+String(currentLoc.latitude)+"/stop_areas?distance=500";
        //on récupère les informations sur les arrêts les plus proches
        Alamofire.request(.GET, requestUrl, encoding:.JSON)
            .authenticate(user: token, password: "")
            .responseJSON
            { response in switch response.result {
            case .Success(let JSON):
                let response = JSON as? [NSObject: AnyObject]
                if(response!["stop_areas"] != nil)
                {
                    print(response!["stop_areas"]![0]["label"]!);
                    let s = response!["stop_areas"]![0]["label"]!;
                    self.stopDetailsLabel.text = self.stopDetailsBase+String(s!);
                }
                else{
                    let alert = UIAlertController(title: "Oops...", message: "No stop point detected near you", preferredStyle: UIAlertControllerStyle.Alert);
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
                
                
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
                let s = response!["stop_schedules"]![0]["date_times"]!![0]["date_time"]!;
                let stopTime = String(s!);
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss"
                let date = dateFormatter.dateFromString( stopTime );
                let minuteRemain = Int(round((date?.timeIntervalSinceNow)!/60));
                if(date != nil){
                    //print(NSDate.minutesFrom(date!));
                    self.stopTimeRemaining.text = String(minuteRemain)+" Minutes";
                }
                
                
                
                
                
                
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
                }
        }
    }
    
    func retreiveLoc()
    {
        print("retreiving location...");
        manager.requestLocation();
    }
    
    // se charge de récupérer la loc
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            refreshLocInfo();
            currentLoc = location.coordinate;
            print("Found user's location: \(currentLoc)")
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

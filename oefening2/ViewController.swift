//
//  ViewController.swift
//  oefening2
//
//  Created by Ionut Alazaroae on 02/06/18.
//  Copyright © 2018 student. All rights reserved.
//  THIS DUDE SHOULD EARN A COOKIE FOR THIS https://www.raywenderlich.com/160517/mapkit-tutorial-getting-started
//  AND THIS ONE TOO https://www.youtube.com/watch?v=avcwSrrITlg

import UIKit
import CoreData
import MapKit
import CoreLocation


class ViewController: UIViewController ,CLLocationManagerDelegate, MKMapViewDelegate{
    //ALL THE UI Outlets
    @IBOutlet weak var myMap: MKMapView!
    @IBOutlet weak var lastRefresh: UILabel!
    //MY own vars
    var locationManager = CLLocationManager()
    let jsonGET = "https://api.jcdecaux.com/vls/v1/stations?contract=Bruxelles-Capitale&apiKey=f572a3443cb9bbd04b60a61919e3796ac3c21b05"
    var VilloStations = [VilloStation]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchResults()
        //Zie werkstuk 1
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.pausesLocationUpdatesAutomatically = true
        // Do any additional setup after loading the view, typically from a nib.
        //SHOW THE RESULTS ON THE MAP
        for VilloStation in VilloStations {
            let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: VilloStation.lag, longitude: VilloStation.lng)
            let annotation: MapAnnotation = MapAnnotation(coordinate: coordinate, title: VilloStation.name!, subtitle: VilloStation.status!)
            self.myMap.addAnnotation(annotation)
        }
    }
    
    //Werkstuk 1 code
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01,0.01)
        
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        myMap.setRegion(region, animated: true)
        self.myMap.showsUserLocation = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func refreshVilloStations(_ sender: UIButton) {
        fetchResults();
        let date = Date()
        let calendar = Calendar.current
        lastRefresh.text = "\(calendar.component(.hour, from: date)):\(calendar.component(.minute, from: date)):\(calendar.component(.second, from: date))"
    }
    func fetchResults(){
        
        let date = Date()
        let calendar = Calendar.current
        lastRefresh.text = "\(calendar.component(.hour, from: date)):\(calendar.component(.minute, from: date)):\(calendar.component(.second, from: date))"
        
        let appDel = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDel.persistentContainer.viewContext
        
        let reqJSON = NSFetchRequest<NSFetchRequestResult>(entityName: "VilloStation")
        
        reqJSON.returnsObjectsAsFaults = false
        
        let responses = try! managedContext.fetch(reqJSON)
        if responses.count > 0{
            
            
            for response in responses as! [VilloStation]
            {
                VilloStations.append(response)
                
            }
            
        }
        else{
            let url = URL(string: jsonGET)
            let urlreq = URLRequest(url: url!)
            let session = URLSession(configuration: URLSessionConfiguration.default)
            DispatchQueue.main.async {
                
                let task = session.dataTask(with: urlreq){ (data,response,error) in
                    guard error == nil else {
                        print("There is no JSON Data to return")
                        print(error!)
                        // create the alert
                        let alert = UIAlertController(title: "No data", message: "Check your internet connection and try again", preferredStyle: UIAlertControllerStyle.alert)
                        
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    guard let responseData = data
                        else{
                            
                            // create the alert
                            let alert = UIAlertController(title: "No data", message: "The data may be empty, check the app developpers", preferredStyle: UIAlertControllerStyle.alert)
                            
                            // add an action (button)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            
                            // show the alert
                            self.present(alert, animated: true, completion: nil);                            return
                    }
                    let json = try! JSONSerialization.jsonObject(with: responseData, options: []) as? NSArray
                    for obj in json!
                    {
                        
                        if let objDict = obj as? NSDictionary
                        {
                            //Indian Youtube dude
                            let obj = NSEntityDescription.insertNewObject(forEntityName: "VilloStation", into: managedContext) as! VilloStation
                            let objName = objDict.value(forKey: "name") as? String
                            let objNumber = objDict.value(forKey: "number")  as! Int32
                            let objAddress = objDict.value(forKey: "address")  as? String
                            let objPosition = objDict.value(forKey:"position") as! NSDictionary
                            let objLag = objPosition.value(forKey:"lat") as! Double
                            let objLng = objPosition.value(forKey: "lng")  as! Double
                            let objBanking = objDict.value(forKey: "banking")  as! Bool
                            let objBonus = objDict.value(forKey: "bonus")  as! Bool
                            let objStatus = objDict.value(forKey: "status")  as? String
                            let objContractName = objDict.value(forKey: "contract_name")  as? String
                            let objBikeStands = objDict.value(forKey: "bike_stands")  as! Int32
                            let objAvailBikeStands = objDict.value(forKey: "available_bike_stands")  as! Int32
                            let objAvailBikes = objDict.value(forKey: "available_bikes")  as! Int32
                            let objLastUpdate = objDict.value(forKey: "last_update")  as! Int64
                            obj.name = objName
                            obj.number = objNumber
                            obj.address = objAddress
                            obj.lag = objLag
                            obj.lng = objLng
                            obj.banking = objBanking
                            obj.bonus = objBonus
                            obj.status = objStatus
                            obj.contract_name = objContractName
                            obj.bike_stands = objBikeStands
                            obj.available_bike_stands = objAvailBikeStands
                            obj.available_bikes = objAvailBikes
                            obj.last_update = objLastUpdate

                            
                            do {
                                print("Station loaded : \(obj.name)")
                                try managedContext.save()
                            }
                            catch
                            {
                                fatalError("Failure to save context: \(error)")
                            }
                            
                        }
                    }
                }
                task.resume()
            }
        }
    }
   
            
            



    }





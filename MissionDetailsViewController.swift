//
//  MissionDetailsViewController.swift
//  Bucket List
//
//  Created by Howard Jiang on 5/10/16.
//  Copyright © 2016 Howard Jiang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MissionDetailsViewController: UITableViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    var manager: CLLocationManager?
    var missionToEdit: Mission?
    var missionToEditIndexPath: Int?
    var arrayOfCLCircularRegions: [CLCircularRegion] = []
    
    @IBOutlet weak var theMapView: MKMapView!
    weak var cancelButtonDelegate: CancelButtonDelegate?
    weak var delegate: MissionDetailsViewControllerDelegate?
    
    @IBOutlet weak var newMissionTextField: UITextField!
    
    override func viewDidLoad() {
//        print(missionToEdit)
        let currRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude:37.3772410, longitude: -121.9119810), radius: 200, identifier: "Dojo")
        let regionThatIsMySecondRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 35.6984, longitude: 139.7731), radius: 2000, identifier:"Tokyo")
        let regionThatIsMyThirdRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: -25.2637400, longitude: -57.5759260), radius: 2000, identifier:"Asuncion")
        let regionThatIsMyFourthRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 51.5034070, longitude: -0.1275920), radius: 2000, identifier:"DowningSt")
        let regionThatIsMyFifthRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: -19.0154380, longitude: 29.1548570), radius: 2000, identifier:"Zimbabwe")
        manager = CLLocationManager()
        manager?.delegate = self;
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.requestAlwaysAuthorization()
        manager?.startUpdatingLocation()
        arrayOfCLCircularRegions.append(currRegion)
        arrayOfCLCircularRegions.append(regionThatIsMySecondRegion)
        arrayOfCLCircularRegions.append(regionThatIsMyThirdRegion)
        arrayOfCLCircularRegions.append(regionThatIsMyFourthRegion)
        arrayOfCLCircularRegions.append(regionThatIsMyFifthRegion)
        if (missionToEdit != nil) {
            newMissionTextField.text = missionToEdit?.details
        }
        for i in 0...arrayOfCLCircularRegions.count-1 {
            manager?.startMonitoringForRegion(arrayOfCLCircularRegions[i])
        }
    }
    
    @IBAction func cancelBarButtonPressed(sender: UIBarButtonItem) {
        cancelButtonDelegate?.cancelButtonPressedFrom(self)
    }
    
    @IBAction func doneBarButtonPressed(sender: UIBarButtonItem) {
        print("infunction")

        if let mission = missionToEdit {
            mission.details = newMissionTextField.text!
            let alert = UIAlertController(title: "Address", message: "Is this correct?", preferredStyle: .Alert)
            
            let firstAction = UIAlertAction(title: "Yes", style: .Default){(Alert:UIAlertAction!)
                -> Void in NSLog("You pressed button one")
                self.delegate?.missionDetailsViewController(self, didFinishEditingMission: mission, atIndexPath: self.missionToEditIndexPath!)
                
            }
            
            let secondAction = UIAlertAction(title: "Cancel", style: .Default){(alert:UIAlertAction!)
                -> Void in NSLog("You pressed button one")
            }
            alert.addAction(firstAction)
            alert.addAction(secondAction)
            presentViewController(alert, animated: true, completion: nil)
            
    
        }else {
            print("add")
            let mission = newMissionTextField.text!
            print("add")
            
            let alert = UIAlertController(title: "Address", message: "Is this correct?", preferredStyle: .Alert)
            
            let firstAction = UIAlertAction(title: "Yes", style: .Default){(Alert:UIAlertAction!)
                -> Void in NSLog("You pressed button one")
                
                self.delegate?.missionDetailsViewController(self, didFinishAddingMission: mission)
            }
            
            let secondAction = UIAlertAction(title: "Cancel", style: .Default){(alert:UIAlertAction!)
                -> Void in NSLog("You pressed button one")
            }
            alert.addAction(firstAction)
            alert.addAction(secondAction)
            presentViewController(alert, animated: true, completion: nil)
        
            
        }
     }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations:[CLLocation]){
        print("geo")
        manager.stopUpdatingLocation()
        let location = locations[0] as CLLocation
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: {(
            data, error) -> Void in
            let placeMarks = data! as [CLPlacemark]
            let loc: CLPlacemark = placeMarks[0]
            self.theMapView.centerCoordinate = location.coordinate
            let addr = loc.locality
            //                self.address.text = addr
            let reg = MKCoordinateRegionMakeWithDistance(location.coordinate, 1500, 1500)
            self.theMapView.setRegion(reg, animated:true)
            self.theMapView.showsUserLocation = true
        })
        
        //            delegate?.missionDetailsViewController(self, didFinishAddingMission: newMissionTextField.text!)
        print("two")
    }
    
    
        func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion){
            print("should be entering \(region.identifier)")
            NSLog("Entering region")
            enterAlert(region.identifier)
        }
        
        func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
            exitAlert(region.identifier)
            print("should be exiting \(region.identifier) ")
            NSLog("Exiting region")

        }
        
        func enterAlert(identifier: String){
            let alert = UIAlertController(title: "Hotspot!", message: "Hmmmm. You are near \(identifier)", preferredStyle: .Alert)
            let action=UIAlertAction(title:"ok", style: .Default){ (alert:UIAlertAction!) -> Void in
                NSLog("Entering the hotspot")
                //keep status to on
            }
            let actionTwo = UIAlertAction(title:"don't remind me", style: .Default){(alert: UIAlertAction!) -> Void in
                NSLog("Entering the hotspot")
                //turn status to off
            }
            alert.addAction(action)
            alert.addAction(actionTwo)
            presentViewController(alert, animated: true, completion: nil)
        }
        func exitAlert(identifier: String){
            let alert = UIAlertController(title: "Leaving!", message: "Hmmmm. You are getting far from \(identifier)", preferredStyle: .Alert)
            let action=UIAlertAction(title:"ok", style: .Default){ (alert:UIAlertAction!) -> Void in
                NSLog("Exiting the hotspot")
                //keep status to on
            }
            let actionTwo = UIAlertAction(title:"don't remind me", style: .Default){(alert: UIAlertAction!) -> Void in
                NSLog("Entering the hotspot")
                //turn status to off
            }
            alert.addAction(action)
            alert.addAction(actionTwo)
            
            presentViewController(alert, animated: true, completion: nil)
        }
    
    @IBAction func getLocation(sender: AnyObject) {
        print("made it")
//        let available =  CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion)
        manager?.requestWhenInUseAuthorization()
        manager?.startUpdatingLocation()
        print(manager!.location!.coordinate)
    }
}

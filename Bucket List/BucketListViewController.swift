//
//  ViewController.swift
//  Bucket List
//
//  Created by Howard Jiang on 5/10/16.
//  Copyright © 2016 Howard Jiang. All rights reserved.
//

import UIKit
import CoreData

class BucketListViewController: UITableViewController, CancelButtonDelegate, MissionDetailsViewControllerDelegate {
////VARIABLES////
    //Mutable: HardCoded Missions
    var missions = [Mission]()
    //Mutable: Boolean of whether we're editing or not
    var isEdit : Bool = false
    
    //Immutable: managedObjectContext
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

////VIEW DID LOAD////
    override func viewDidLoad() {
        
        //it REALLY loaded :P
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        fetchAllMissions()
    }
    
    func fetchAllMissions(){
        let missionRequest = NSFetchRequest(entityName: "Mission")
        
        do {
            // get the results by executing the fetch request we made earlier
            let results = try managedObjectContext.executeFetchRequest(missionRequest)
            // downcast the results as an array of Mission objects
            missions = results as! [Mission]
            // print the details of each mission
            for mission in missions {
                print("\(mission.details)")
            }
        } catch {
            // print the error if it is caught (Swift automatically saves the error in "error")
            print("\(error)")
        }
    }
    
////PREPARE FOR SEGUE////
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Nav Controller Segue
        let navigationController = segue.destinationViewController as! UINavigationController
        //Nav Controller object
        let controller = navigationController.topViewController as! MissionDetailsViewController
        
        //Set Delegates
        controller.cancelButtonDelegate = self
        controller.delegate = self
        
        if isEdit {
            // Here we set the missionToEdit so that we can have the mission text on the MissionDetailsViewController
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                //mission to edit is the mission at indexPath.row
                controller.missionToEdit = missions[indexPath.row]
                
                //Change stuff
                controller.missionToEditIndexPath = indexPath.row
            }
            isEdit = false
        }
    }
    
////MISSION DETAILS VIEW CONTROLLER////
    func missionDetailsViewController(controller: MissionDetailsViewController, didFinishAddingMission mission: String){
        dismissViewControllerAnimated(true, completion: nil)
//        missions.append(mission)

        let entity = NSEntityDescription.entityForName("Mission", inManagedObjectContext: managedObjectContext)
        //CoreData: Missions
        let mission1 = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        mission1.setValue(mission, forKey: "details")
        
        do {
            //Try to save
            try managedObjectContext.save()
            print("Success")
        } catch {
            //If errors
            print("\(error)")
        }
        fetchAllMissions()
        tableView.reloadData()
    }
    
    func missionDetailsViewController(controller: MissionDetailsViewController, didFinishEditingMission mission: Mission, atIndexPath indexPath: Int) {
        dismissViewControllerAnimated(true, completion: nil)
        
        missions[indexPath] = mission
        
        do {
            //Try to save
            try managedObjectContext.save()
            print("Success")
        } catch {
            //If errors
            print("\(error)")
        }
        fetchAllMissions()
//        managedObjectContext.setValuesForKeysWithDictionary(mission.details)
        
        
        tableView.reloadData()
    }

////CANCEL BUTTON////
    func cancelButtonPressedFrom(controller: UIViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

////DID RECEIVE MEMORY WARNING////
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

////TABLE VIEW FUNCTIONS////
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //Dequeue
        let cell = tableView.dequeueReusableCellWithIdentifier("MissionCell")!
        
        //If cell has text, set to model according to row
        cell.textLabel?.text = missions[indexPath.row].details
        
        //return cell so that the Table View knows what to draw in each row
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missions.count
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //remove the mission at indexPath
        
        managedObjectContext.deleteObject(missions[indexPath.row])
        do {
            //Try to save
            try managedObjectContext.save()
            print("Success")
        } catch {
            //If errors
            print("\(error)")
        }
         missions.removeAtIndex(indexPath.row)
        //reload the table view
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        isEdit = true
        performSegueWithIdentifier("DetailsSegue", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
}


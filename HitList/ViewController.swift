//
//  ViewController.swift
//  HitList
//
//  Created by Xing Hui Lu on 1/21/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {
    /*
        NSManagedObject is a shape-shifter. It can take the form of any entity in your data model, 
        appropriating whatever attributes and relationships you defined.
    */
    
    var people = [NSManagedObject]()
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - IBActions
    @IBAction func addName(sender: AnyObject) {
        let alert = UIAlertController(title: "New Name",
            message: "Add a new name",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
            style: .Default) { (action: UIAlertAction) -> Void in
                let textField = alert.textFields!.first
                self.saveName(textField!.text!)
                self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
            Setting a title and registering the UITableViewCell class with the table view
        */
        
        title = "\"The List\""
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        /*
            Required, else the table will show an empty list
        */
        
        /*
            1. Before you can do anything with Core Data, you need a managed object context
        */
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        /*
            2.
            Setting a fetch request’s entity property, or alternatively initializing it with init(entityName:),
            fetches all objects of a particular entity
        */
        
        let fetchRequest = NSFetchRequest(entityName: "Person")
        
        /*
            3. You hand the fetch request over to the managed object context to do the heavy lifting. 
            executeFetchRequest() returns an array of managed objects that meets the criteria specified by the fetch request.
        */
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            people = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - TV Datasource Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        let person = people[indexPath.row]
        
        /*
            The only way Core Data provides to read the value is key-value coding, commonly referred to as KVC.
            Key-value coding is available to all classes that descend from NSObject
        */
        
        cell?.textLabel?.text = person.valueForKey("name") as? String
        
        return cell!
    }
    
    // MARK: - Helper Methods
    
    func saveName(name: String) {
        /*
            1. Get your hands on an NSManagedObjectContext.
        */
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        /*
            2. 
                - An entity description is the piece that links the entity definition from your data model with an
                instance of NSManagedObject at runtime.
                - Create a new managed object and insert it into the managed object context.
        */
        
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedContext)
        let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        /*
            3. With an NSManagedObject in hand, you set the name attribute using key-value coding.
        */
        
        person.setValue(name, forKey: "name")
        
        /*
            4. You commit your changes to person and save to disk by calling save on the managed object context.
        */
        
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}


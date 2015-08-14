//
//  ViewController.swift
//  HitList
//
//  Created by jeff greenberg on 8/13/15.
//  Copyright © 2015 Jeff Greenberg. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {
    struct Constants {
        static let CoreDataEntityName = "Person"
        static let NameKey = "name"
        
        static let StoredNameQuery = "FetchByName"
        static let StoredNameQueryVariable = "FULL_NAME"
    }
    
    // MARK:- Initialize context
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    lazy var context:NSManagedObjectContext = self.appDelegate.managedObjectContext
    lazy var persons:NSEntityDescription! = NSEntityDescription.entityForName(Constants.CoreDataEntityName, inManagedObjectContext: self.context)
    lazy var model:NSManagedObjectModel! = self.context.persistentStoreCoordinator?.managedObjectModel
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func addName(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action) -> Void in
            let textField = alert.textFields![0] 
            self.saveName(textField.text!)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func saveName(name: String) {
        let person = NSManagedObject(entity: persons, insertIntoManagedObjectContext: context)
        person.setValue(name, forKey: "name")
        
        do {
            try context.save()
        } catch {
            print("Could not save \(error)")
        }
        
        people.append(person)
    }
    
    //var names = [String]()
    var people = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "\"The List\""
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let fetchRequest = NSFetchRequest(entityName: Constants.CoreDataEntityName)
        do {
            let fetchedResults = try context.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults {
                people = results
            }
        } catch {
            print("couldn't fetch: \(error)")
        }
    }

    // MARK: - DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let person = people[indexPath.row]
        
        cell.textLabel!.text = person.valueForKey("name") as? String
        
        return cell
    }
    

}


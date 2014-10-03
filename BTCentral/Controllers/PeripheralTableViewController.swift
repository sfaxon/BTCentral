//
//  PeripheralTableViewController.swift
//  BTCentral
//
//  Created by Seth Faxon on 10/1/14.
//  Copyright (c) 2014 Seth Faxon. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreData

class PeripheralTableViewController: UITableViewController, CBCentralManagerDelegate, NSFetchedResultsControllerDelegate {
    
    var manager: CBCentralManager!
    var fetchedResultsController: NSFetchedResultsController!

    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CBCentralManager(delegate: self, queue: nil)
        manager.scanForPeripheralsWithServices(nil, options: nil)
        loadData()
    }
    
    @IBAction func scan(sender: UIButton) {
        println("starting scan")
        manager.scanForPeripheralsWithServices(nil, options: nil)
    }
    // MARK: - BlueTooth Callbacks
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        println("hello: \(central)")
    }
    
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        println("periferal: \(peripheral)");
        insertPeripheral(peripheral)
        
        peripheral.discoverServices(nil);
    }
    
    func centralManager(central: CBCentralManager!, didRetrieveConnectedPeripherals peripherals: [AnyObject]!) {
        println("retrieve: \(peripherals)")
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController.sections![section].numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var  cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        var peripheral = self.fetchedResultsController.objectAtIndexPath(indexPath) as Peripheral
        cell.textLabel?.text = peripheral.identifier
        if (peripheral.name? != nil) {
            cell.detailTextLabel?.text = peripheral.name
        }
        else {
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }
    
    // MARK: CoreData management
    func loadData() {
        println("loaded...")
        
        NSLog("Loading Peripherals")
        
        var error: NSError? = nil
        var fReq: NSFetchRequest = NSFetchRequest(entityName: "Peripheral")
        
        var sorter: NSSortDescriptor = NSSortDescriptor(key: "identifier" , ascending: false)
        fReq.sortDescriptors = [sorter]
        
        fReq.returnsObjectsAsFaults = false
        
        var result = self.cdh.managedObjectContext!.executeFetchRequest(fReq, error:&error)
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fReq,
            managedObjectContext: self.cdh.managedObjectContext!,
            sectionNameKeyPath: nil,
            cacheName: nil)
        self.fetchedResultsController.delegate = self
        
        if !self.fetchedResultsController!.performFetch(&error) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            println("Unresolved error \(error), \(error?.userInfo)")
            abort()
        }
        self.tableView.reloadData()
    }
    
    func insertPeripheral(peripheral: CBPeripheral) {
        // add Peripherals
        println("Inserting Peripheral")

        var newItem = NSEntityDescription.insertNewObjectForEntityForName("Peripheral", inManagedObjectContext: self.cdh.backgroundContext!) as Peripheral

        newItem.identifier = peripheral.identifier.UUIDString
        if (peripheral.name != nil) {
            newItem.name = peripheral.name
        }
        println("Inserted New Peripheral for \(newItem.identifier)")

        self.cdh.saveContext(self.cdh.backgroundContext!)
        self.tableView.reloadData()
    }
    
    lazy var cdh: CoreDataHelper = {
        let cdh = CoreDataHelper()
        return cdh
        }()
    


    /*
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    

}

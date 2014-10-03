//
//  Peripheral.swift
//  BTCentral
//
//  Created by Seth Faxon on 10/1/14.
//  Copyright (c) 2014 Seth Faxon. All rights reserved.
//

import Foundation
import CoreData

@objc(Peripheral)

class Peripheral: NSManagedObject {
    @NSManaged var identifier: String
    @NSManaged var name: String?
}

//import Foundation
//import CoreData
//
//@objc(Family)
//class Family: NSManagedObject {
//    
//    @NSManaged var address: String
//    @NSManaged var name: String
//    @NSManaged var members: NSSet
//    
//}

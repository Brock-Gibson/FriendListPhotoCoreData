//
//  Friend+CoreDataProperties.swift
//  PhotosCoreData
//
//  Created by Brock Gibson on 3/18/19.
//  Copyright © 2019 Brock Gibson. All rights reserved.
//
//

import Foundation
import CoreData


extension Friend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Friend> {
        return NSFetchRequest<Friend>(entityName: "Friend")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var rawImage: NSData?
    @NSManaged public var lastName: String?
    @NSManaged public var contactInfo: String?

}

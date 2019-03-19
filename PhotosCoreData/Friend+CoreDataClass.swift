//
//  Friend+CoreDataClass.swift
//  PhotosCoreData
//
//  Created by Brock Gibson on 3/18/19.
//  Copyright © 2019 Brock Gibson. All rights reserved.
//
//

import Foundation
import UIKit
import CoreData

@objc(Friend)
public class Friend: NSManagedObject {
    
    var image: UIImage? {
        get {
            if let imageData = rawImage as Data? {
                return UIImage(data: imageData)
            }
            return nil
        }
        set {
            let imageData = newValue!.pngData() as NSData?
            rawImage = imageData
        }
    }
    
    convenience init?(firstName: String?, lastName: String?, contactInfo: String?, image: UIImage?) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {
            return nil
        }
        
        self.init(entity: Friend.entity(), insertInto: managedContext)
        
        self.firstName = firstName
        self.lastName = lastName
        self.contactInfo = contactInfo
        self.image = image
    }
}

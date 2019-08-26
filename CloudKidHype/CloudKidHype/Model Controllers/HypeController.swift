//
//  HypeController.swift
//  CloudKidHype
//
//  Created by Jackson Tubbs on 8/26/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation
import CloudKit

class HypeController {
    
    // Shared Instance
    static let shared = HypeController()
    
    var hypes: [Hype] = []
    let publicDB = CKContainer(identifier: "iCloud.Decknot.CloudKidHype").publicCloudDatabase
    
    // MARK: - Crud
    
    func saveHype(text: String, completion: @escaping (Bool) -> Void) {
        let hype = Hype(text: text)
        let hypeRecord = CKRecord(hype: hype)
        publicDB.save(hypeRecord) { (_, error) in
            if let error = error {
                print("Big Error \(error)")
                completion(false)
                return
            }
            self.hypes.append(hype)
            completion(true)
        }
    }
    
    func fetchHypes(completion: @escaping (Bool) -> Void) {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Constants.recordTypeKey, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Big Error \(error)")
                completion(false)
                return
            }
            guard let records = records else {completion(false); return}
            
            let hypes = records.compactMap({Hype(ckRecord: $0)})
            self.hypes = hypes
            completion(true)
        }
    }
    
    
}

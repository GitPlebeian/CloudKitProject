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
        hypes.insert(hype, at: 0)
        publicDB.save(hypeRecord) { (_, error) in
            if let error = error {
                print("Big Error \(error)")
                completion(false)
                return
            }
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
    
    func removeHype(_ hype: Hype, completion: @escaping (Bool) -> Void) {
        guard let hypeRecordID = hype.ckRecordID, let firstIndex = self.hypes.firstIndex(of: hype) else {return}
        
        hypes.remove(at: firstIndex)
        
        publicDB.delete(withRecordID: hypeRecordID) { (_, error) in
            if let error = error {
                print("Error at: \(#function) Error: \(error)\nLocalized Error: \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    func updateHype(hype: Hype, with text: String, completion: @escaping (Bool) -> Void) {
        
        hype.text = text
        hype.timestamp = Date()
        
        // Updates hype
        let modificationOP = CKModifyRecordsOperation(recordsToSave: [CKRecord(hype: hype)], recordIDsToDelete: nil)
        modificationOP.savePolicy = .changedKeys
        modificationOP.queuePriority = .veryHigh
        modificationOP.qualityOfService = .userInteractive
        
        modificationOP.modifyRecordsCompletionBlock = { (_, _, error) in
            if let error = error {
                print("Error at: \(#function) Error: \(error)\nLocalized Error: \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
        }
        
        publicDB.add(modificationOP)
    }
}

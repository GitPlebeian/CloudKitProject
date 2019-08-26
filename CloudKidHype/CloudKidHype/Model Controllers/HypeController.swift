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
    
//    func loadHypes() {
//        
//        publicDB.fetch(withRecordID: <#T##CKRecord.ID#>, completionHandler: <#T##(CKRecord?, Error?) -> Void#>)
//    }
    
    
}

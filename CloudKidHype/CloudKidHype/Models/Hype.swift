//
//  Hype.swift
//  CloudKidHype
//
//  Created by Jackson Tubbs on 8/26/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation
import CloudKit

struct Constants {
    static let recordTypeKey = "hype"
    static let recordTextKey = "Text"
    static let recordTimestampKey = "Timestamp"
}


class Hype {
    
    let hypeText: String
    let timestamp: Date
    
    init(text: String, timestamp: Date = Date()) {
        self.hypeText = text
        self.timestamp = timestamp
    }
}

//extension Hype {
//    convenience init?(ckRecord)
//}

extension CKRecord {
    // Creates a CKRecord from a hupe
    convenience init(hype: Hype) {
        // Same as (Save) - Upload
        self.init(recordType: Constants.recordTypeKey)
        self.setValue(hype.hypeText, forKey: Constants.recordTextKey)
        self.setValue(hype.timestamp, forKey: Constants.recordTimestampKey)
    }
}

extension Hype {
    // Creating a hype from a record
    // Failable because of network conecctivity issues
    convenience init?(ckRecord: CKRecord) {
        guard let hypeText = ckRecord[Constants.recordTextKey] as? String, let hypeTimestamp = ckRecord[Constants.recordTimestampKey] as? Date else {return nil}
        self.init(text: hypeText, timestamp: hypeTimestamp)
    }
}

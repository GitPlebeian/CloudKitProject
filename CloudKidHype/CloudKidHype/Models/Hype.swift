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
    
    var text: String
    var timestamp: Date
    // Adding on the record ID for update / delete
    var ckRecordID: CKRecord.ID?
    
    init(text: String, timestamp: Date = Date()) {
        self.text = text
        self.timestamp = timestamp
    }
}

extension CKRecord {
    // Creates a CKRecord from a hupe
    convenience init(hype: Hype) {
        // Same as (Save) - Upload
        let recordID = hype.ckRecordID ?? CKRecord.ID(recordName: UUID().uuidString)
        self.init(recordType: Constants.recordTypeKey, recordID: recordID)
        self.setValue(hype.text, forKey: Constants.recordTextKey)
        self.setValue(hype.timestamp, forKey: Constants.recordTimestampKey)
        hype.ckRecordID = recordID
    }
}

extension Hype {
    // Creating a hype from a record
    // Failable because of network conecctivity issues
    convenience init?(ckRecord: CKRecord) {
        guard let hypeText = ckRecord[Constants.recordTextKey] as? String, let hypeTimestamp = ckRecord[Constants.recordTimestampKey] as? Date else {return nil}
        self.init(text: hypeText, timestamp: hypeTimestamp)
        // Used to update and delete records
        ckRecordID = ckRecord.recordID
    }
}

extension Hype: Equatable {
    static func ==(lhs: Hype, rhs: Hype) -> Bool {
        return lhs.text == rhs.text &&
        lhs.timestamp == rhs.timestamp &&
        lhs.ckRecordID == rhs.ckRecordID
    }
}

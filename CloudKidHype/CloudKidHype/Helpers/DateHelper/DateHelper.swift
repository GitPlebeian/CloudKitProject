//
//  DateHelper.swift
//  CloudKidHype
//
//  Created by Jackson Tubbs on 8/27/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation

class DateHelper {
    
    static let shared = DateHelper()
    
    private init () {}
    
    let dateFormatter = DateFormatter()
    
    func stringForDate(date: Date) -> String {
        dateFormatter.dateFormat = "M dd yyyy"
        return dateFormatter.string(from: date)
    }
}

//
//  ExpiryDate.swift
//  
//
//  Created by Daven.Gomes on 03/11/2021.
//

import Foundation

/// ExpiryDate struct representing month and year as Int for the expiry date field.
public struct ExpiryDate: Equatable {
    public let month: Int
    public let year: Int
    
    public init(month: Int, year: Int) {
        self.month = month
        self.year = year
    }
}

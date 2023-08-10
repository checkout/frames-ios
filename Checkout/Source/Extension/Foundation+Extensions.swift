//
//  Foundation+Extensions.swift
//  
//
//  Created by Daven.Gomes on 04/11/2021.
//

import Foundation

extension Calendar: CalendarProtocol {
    func current() -> Date {
        Date()
    }
}

extension JSONEncoder: Encoding { }
extension JSONDecoder: Decoding { }

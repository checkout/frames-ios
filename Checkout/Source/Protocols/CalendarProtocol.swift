//
//  CalendarProtocol.swift
//  
//
//  Created by Daven.Gomes on 04/11/2021.
//

import Foundation

protocol CalendarProtocol: DateProviding {
  func date(from components: DateComponents) -> Date?
  func date(byAdding component: Calendar.Component, value: Int, to date: Date, wrappingComponents: Bool) -> Date?
  func component(_ component: Calendar.Component, from date: Date) -> Int
}

extension CalendarProtocol {
  func date(byAdding component: Calendar.Component, value: Int, to date: Date) -> Date? {
    return self.date(byAdding: component, value: value, to: date, wrappingComponents: false)
  }
}

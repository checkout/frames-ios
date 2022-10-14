//
//  StubCalendar.swift
//  
//
//  Created by Daven.Gomes on 04/11/2021.
//

import Foundation
@testable import Checkout

final class StubCalendar: CalendarProtocol {
  var dateFromComponentsToReturn: Date?
  private(set) var dateFromComponentsCalledWith: DateComponents?

  func date(from components: DateComponents) -> Date? {
    dateFromComponentsCalledWith = components
    return dateFromComponentsToReturn
  }

  var dateByAddingOverride = true
  var dateByAddingToReturn: Date?
  // swiftlint:disable:next large_tuple
  private(set) var dateByAddingCalledWith: (
    component: Calendar.Component,
    value: Int,
    date: Date,
    wrappingComponents: Bool
  )?
  func date(byAdding component: Calendar.Component, value: Int, to date: Date, wrappingComponents: Bool) -> Date? {
    dateByAddingCalledWith = (component, value, date, wrappingComponents)

    switch dateByAddingOverride {
    case true:
      return Calendar(identifier: .gregorian).date(
        byAdding: component,
        value: value,
        to: date,
        wrappingComponents: wrappingComponents
      )
    case false:
      return dateByAddingToReturn
    }
  }
  
  func component(_ component: Calendar.Component, from date: Date) -> Int {
    Calendar(identifier: .gregorian).component(component, from: date)
  }
}

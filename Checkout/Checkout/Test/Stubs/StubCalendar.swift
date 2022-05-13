//
//  StubCalendar.swift
//  
//
//  Created by Daven.Gomes on 04/11/2021.
//

import Foundation
@testable import Checkout

final class StubCalendar: CalendarProtocol {
  var dateToReturn: Date?
  private(set) var dateCalledWith: DateComponents?

  func date(from components: DateComponents) -> Date? {
    dateCalledWith = components
    return dateToReturn
  }
}

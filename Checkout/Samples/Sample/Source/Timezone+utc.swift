//
//  Timezone+utc.swift
//
//
//  Created by Harry Brown on 15/02/2022.
//

import Foundation

extension TimeZone {
  // swiftlint:disable force_unwrapping
  static var utc = TimeZone(identifier: "UTC")!
}

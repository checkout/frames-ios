//
//  NSRegularExpression+initStaticPattern.swift
//
//
//  Created by Harry Brown on 21/10/2021.
//

import Foundation

extension NSRegularExpression {
  convenience init(staticPattern: StaticString, options: Options = []) {
    // swiftlint:disable force_try
    try! self.init(pattern: "\(staticPattern)", options: options)
  }
}

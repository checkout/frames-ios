//
//  Stateful.swift
//  Frames
//
//  Created by Harry Brown on 13/07/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import Foundation

protocol Stateful {
  associatedtype StateUpdate

  func update(state: StateUpdate)
}

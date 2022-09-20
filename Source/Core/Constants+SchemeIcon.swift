//
//  Constants+SchemeIcon.swift
//  Frames
//
//  Created by Harry Brown on 13/07/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import Checkout
import UIKit

extension Constants.Bundle {

  enum Images: String, CaseIterable {
    case warning = "warning"
    case leftArrow = "left_arrow"
    case rightArrow = "arrow_blue_right"
    case keyboardPrevious = "keyboard-previous"
    case keyboardNext = "keyboard-next"

    var image: UIImage? {
      rawValue.image()
    }
  }

  enum SchemeIcon: String, CaseIterable {
    case blank = "icon-blank"
    case americanExpress = "icon-amex"
    case dinersClub = "icon-diners"
    case discover = "icon-discover"
    case jcb = "icon-jcb"
    case maestro = "icon-maestro"
    case mastercard = "icon-mastercard"
    case mada = "icon-mada"
    case visa = "icon-visa"

    init(scheme: Card.Scheme) {
      switch scheme {
      case .americanExpress:
        self = .americanExpress
      case .dinersClub:
        self = .dinersClub
      case .discover:
        self = .discover
      case .jcb:
        self = .jcb
      case .maestro:
        self = .maestro
      case .mastercard:
        self = .mastercard
      case .visa:
        self = .visa
      case .mada:
        self = .mada
      case .unknown:
        self = .blank
      }
    }

    var image: UIImage? {
      rawValue.image()
    }
  }
}

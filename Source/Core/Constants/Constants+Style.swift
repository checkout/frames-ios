//
//  Constants+Style.swift
//  Frames
//
//  Copyright © 2022 Checkout. All rights reserved.
//

import Foundation

// swiftlint:disable file_length
extension Constants {

    enum Style {

      static let animationLength: TimeInterval = 0.25

        enum PaymentForm {

          enum Header: Double {
            case subtitleFontSize = 13
          }
            enum InputBillingFormButton: Double {
                case height = 56
                case width = 0
                case fontSize = 15
                case cornerRadius = 10
                case borderWidth = 1
                case textLeading = 20
            }
            enum PayButton: Double {
              case fontSize = 15
            }
        }

        enum BillingForm {

            enum CancelButton: Double {
                case height = 44
                case width = 80
                case fontSize = 17
            }

            enum DoneButton: Double {
                case height = 44
                case width = 70
                case fontSize = 17
            }

            enum HeaderTitle: Double {
                case fontSize = 24
            }

            enum InputErrorLabel: Double {
                case height = 30
                case fontSize = 13
            }

            enum InputHintLabel: Double {
                case fontSize = 13
            }

            enum InputTextField: Double {
                case height = 56
                case width = 335.0
                case fontSize = 16
            }

            enum InputTitleLabel: Double {
                case fontSize = 15
            }

            enum InputOptionalLabel: Double {
                case fontSize = 13
            }

            enum InputCountryButton: Double {
                case height = 56
                case width = 0
                case fontSize = 15
                case cornerRadius = 10
                case borderWidth = 1
                case textLeading = 20
            }

        }
    }
}

//
//  Constants+Style.swift
//  Frames
//
//  Copyright © 2022 Checkout. All rights reserved.
//

import Foundation

extension Constants {

    enum Style {

      static let animationLength: TimeInterval = 0.25

        enum BorderStyle {
            static let cornerRadius: Double = 10
            static let borderWidth: Double = 1
        }

        enum PaymentForm {

          enum Header: Double {
            case subtitleFontSize = 13
          }
            enum InputBillingFormButton: Double {
                case height = 56
                case width = 0
                case textLeading = 20
            }

        }

        enum BillingForm {

            enum CancelButton: Double {
                case height = 44
                case width = 80
            }

            enum DoneButton: Double {
                case height = 44
                case width = 70
            }

            enum InputErrorLabel: Double {
                case height = 30
            }

            enum InputTextField: Double {
                case height = 56
                case width = 335.0
            }

            enum InputCountryButton: Double {
                case height = 56
                case width = 0
                case textLeading = 20
            }

        }
    }
}

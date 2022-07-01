//
//  Constants+Style.swift
//  Frames
//
//  Copyright © 2022 Checkout. All rights reserved.
//

extension Constants {

    enum Style {

        enum PaymentForm {
            enum InputBillingFormButton: Double {
                case height = 56
                case width = 0
                case fontSize = 15
                case cornerRadius = 10
                case borderWidth = 1
                case textLeading = 20
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
                case height = 18
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

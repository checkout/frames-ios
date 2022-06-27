extension Constants {

    @frozen enum Style {

        @frozen enum PaymentForm {
            @frozen enum InputBillingFormButton: Double {
                case height = 56
                case width = 0
                case fontSize = 15
                case cornerRadius = 10
                case borderWidth = 1
                case textLeading = 20
            }
        }

        @frozen enum BillingForm {

            @frozen enum CancelButton: Double {
                case height = 44
                case width = 80
                case fontSize = 17
            }

            @frozen enum DoneButton: Double {
                case height = 44
                case width = 70
                case fontSize = 17
            }

            @frozen enum HeaderTitle: Double {
                case fontSize = 24
            }

            @frozen enum InputErrorLabel: Double {
                case height = 18
                case fontSize = 13
            }

            @frozen enum InputHintLabel: Double {
                case fontSize = 13
            }

            @frozen enum InputTextField: Double {
                case height = 56
                case width = 335.0
                case fontSize = 16
            }

            @frozen enum InputTitleLabel: Double {
                case fontSize = 15
            }

            @frozen enum InputOptionalLabel: Double {
                case fontSize = 13
            }

            @frozen enum InputCountryButton: Double {
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

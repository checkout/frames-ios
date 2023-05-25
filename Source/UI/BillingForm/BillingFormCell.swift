import Foundation

@frozen public enum BillingFormCell {

    case fullName(CellTextFieldStyle?)
    case addressLine1(CellTextFieldStyle?)
    case addressLine2(CellTextFieldStyle?)
    case city(CellTextFieldStyle?)
    case state(CellTextFieldStyle?)
    case postcode(CellTextFieldStyle?)
    case country(CellButtonStyle?)
    case phoneNumber(CellTextFieldStyle?)

    internal var validator: Validator {
        switch self {
        case .fullName,
                .addressLine1,
                .addressLine2,
                .city,
                .state,
                .postcode,
                .country:
            return GenericInputValidator()
        case .phoneNumber: return PhoneNumberValidator.shared
        }
    }

    internal var style: CellStyle? {
        switch self {
        case .fullName(let style): return style
        case .addressLine1(let style): return style
        case .addressLine2(let style): return style
        case .city(let style): return style
        case .state(let style): return style
        case .postcode(let style): return style
        case .country(let style): return style
        case .phoneNumber(let style): return style
        }
    }

    var index: Int {
        switch self {
        case .fullName: return 0
        case .addressLine1: return 1
        case .addressLine2: return 2
        case .city: return 3
        case .state: return 4
        case .postcode: return 5
        case .country: return 6
        case .phoneNumber: return 7
        }
    }

    var accessibilityIdentifier: String {
        typealias Identifier = AccessibilityIdentifiers.BillingForm
        switch self {
        case .fullName: return Identifier.cardholder
        case .addressLine1: return Identifier.addressLine1
        case .addressLine2: return Identifier.addressLine2
        case .city: return Identifier.city
        case .state: return Identifier.state
        case .postcode: return Identifier.postcode
        // Country does not require an accessibility identifier as it is detected
        // differently by UITests, using its label
        case .country: return ""
        case .phoneNumber: return Identifier.phoneNumber
        }
    }

    func getText(from billingFormData: BillingForm?) -> String? {
        switch self {
            case .fullName: return billingFormData?.name
            case .addressLine1: return billingFormData?.address?.addressLine1
            case .addressLine2: return billingFormData?.address?.addressLine2
            case .city: return billingFormData?.address?.city
            case .state: return billingFormData?.address?.state
            case .postcode: return billingFormData?.address?.zip
            case .country: return billingFormData?.address?.country?.name
            case .phoneNumber: return billingFormData?.phone?.displayFormatted()
        }
    }
}

extension BillingFormCell: Equatable {
    public static func == (lhs: BillingFormCell, rhs: BillingFormCell) -> Bool {
        lhs.index == rhs.index
    }
}

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
        case .fullName: return FullNameValidator()
        case .addressLine1: return AddressLine1Validator()
        case .addressLine2: return AddressLine2Validator()
        case .city: return CityValidator()
        case .state: return StateValidator()
        case .postcode: return PostcodeValidator()
        case .country: return CountryValidator()
        case .phoneNumber: return PhoneNumberValidator()
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

    func getText(from billingFormData: BillingForm?) -> String? {
        switch self {
            case .fullName: return billingFormData?.name
            case .addressLine1: return billingFormData?.address?.addressLine1
            case .addressLine2: return billingFormData?.address?.addressLine2
            case .city: return billingFormData?.address?.city
            case .state: return billingFormData?.address?.state
            case .postcode: return billingFormData?.address?.zip
            case .country: return billingFormData?.address?.country?.name
            case .phoneNumber:
                let dialingCode = billingFormData?.phone?.country?.dialingCode ?? ""
                let number = billingFormData?.phone?.number ?? ""
                return "+\(String(dialingCode)) \(String(number))"
        }
    }
}

extension BillingFormCell: Equatable {
    public static func == (lhs: BillingFormCell, rhs: BillingFormCell) -> Bool {
        lhs.index == rhs.index
    }
}

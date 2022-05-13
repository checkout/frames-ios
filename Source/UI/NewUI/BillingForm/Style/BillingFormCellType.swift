import Foundation

@frozen public enum BillingFormCell {
    case fullName(BillingFormTextFieldCellStyle?)
    case addressLine1(BillingFormTextFieldCellStyle?)
    case addressLine2(BillingFormTextFieldCellStyle?)
    case city(BillingFormTextFieldCellStyle?)
    case state(BillingFormTextFieldCellStyle?)
    case postcode(BillingFormTextFieldCellStyle?)
    case country(BillingFormTextFieldCellStyle?)
    case phoneNumber(BillingFormTextFieldCellStyle?)
    
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
    
    internal var style: BillingFormTextFieldCellStyle? {
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
    
    var hash: Int {
        switch self {
        case .fullName:  return 1
        case .addressLine1:  return 2
        case .addressLine2:  return 3
        case .city:  return 4
        case .state:  return 5
        case .postcode:  return 6
        case .country:  return 7
        case .phoneNumber:  return 8
        }
    }
}

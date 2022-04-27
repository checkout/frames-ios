import Foundation

@frozen enum BillingFormCellType: Int, CaseIterable {
    case fullName = 1
    case addressLine1 = 2
    case addressLine2 = 3
    case city = 4
    case state = 5
    case postcode = 6
    case country = 7
    case phoneNumber = 8
    
    var validator: Validator {
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
}

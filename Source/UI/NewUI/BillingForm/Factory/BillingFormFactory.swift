import UIKit

struct BillingFormFactory {
    // in order
    static let cellsStyleInOrder: [BillingFormCell] = [
        .fullName(DefaultBillingFormFullNameCellStyle()),
        .addressLine1(DefaultBillingFormAddressLine1CellStyle()),
        .addressLine2(DefaultBillingFormAddressLine2CellStyle()),
        .city(DefaultBillingFormCityCellStyle()),
        .state(DefaultBillingFormStateCellStyle()),
        .postcode(DefaultBillingFormPostcodeCellStyle()),
        .country(DefaultBillingFormCountryCellStyle()),
        .phoneNumber(DefaultBillingFormPhoneNumberCellStyle())
    ]

    // TODO: inject BillingFormStyle
    static func getBillingFormViewController(delegate: BillingFormViewModelDelegate) -> (BillingFormViewModelDelegate?, UIViewController?) {
        UIFont.loadAllCheckoutFonts
        let style = DefaultBillingFormStyle()
        guard !style.cells.isEmpty else { return (nil, nil) }
        
        let viewModel = DefaultBillingFormViewModel(style: style, initialCountry: "", delegate: delegate)
        return (viewModel.delegate, BillingFormViewController(viewModel: viewModel))
    }
    
}

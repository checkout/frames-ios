import UIKit

public struct BillingFormFactory {

    public static var defaultBillingFormStyle: BillingFormStyle {
        DefaultBillingFormStyle()
    }

    // in order
    static var cellsStyleInOrder: [BillingFormCell] {
        [.fullName(DefaultBillingFormFullNameCellStyle()),
         .addressLine1(DefaultBillingFormAddressLine1CellStyle()),
         .addressLine2(DefaultBillingFormAddressLine2CellStyle()),
         .city(DefaultBillingFormCityCellStyle()),
         .state(DefaultBillingFormStateCellStyle()),
         .postcode(DefaultBillingFormPostcodeCellStyle()),
         .country(DefaultBillingFormCountryCellStyle()),
         .phoneNumber(DefaultBillingFormPhoneNumberCellStyle())]
    }


    static func getBillingFormViewController(billingFormStyle: BillingFormStyle?, delegate: BillingFormViewModelDelegate) -> (BillingFormViewModelDelegate?, UIViewController?) {
        guard let billingFormStyle = billingFormStyle, !billingFormStyle.cells.isEmpty
        else { return (nil, nil) }
        
        let viewModel = DefaultBillingFormViewModel(style: billingFormStyle, initialCountry: "", delegate: delegate)
        return (viewModel.delegate, BillingFormViewController(viewModel: viewModel))
    }
    
}

import UIKit

struct BillingFormFactory {
    // in order
    static let styles: [BillingFormTextFieldCellStyle] = [
        DefaultFormStyleFullNameCell(),
        DefaultFormStyleAddressLine1Cell(),
        DefaultFormStyleAddressLine2Cell(),
        DefaultFormStyleCityCell(),
        DefaultFormStyleStateCell(),
        DefaultFormStylePostcodeCell(),
        DefaultFormStyleCountryCell(),
        DefaultFormStylePhoneNumberCell()
    ]
    
    static func getBillingFormViewController(delegate: BillingFormViewModelDelegate) -> UIViewController {
        let style = DefaultBillingFormStyle()
        let viewModel = DefaultBillingFormViewModel(style: style, initialCountry: "", delegate: delegate)
        return BillingFormViewController(viewModel: viewModel)
    }
    
}

import UIKit

/// Factory object building required components to start presenting a tokenisation journey to the user
public enum FramesFactory {

    public static var defaultPaymentFormStyle: PaymentFormStyle {
        DefaultPaymentFormStyle()
    }

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

    static func getBillingFormViewController(style: BillingFormStyle?,
                                             data: BillingForm?,
                                             delegate: BillingFormViewModelDelegate?,
                                             sender: UINavigationController?) -> UINavigationController? {

        guard let style = style, !style.cells.isEmpty else { return nil }
        let viewModel = DefaultBillingFormViewModel(style: style, data: data, delegate: delegate)
        let viewController = BillingFormViewController(viewModel: viewModel)
        viewModel.editDelegate = viewController

        if #available(iOS 13.0, *) {
            viewController.isModalInPresentation = true
        }
        let navigationController = UINavigationController(rootViewController: viewController)
        guard let sender = sender else { return navigationController }
        navigationController.copyStyle(from: sender)
        return navigationController
    }

}

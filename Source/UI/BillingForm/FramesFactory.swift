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

    static func getBillingFormViewController(style: BillingFormStyle?, data: BillingForm?, delegate: BillingFormViewModelDelegate?, sender: UINavigationController?) -> UINavigationController? {

        guard let style = style, !style.cells.isEmpty else { return nil }
        let viewModel = DefaultBillingFormViewModel(style: style, data: data, delegate: delegate)
        let viewController = BillingFormViewController(viewModel: viewModel)
        viewModel.editDelegate = viewController

        if #available(iOS 13.0, *) {
            viewController.isModalInPresentation = true
        }
        guard let sender = sender else {
            return UINavigationController(rootViewController: viewController)
        }
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.tintColor = sender.navigationBar.tintColor

        if #available(iOS 13.0, *) {
            navigationController.navigationBar.standardAppearance = sender.navigationBar.standardAppearance
        } else {
            let backgroundColor = sender.navigationBar.backgroundColor
            navigationController.navigationBar.backgroundColor = backgroundColor
            navigationController.navigationBar.barTintColor = backgroundColor
            navigationController.navigationBar.shadowImage = sender.navigationBar.shadowImage
            navigationController.navigationBar.titleTextAttributes = [ .foregroundColor: sender.navigationBar.tintColor ?? .black]
            navigationController.navigationBar.isTranslucent = true
        }

        return navigationController
    }

}

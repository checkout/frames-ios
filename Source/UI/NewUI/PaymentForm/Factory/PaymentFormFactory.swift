import UIKit
import Checkout

public typealias CardScheme = Checkout.Card.Scheme

public struct PaymentFormFactory {
    public static func getPaymentFormViewController(billingFormData: BillingForm?,
                                                    paymentFormStyle: PaymentFormStyle?,
                                                    billingFormStyle: BillingFormStyle?,
                                                    supportedSchemes: [CardScheme] ) -> UIViewController {

      let viewModel = DefaultPaymentViewModel(environment: Environment.live ,
                                              billingFormData: billingFormData,
                                                paymentFormStyle: paymentFormStyle,
                                              billingFormStyle: billingFormStyle,
                                              supportedSchemes: supportedSchemes)
        let viewController =  PaymentViewController(viewModel: viewModel)

        if #available(iOS 13.0, *) {
            viewController.isModalInPresentation  = true
        }
        return viewController
    }

    static func getButton(style: CellButtonStyle, delegate: SelectionButtonViewDelegate?) -> UIView {
        let view = SelectionButtonView()
        view.delegate = delegate
        view.update(style: style)
        return view
    }
}

import UIKit
import Checkout

public struct PaymentFormFactory {
  public static func getPaymentFormViewController(environment: Environment = .live,
                                                  billingFormData: BillingForm?,
                                                  paymentFormStyle: PaymentFormStyle?,
                                                  billingFormStyle: BillingFormStyle?) -> UIViewController {
    let cardValidator = CardValidator(environment: environment.checkoutEnvironment)
    let viewModel = DefaultPaymentViewModel(environment: environment,
                                            cardValidator: cardValidator,
                                            billingFormData: billingFormData,
                                            paymentFormStyle: paymentFormStyle,
                                            billingFormStyle: billingFormStyle)
    let viewController = PaymentViewController(viewModel: viewModel)

    if #available(iOS 13.0, *) {
      viewController.isModalInPresentation = true
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

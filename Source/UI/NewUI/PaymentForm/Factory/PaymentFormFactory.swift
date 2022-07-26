import UIKit
import Checkout

public typealias Card = Checkout.Card

public struct PaymentFormFactory {

  public static func buildViewController(configuration: PaymentFormConfiguration,
                                         style: PaymentStyle) -> UIViewController {
    let cardValidator = CardValidator(environment: configuration.environment.checkoutEnvironment)
    let viewModel = DefaultPaymentViewModel(cardValidator: cardValidator,
                                            billingFormData: configuration.billingFormData,
                                            paymentFormStyle: style.paymentFormStyle,
                                            billingFormStyle: style.billingFormStyle,
                                            supportedSchemes: configuration.supportedSchemes)

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

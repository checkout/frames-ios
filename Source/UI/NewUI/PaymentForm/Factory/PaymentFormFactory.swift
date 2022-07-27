import UIKit
import Checkout

public typealias Card = Checkout.Card

public struct PaymentFormFactory {
    
  // Persist in memory the correlation ID
  internal static var sessionCorrelationID = ""

  public static func buildViewController(configuration: PaymentFormConfiguration,
                                         style: PaymentStyle) -> UIViewController {
    // Ensure a consistent identifier is used for the monitoring of a journey
    Self.sessionCorrelationID = UUID().uuidString
    let logger = FramesEventLogger(environment: configuration.environment, getCorrelationID: { Self.sessionCorrelationID })
    let cardValidator = CardValidator(environment: configuration.environment.checkoutEnvironment)
    let viewModel = DefaultPaymentViewModel(cardValidator: cardValidator,
                                            logger: logger,
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

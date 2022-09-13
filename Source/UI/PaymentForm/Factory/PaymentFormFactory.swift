import UIKit
import Checkout

public enum PaymentFormFactory {

  // Persist in memory the correlation ID
  internal static var sessionCorrelationID = ""

  public static func buildViewController(configuration: PaymentFormConfiguration,
                                         style: FramesStyle,
                                         completionHandler: @escaping (Result<TokenDetails, TokenisationError.TokenRequest>) -> Void) -> UIViewController {
    // Ensure a consistent identifier is used for the monitoring of a journey
    Self.sessionCorrelationID = UUID().uuidString
    let logger = FramesEventLogger(environment: configuration.environment) { Self.sessionCorrelationID }
    let cardValidator = CardValidator(environment: configuration.environment.checkoutEnvironment)
    let checkoutAPIService = CheckoutAPIService(publicKey: configuration.serviceAPIKey,
                                                environment: configuration.environment)
    var viewModel = DefaultPaymentViewModel(checkoutAPIService: checkoutAPIService,
                                            cardValidator: cardValidator,
                                            logger: logger,
                                            billingFormData: configuration.billingFormData,
                                            paymentFormStyle: style.paymentFormStyle,
                                            billingFormStyle: style.billingFormStyle,
                                            supportedSchemes: configuration.supportedSchemes)
    viewModel.preventDuplicateCardholderInput()

    let viewController = PaymentViewController(viewModel: viewModel)
    viewModel.cardTokenRequested = completionHandler
    logger.log(.paymentFormInitialised(environment: configuration.environment))
    if #available(iOS 13.0, *) {
      viewController.isModalInPresentation = true
    }
    return viewController
  }
}

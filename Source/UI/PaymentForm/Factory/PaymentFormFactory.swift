import UIKit
import Checkout

public enum PaymentFormFactory {

    public static func buildViewController(configuration: PaymentFormConfiguration,
                                           style: PaymentStyle,
                                           completionHandler: @escaping (Result<TokenDetails, TokenisationError.TokenRequest>) -> Void) -> UIViewController {
        let logger = FramesEventLogger(environment: configuration.environment, correlationID: UUID().uuidString)
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

        let viewController = FramesPaymentViewController(viewModel: viewModel)
        viewModel.cardTokenRequested = completionHandler
        logger.log(.paymentFormInitialised(environment: configuration.environment))
        if #available(iOS 13.0, *) {
            viewController.isModalInPresentation = true
        }
        return viewController
    }
}

import Foundation
import CheckoutEventLoggerKit
import UIKit

/// Checkout API Client
/// used to call the api endpoint of Checkout API available with your public key
public class CheckoutAPIClient {

    // MARK: - Properties

    /// Checkout public key
    let publicKey: String

    /// Environment (sandbox or live)
    let environment: Environment

    /// Frames event logger.
    let logger: FramesEventLogging

    private let correlationIDGenerator: CorrelationIDGenerating
    private let mainDispatcher: Dispatching
    private let networkFlowLoggerProvider: NetworkFlowLoggerProviding
    private let requestExecutor: RequestExecuting

    // MARK: - Init

    init(publicKey: String,
         environment: Environment,
         correlationIDGenerator: CorrelationIDGenerating,
         logger: FramesEventLogging,
         mainDispatcher: Dispatching,
         networkFlowLoggerProvider: NetworkFlowLoggerProviding,
         requestExecutor: RequestExecuting) {

        self.publicKey = publicKey
        self.environment = environment
        self.correlationIDGenerator = correlationIDGenerator
        self.logger = logger
        self.mainDispatcher = mainDispatcher
        self.networkFlowLoggerProvider = networkFlowLoggerProvider
        self.requestExecutor = requestExecutor
    }

    /// Create an instance with the specified public key and environment
    ///
    /// - parameter publicKey: Checkout public key
    /// - parameter environment: Sandbox or Live (default to sandbox)
    ///
    ///
    /// - returns: The new `CheckoutAPIClient` instance
    public convenience init(publicKey: String,
                            environment: Environment = .sandbox) {

        let session = URLSession(configuration: .ephemeral)
        
        self.init(
            publicKey: publicKey,
            environment: environment,
            session: session)
    }
    
    convenience init(publicKey: String,
                     environment: Environment = .sandbox,
                     session: URLSession) {
        
        let jsonDecoder = JSONDecoder()
        let jsonEncoder = JSONEncoder()

        let requestExecutor = RequestExecutor(
            environmentURLProvider: environment,
            decoder: jsonDecoder,
            encoder: jsonEncoder,
            session: session)

        let appBundle = Foundation.Bundle.main
        let appPackageName = appBundle.bundleIdentifier ?? "unavailableAppPackageName"
        let appPackageVersion = appBundle.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unavailableAppPackageVersion"

        let uiDevice = UIKit.UIDevice.current

        let remoteProcessorMetadata = CheckoutAPIClient.buildRemoteProcessorMetadata(environment: environment,
                                                                                     appPackageName: appPackageName,
                                                                                     appPackageVersion: appPackageVersion,
                                                                                     uiDevice: uiDevice)

        let checkoutEventLogger = CheckoutEventLogger(productName: Constants.productName)
        checkoutEventLogger.enableRemoteProcessor(
            environment: environment == .sandbox ? .sandbox : .production,
            remoteProcessorMetadata: remoteProcessorMetadata)
        
        let dateProvider = DateProvider()
        let framesEventLogger = FramesEventLogger(checkoutEventLogger: checkoutEventLogger, dateProvider: dateProvider)
        let networkFlowLoggerFactory = NetworkFlowLoggerFactory(
            framesEventLogger: framesEventLogger,
            publicKey: publicKey)
        
        let correlationIDGenerator = CorrelationIDGenerator()
        let mainDispatcher = DispatchQueue.main

        self.init(publicKey: publicKey,
                  environment: environment,
                  correlationIDGenerator: correlationIDGenerator,
                  logger: framesEventLogger,
                  mainDispatcher: mainDispatcher,
                  networkFlowLoggerProvider: networkFlowLoggerFactory,
                  requestExecutor: requestExecutor)
    }

    // MARK: - Methods

    /// Get the list of card providers
    /// The list will contains card schemes as well as alternative payments
    ///
    /// - parameter successHandler: Callback to execute if the request is successful
    /// - parameter errorHandler: Callback to execute if the request failed
    public func getCardProviders(successHandler: @escaping ([CardProvider]) -> Void,
                                 errorHandler: @escaping (Error) -> Void) {
        
        let correlationID = correlationIDGenerator.generateCorrelationID()
        let request = Request.cardProviders(publicKey: publicKey, correlationID: correlationID)
        requestExecutor.execute(request, responseType: CardProviderResponse.self) { [mainDispatcher] (result, _) in
            
            switch result {
            case let .success(response):
                mainDispatcher.async { successHandler(response.data) }
            case let .failure(error):
                mainDispatcher.async { errorHandler(error) }
            }
        }
    }

    /// Create a card token
    ///
    /// - parameter card: Card used to create the token
    /// - parameter successHandler: Callback to execute if the request is successful
    /// - parameter errorHandler: Callback to execute if the request failed
    @available(*, deprecated, message: "Use createCardToken with a Swift Result type for completion handler.")
    public func createCardToken(card: CkoCardTokenRequest,
                                successHandler: @escaping (CkoCardTokenResponse) -> Void,
                                errorHandler: @escaping (ErrorResponse) -> Void) {
        
        createCardToken(card: card) { result in
            
            switch result {
            case let .success(cardTokenResponse):
                successHandler(cardTokenResponse)
            case let .failure(networkError):
                // Ignore other errors for backwards compatability.
                guard case let .checkout(requestID, errorType, errorCodes) = networkError else { return }
                
                let errorResponse = ErrorResponse(
                    requestId: requestID,
                    errorType: errorType,
                    errorCodes: errorCodes)
                errorHandler(errorResponse)
            }
        }
    }
    
    /// Create a card token
    ///
    /// - parameter card: Card used to create the token
    /// - parameter completion: Callback to execute if the request is successful or failed
    public func createCardToken(
        card: CkoCardTokenRequest,
        completion: @escaping ((Swift.Result<CkoCardTokenResponse, NetworkError>) -> Void)
    ) {
        let correlationID = correlationIDGenerator.generateCorrelationID()
        let networkFlowLogger = networkFlowLoggerProvider.createLogger(
            correlationID: correlationID,
            tokenType: .card)
        
        networkFlowLogger.logRequest()
        
        let request = Request.cardToken(
            body: card,
            publicKey: publicKey,
            correlationID: correlationID)
        requestExecutor.execute(request, responseType: CkoCardTokenResponse.self) {
            [mainDispatcher] (result, response) in
            
            networkFlowLogger.logResponse(result: result, response: response)
            
            mainDispatcher.async {
                completion(result)
            }
        }
    }

    /// Create a card token with Apple Pay
    ///
    /// - parameter paymentData: Apple Pay payment data used to create a card token
    /// - parameter successHandler: Callback to execute if the request is successful
    /// - parameter errorHandler: Callback to execute if the request failed
    @available(*, deprecated, message: "Use createApplePayToken with a Swift Result type for completion handler.")
    public func createApplePayToken(paymentData: Data,
                                    successHandler: @escaping (CkoCardTokenResponse) -> Void,
                                    errorHandler: @escaping (ErrorResponse) -> Void) {
        
        createApplePayToken(paymentData: paymentData) { result in
            
            switch result {
            case let .success(cardTokenResponse):
                successHandler(cardTokenResponse)
            case let .failure(networkError):
                // Ignore other errors for backwards compatability.
                guard case let .checkout(requestID, errorType, errorCodes) = networkError else { return }
                
                let errorResponse = ErrorResponse(
                    requestId: requestID,
                    errorType: errorType,
                    errorCodes: errorCodes)
                errorHandler(errorResponse)
            }
        }
    }
    
    /// Create a card token with Apple Pay
    ///
    /// - parameter paymentData: Apple Pay payment data used to create a card token
    /// - parameter completion: Callback to execute if the request is successful or failed
    public func createApplePayToken(
        paymentData: Data,
        completion: @escaping ((Swift.Result<CkoCardTokenResponse, NetworkError>) -> Void)
    ) {
        let correlationID = correlationIDGenerator.generateCorrelationID()
        let networkFlowLogger = networkFlowLoggerProvider.createLogger(
            correlationID: correlationID,
            tokenType: .applePay)
        
        networkFlowLogger.logRequest()

        let applePayTokenData = try? JSONDecoder().decode(ApplePayTokenData.self, from: paymentData)
        let applePayTokenRequest = ApplePayTokenRequest(token_data: applePayTokenData)

        let request = Request.applePayToken(
            body: applePayTokenRequest,
            publicKey: publicKey,
            correlationID: correlationID)
        requestExecutor.execute(request, responseType: CkoCardTokenResponse.self) {
            [mainDispatcher] (result, response) in
            
            networkFlowLogger.logResponse(result: result, response: response)
            
            mainDispatcher.async {
                completion(result)
            }
        }
    }

    static func buildRemoteProcessorMetadata(environment: Environment,
                                             appPackageName: String,
                                             appPackageVersion: String,
                                             uiDevice: UIDevice) -> RemoteProcessorMetadata {

        return RemoteProcessorMetadata(productIdentifier: Constants.productName,
                                       productVersion: Constants.version,
                                       environment: environment.rawValue,
                                       appPackageName: appPackageName,
                                       appPackageVersion: appPackageVersion,
                                       deviceName: uiDevice.modelName,
                                       platform: "iOS",
                                       osVersion: uiDevice.systemVersion)
    }
}

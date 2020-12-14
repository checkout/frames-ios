import Foundation

/// Checkout API Client
/// used to call the api endpoint of Checkout API available with your public key
public class CheckoutAPIClient {

    // MARK: - Properties

    /// Checkout public key
    let publicKey: String

    /// Environment (sandbox or live)
    let environment: Environment

    /// headers used for the requests
    private var headers: [String: String] {
        return ["Authorization": self.publicKey,
                "Content-Type": "application/json"]
    }

    private var jsonEncoder: JSONEncoder {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        return jsonEncoder
    }

    private var jsonDecoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }

    // MARK: - Initialization

    /// Create an instance with the specified public key and environment
    ///
    /// - parameter publicKey: Checkout public key
    /// - parameter environment: Sandbox or Live (default to sandbox)
    ///
    ///
    /// - returns: The new `CheckoutAPIClient` instance
    public init(publicKey: String, environment: Environment = .sandbox) {
        self.publicKey = publicKey
        self.environment = environment
    }

    // MARK: - Methods

    /// Get the list of card providers
    /// The list will contains card schemes as well as alternative payments
    ///
    /// - parameter successHandler: Callback to execute if the request is successful
    /// - parameter errorHandler: Callback to execute if the request failed
    public func getCardProviders(successHandler: @escaping ([CardProvider]) -> Void,
                                 errorHandler: @escaping (Error) -> Void) {
        let url = "\(environment.urlApi)\(Endpoint.cardProviders.rawValue)"

        request(url, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: value)

                    guard let data = String(data: jsonData, encoding: .utf8)?.data(using: .utf8) else {
                        errorHandler(NetworkError.invalidData)
                        return
                    }

                    let decoder = JSONDecoder()
                    let cardProviderResponse = try decoder.decode(CardProviderResponse.self, from: data)
                    successHandler(cardProviderResponse.data)
                } catch let error {
                    errorHandler(error)
                }
            case .failure(let error):
                errorHandler(error)
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
        let url = "\(environment.urlPaymentApi)\(Endpoint.tokens.rawValue)"
        let jsonEncoder = JSONEncoder()
        // swiftlint:disable:next force_try
        var urlRequest = try! URLRequest(url: URL(string: url)!, method: HTTPMethod.post, headers: headers)
        urlRequest.httpBody = try? jsonEncoder.encode(card)
        request(urlRequest)
            .validate().responseJSON { response in
                let decoder = JSONDecoder()
                switch response.result {
                case .success:
                    do {
                        let cardTokenResponse = try decoder.decode(CkoCardTokenResponse.self, from: response.data!)
                        successHandler(cardTokenResponse)
                    } catch let error {
                        print(error)
                    }
                case .failure:
                    do {
                        let cardTokenError = try decoder.decode(ErrorResponse.self, from: response.data!)
                        errorHandler(cardTokenError)
                    } catch let error {
                        print(error)
                    }
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
        let urlStr = "\(environment.urlPaymentApi)\(Endpoint.tokens.rawValue)"
        let jsonEncoder = JSONEncoder()

        guard let url = URL(string: urlStr),
              var urlRequest = try? URLRequest(url: url, method: .post, headers: headers) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        urlRequest.httpBody = try? jsonEncoder.encode(card)

        request(urlRequest)
            .validate().responseJSON { response in

                guard let data = response.data else {

                    if let error = response.error {
                        completion(.failure(.other(error: error)))
                    } else {
                        completion(.failure(NetworkError.invalidData))
                    }

                    return
                }

                let decoder = JSONDecoder()
                switch response.result {
                case .success:
                    do {
                        let cardTokenResponse = try decoder.decode(CkoCardTokenResponse.self, from: data)
                        completion(.success(cardTokenResponse))
                    } catch let error {
                        completion(.failure(.other(error: error)))
                    }
                case .failure(let responseError):
                    do {
                        let networkError = try decoder.decode(NetworkError.self, from: data)
                        completion(.failure(networkError))
                    } catch {
                        completion(.failure(.other(error: responseError)))
                    }
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
        let url = "\(environment.urlPaymentApi)\(Endpoint.tokens.rawValue)"
        // swiftlint:disable:next force_try
        var urlRequest = try! URLRequest(url: URL(string: url)!, method: HTTPMethod.post, headers: headers)
        let applePayTokenData = try? JSONDecoder().decode(ApplePayTokenData.self, from: paymentData)
        let applePayTokenRequest = ApplePayTokenRequest(token_data: applePayTokenData)
        urlRequest.httpBody = try? JSONEncoder().encode(applePayTokenRequest)

        request(urlRequest).validate().responseJSON { response in
            let decoder = JSONDecoder()
            switch response.result {
            case .success:
                do {
                    let applePayToken = try decoder.decode(CkoCardTokenResponse.self, from: response.data!)
                    successHandler(applePayToken)
                } catch let error {
                    print(error)
                }
            case .failure:
                do {
                    let applePayTokenError = try self.jsonDecoder.decode(ErrorResponse.self,
                                                                         from: response.data!)
                    errorHandler(applePayTokenError)
                } catch let error {
                    print(error)
                }
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

        let urlStr = "\(environment.urlPaymentApi)\(Endpoint.tokens.rawValue)"

        guard let url = URL(string: urlStr),
              var urlRequest = try? URLRequest(url: url, method: .post, headers: headers) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        let applePayTokenData = try? JSONDecoder().decode(ApplePayTokenData.self, from: paymentData)
        let applePayTokenRequest = ApplePayTokenRequest(token_data: applePayTokenData)
        urlRequest.httpBody = try? JSONEncoder().encode(applePayTokenRequest)

        request(urlRequest).validate().responseJSON { response in

            guard let data = response.data else {

                if let error = response.error {
                    completion(.failure(.other(error: error)))
                } else {
                    completion(.failure(NetworkError.invalidData))
                }

                return
            }

            let decoder = JSONDecoder()
            switch response.result {
            case .success:
                do {
                    let applePayToken = try decoder.decode(CkoCardTokenResponse.self, from: data)
                    completion(.success(applePayToken))
                } catch let error {
                    completion(.failure(.other(error: error)))
                }
            case .failure(let responseError):
                do {
                    let networkError = try decoder.decode(NetworkError.self, from: data)
                    completion(.failure(networkError))
                } catch {
                    completion(.failure(.other(error: responseError)))
                }
            }
        }
    }

}

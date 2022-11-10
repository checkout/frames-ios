import PassKit

enum ApplePayCreator {

  /// Create Apple pay view controller for Authorization
  static func createPaymentAuthorizationViewController(delegate: PKPaymentAuthorizationViewControllerDelegate) -> PKPaymentAuthorizationViewController? {

    /// Allowed payment  schemes
    let paymentNetworks: [PKPaymentNetwork] = [.amex, .discover, .masterCard, .visa]

    guard PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) else {
      // User is unable to make payments
      return nil
    }

    /// PKPaymentSummaryItem Defines a line-item for a payment such as tax, shipping, or discount.
    let paymentItem = PKPaymentSummaryItem(label: "Test item", amount: NSDecimalNumber(value: 12.99))

    /// PKPaymentRequest defines an application's request to produce a payment instrument for the
    /// purchase of goods and services. It encapsulates information about the selling party's payment
    /// processing capabilities, an amount to pay, and the currency code.
    let request = PKPaymentRequest()

    /// Currency code for this payment.
    request.currencyCode = "USD"

    /// The merchant's ISO country code.
    request.countryCode = "US"

    /// Identifies the merchant, as previously agreed with Apple.  Must match one of the merchant
    /// identifiers in the application's entitlement.
    request.merchantIdentifier = "com.checkout.merchant.io.test.ios"

    /// The payment processing capabilities of the merchant.
    request.merchantCapabilities = .capability3DS

    /// The payment networks supported by the merchant, for example @[ PKPaymentNetworkVisa,
    /// PKPaymentNetworkMasterCard ].  This property constrains payment cards that may fund the payment.
    request.supportedNetworks = paymentNetworks

    /// Array of PKPaymentSummaryItem objects which should be presented to the user.
    /// The last item should be the total you wish to charge, and should not be pending
    request.paymentSummaryItems = [paymentItem]

    let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: request)
    paymentVC?.delegate = delegate
    return paymentVC
  }

}

import Checkout

protocol PaymentViewModel {
  var billingFormData: BillingForm? { get set }
  var paymentFormStyle: PaymentFormStyle? { get set }
  var billingFormStyle: BillingFormStyle? { get set }
  var supportedSchemes: [Card.Scheme] { get set}
  var cardValidator: CardValidator { get set }
  var logger: FramesEventLogging { get }
  var updateEditBillingSummaryView: (() -> Void)? { get set }
  var updateAddBillingDetailsView: (() -> Void)? { get set }
  var updateExpiryDateView: (() -> Void)? { get set }
  var updateCardNumberView: (() -> Void)? { get set }
  var updateSecurityCodeView: (() -> Void)? { get set }
  var updateHeaderView: (() -> Void)? { get set }
  func updateAll()
  func viewControllerWillAppear()
  mutating func preventDuplicateCardholderInput()
}

extension PaymentViewModel {

    mutating func preventDuplicateCardholderInput() {
        if paymentFormStyle?.cardholderInput != nil {
            let filteredCells = billingFormStyle?.cells.filter {
                if case .fullName = $0 {
                    return false
                }
                return true
            } ?? []
            billingFormStyle?.cells = filteredCells
        }
    }

}

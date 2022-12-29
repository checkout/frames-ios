import Checkout

protocol PaymentViewModelDelegate: AnyObject {
    func loadingStateChanged()
    func updateEditBillingSummary()
    func updateAddBillingDetails()
    func updateCardholder()
    func updateCardScheme(_ newScheme: Card.Scheme)
    func refreshPayButtonState(isEnabled: Bool)
}

protocol PaymentViewModel {
  var delegate: PaymentViewModelDelegate? { get }
  var paymentFormStyle: PaymentFormStyle? { get set }
  var billingFormStyle: BillingFormStyle? { get set }
  var supportedSchemes: [Card.Scheme] { get set }
  var cardValidator: CardValidator { get set }
  var isLoading: Bool { get set }
  var cardTokenRequested: ((Result<TokenDetails, TokenisationError.TokenRequest>) -> Void)? { get set }
  func viewControllerWillAppear()
  func viewControllerCancelled()
  func updateBillingSummaryView()
  func presentBilling(presenter: UIPresenter)
  func expiryDateIsUpdated(result: Result<ExpiryDate, ExpiryDateError>)
  func securityCodeIsUpdated(to newCode: String)
  func cardholderIsUpdated(value: String)
  func payButtonIsPressed()
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

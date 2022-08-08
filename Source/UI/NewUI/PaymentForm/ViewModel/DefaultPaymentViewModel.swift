import UIKit
import Checkout

class DefaultPaymentViewModel: PaymentViewModel {
  var updateEditBillingSummaryView: (() -> Void)?
  var updateAddBillingDetailsView: (() -> Void)?
  var updateExpiryDateView: (() -> Void)?
  var updateCardNumberView: (() -> Void)?
  var updateSecurityCodeView: (() -> Void)?
  var updatePayButtonView: (() -> Void)?
  var updateHeaderView: (() -> Void)?
  var shouldEnablePayButton: ((Bool) -> Void)?
  var cardTokenRequested: ((Result<TokenDetails, TokenisationError.TokenRequest>) -> Void)?
  var supportedSchemes: [Card.Scheme]
  var cardValidator: CardValidator
  var logger: FramesEventLogging
  var checkoutAPIService: CheckoutAPIProtocol
  var paymentFormStyle: PaymentFormStyle?
  var billingFormStyle: BillingFormStyle?
  var billingFormData: BillingForm? {
    didSet {
      if isAddBillingSummaryNotUpdated() {
        updateBillingSummaryView()
      }
    }
  }

  private var cardDetails: Card = Card() {
    didSet {
      shouldEnablePayButton?(cardDetails.expiryDate != nil && cardDetails.number != nil)
    }
  }

  init(checkoutAPIService: CheckoutAPIProtocol,
       cardValidator: CardValidator,
       logger: FramesEventLogging,
       billingFormData: BillingForm?,
       paymentFormStyle: PaymentFormStyle?,
       billingFormStyle: BillingFormStyle?,
       supportedSchemes: [Card.Scheme]) {
    self.checkoutAPIService = checkoutAPIService
    self.supportedSchemes = supportedSchemes
    self.cardValidator = cardValidator
    self.billingFormData = billingFormData
    self.paymentFormStyle = paymentFormStyle
    self.billingFormStyle = billingFormStyle
    self.logger = logger
  }

  func viewControllerWillAppear() {
      logger.log(.paymentFormPresented)
  }

  func updateAll() {
    updateHeaderView?()
    updateCardNumberView?()
    updateExpiryDateView?()
    updateSecurityCodeView?()
    updatePayButtonView?()
    if isAddBillingSummaryNotUpdated() {
      updateBillingSummaryView()
    }
  }

  func updateBillingSummaryView() {
    guard paymentFormStyle?.editBillingSummary != nil else { return }
    var summaryValue = [String?]()

    billingFormStyle?.cells.forEach {
      switch $0 {
        case .fullName: summaryValue.append(billingFormData?.name)
        case .addressLine1: summaryValue.append(billingFormData?.address?.addressLine1)
        case .addressLine2: summaryValue.append(billingFormData?.address?.addressLine2)
        case .state: summaryValue.append(billingFormData?.address?.state)
        case .country: summaryValue.append(billingFormData?.address?.country?.name)
        case .city: summaryValue.append(billingFormData?.address?.city)
        case .postcode: summaryValue.append(billingFormData?.address?.zip)
        case .phoneNumber: summaryValue.append(billingFormData?.phone?.number)
      }
    }

    let summary = updateSummaryValue(with: summaryValue)
    guard !summary.isEmpty else {
      let addBillingSummary = paymentFormStyle?.addBillingSummary ?? DefaultAddBillingDetailsViewStyle()
      paymentFormStyle?.addBillingSummary = addBillingSummary
      updateAddBillingDetailsView?()
      return
    }
    paymentFormStyle?.editBillingSummary?.summary?.text = summary
    updateEditBillingSummaryView?()
  }

  private func isAddBillingSummaryNotUpdated() -> Bool {
    guard billingFormData?.address != nil ||
            billingFormData?.phone != nil else {
      let addBillingSummary = paymentFormStyle?.addBillingSummary ?? DefaultAddBillingDetailsViewStyle()
      paymentFormStyle?.addBillingSummary = addBillingSummary
      updateAddBillingDetailsView?()
      return false
    }
    return true
  }

  private func updateSummaryValue(with summaryValues: [String?]) -> String {
    summaryValues
      .compactMap { $0?.trimmingCharacters(in: .whitespaces) }
      .filter { !$0.isEmpty }
      .joined(separator: "\n\n")
  }

}

extension DefaultPaymentViewModel: BillingFormViewModelDelegate {
  func onBillingScreenShown() {
    logger.log(.billingFormPresented)
  }

  func onTapDoneButton(data: BillingForm) {
    self.billingFormData = data
  }
}

extension DefaultPaymentViewModel: PaymentViewControllerDelegate {
  func cardNumberIsUpdated(value: String?) {
    cardDetails.number = value
  }

  func payButtonIsPressed() {
    checkoutAPIService.createToken(.card(cardDetails)) { [weak self] result in
      self?.cardTokenRequested?(result)
    }
  }

  func securityCodeIsUpdated(value: String?) {
    cardDetails.cvv = value
  }

  func expiryDateIsUpdated(value: ExpiryDate?) {
    cardDetails.expiryDate = value
  }

  func addBillingButtonIsPressed(sender: UINavigationController?) {
    onTapAddressView(sender: sender)
  }

  func editBillingButtonIsPressed(sender: UINavigationController?) {
    onTapAddressView(sender: sender)
  }

  private func onTapAddressView(sender: UINavigationController?) {
    guard let viewController = BillingFormFactory.getBillingFormViewController(style: billingFormStyle, data: billingFormData, delegate: self) else { return }
    sender?.present(viewController, animated: true)
  }
}

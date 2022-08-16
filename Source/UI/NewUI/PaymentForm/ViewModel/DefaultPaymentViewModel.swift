import UIKit
import Checkout

class DefaultPaymentViewModel: PaymentViewModel {
  var updateEditBillingSummaryView: (() -> Void)?
  var updateAddBillingDetailsView: (() -> Void)?
  var updateExpiryDateView: (() -> Void)?
  var updateCardNumberView: (() -> Void)?
  var updateSecurityCodeView: (() -> Void)?
  var updateHeaderView: (() -> Void)?
  var supportedSchemes: [Card.Scheme]
  var cardValidator: CardValidator
  var logger: FramesEventLogging
  var paymentFormStyle: PaymentFormStyle?
  var billingFormStyle: BillingFormStyle?
  var billingFormData: BillingForm? {
    didSet {
      if isAddBillingSummaryNotUpdated() {
        updateBillingSummaryView()
      }
    }
  }

  init(cardValidator: CardValidator,
       logger: FramesEventLogging,
       billingFormData: BillingForm?,
       paymentFormStyle: PaymentFormStyle?,
       billingFormStyle: BillingFormStyle?,
       supportedSchemes: [Card.Scheme]) {
    self.supportedSchemes = NSOrderedSet(array: supportedSchemes).array as? [Card.Scheme] ?? []
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

  // TODO: Will be implemented in payment ticket
  func securityCodeIsUpdated(value: String) {}

  // TODO: Will be implemented in payment ticket
  func expiryDateIsUpdated(value: ExpiryDate) {}

  func addBillingButtonIsPressed(sender: UINavigationController?) {
    onTapAddressView(sender: sender)
  }

  func editBillingButtonIsPressed(sender: UINavigationController?) {
    onTapAddressView(sender: sender)
  }

  // TODO: Need updating from Payment ticket merge
  func cardholderIsUpdated(value: String) {
      print("CARDHOLDER INPUT IS UPDATED", value)
  }

  private func onTapAddressView(sender: UINavigationController?) {
    guard let viewController = BillingFormFactory.getBillingFormViewController(style: billingFormStyle, data: billingFormData, delegate: self) else { return }
    sender?.present(viewController, animated: true)
  }
}

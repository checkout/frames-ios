import UIKit
import Checkout

class DefaultPaymentViewModel: PaymentViewModel {
  var updateEditBillingSummaryView: (() -> Void)?
  var updateAddBillingDetailsView: (() -> Void)?
  var updateExpiryDateView: (() -> Void)?
  var updateCardNumberView: (() -> Void)?
  var updateSecurityCodeView: (() -> Void)?

  var environment: Environment
  var cardValidator: CardValidator
  var paymentFormStyle: PaymentFormStyle?
  var billingFormStyle: BillingFormStyle?
  var billingFormData: BillingForm? {
    didSet {
      if isAddBillingSummaryNotUpdated() {
        updateBillingSummaryView()
      }
    }
  }

  init(environment: Environment,
       cardValidator: CardValidator,
       billingFormData: BillingForm?,
       paymentFormStyle: PaymentFormStyle?,
       billingFormStyle: BillingFormStyle?) {
    self.environment = environment
    self.cardValidator = cardValidator
    self.billingFormData = billingFormData
    self.paymentFormStyle = paymentFormStyle
    self.billingFormStyle = billingFormStyle
  }

  func updateAll() {
    updateCardNumber()
    updateExpiryDate()
    updateSecurityCode()
    if isAddBillingSummaryNotUpdated() {
      updateBillingSummaryView()
    }
  }

  private func updateCardNumber() {
    updateCardNumberView?()
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

  private func updateExpiryDate() {
    updateExpiryDateView?()
  }

  private func updateSecurityCode() {
    updateSecurityCodeView?()
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
      .joined(separator: "\n\n")
  }
}

extension DefaultPaymentViewModel: BillingFormViewModelDelegate {
  func onTapDoneButton(data: BillingForm) {
    self.billingFormData = data
  }
}

extension DefaultPaymentViewModel: PaymentViewControllerDelegate {
  // TODO: Will fixed in payment ticket
  func expiryDateIsUpdated(value: ExpiryDate) {}

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

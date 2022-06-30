import UIKit
import Checkout

class DefaultPaymentViewModel: PaymentViewModel {

    var updateEditBillingSummaryView: (() -> Void)?
    var updateAddBillingDetailsView: (() -> Void)?
    var updateExpiryDateView: (() -> Void)?
    var updateCardNumberView: (() -> Void)?

    var paymentFormStyle: PaymentFormStyle?
    var billingFormStyle: BillingFormStyle?
    var billingFormData: BillingForm? {
        didSet {
            if isAddBillingSummaryNotUpdated() {
                updateBillingSummaryView()
            }
        }
    }

    init(billingFormData: BillingForm?,
         paymentFormStyle: PaymentFormStyle?,
         billingFormStyle: BillingFormStyle?) {
        self.billingFormData = billingFormData
        self.paymentFormStyle = paymentFormStyle
        self.billingFormStyle = billingFormStyle
    }

    func updateAll() {
        updateCardNumber()
        updateExpiryDate()
        if isAddBillingSummaryNotUpdated() {
            updateBillingSummaryView()
        }
    }

    private func updateCardNumber(){
        updateCardNumberView?()
    }

    func updateBillingSummaryView() {
        guard let data = billingFormData, paymentFormStyle?.editBillingSummary != nil
        else { return }

        var summaryValue = ""

        // user name
        updateSummaryValue(with: data.name, summaryValue: &summaryValue)

        // address
        if let address = billingFormData?.address {
            updateSummaryValue(with: address.addressLine1, summaryValue: &summaryValue)
            updateSummaryValue(with: address.addressLine2, summaryValue: &summaryValue)
            updateSummaryValue(with: address.city, summaryValue: &summaryValue)
            updateSummaryValue(with: address.state, summaryValue: &summaryValue)
            updateSummaryValue(with: address.zip, summaryValue: &summaryValue)
            updateSummaryValue(with: address.country?.name, summaryValue: &summaryValue)
        }

        // phone
        if let phone = billingFormData?.phone {
            updateSummaryValue(with: phone.number, summaryValue: &summaryValue, withNewLine: false)
        }
        
        paymentFormStyle?.editBillingSummary?.summary?.text = summaryValue
        updateEditBillingSummaryView?()
    }

    private func updateExpiryDate(){
        updateExpiryDateView?()
    }

    private func isAddBillingSummaryNotUpdated() -> Bool{
        guard billingFormData?.address != nil ||
              billingFormData?.phone != nil else {
            let addBillingSummary = paymentFormStyle?.addBillingSummary ?? DefaultAddBillingDetailsViewStyle()
            paymentFormStyle?.addBillingSummary = addBillingSummary
            updateAddBillingDetailsView?()
            return false
        }
        return true
    }

    private func updateSummaryValue(with value: String?, summaryValue: inout String,  withNewLine: Bool = true) {
        guard let value = value else { return }
        let billingFormValue = value.trimmingCharacters(in: .whitespaces)
        if !billingFormValue.isEmpty {
            let newLine = withNewLine ? "\n\n" : ""
            summaryValue.append("\(billingFormValue)\(newLine)")
        }
    }

}

extension DefaultPaymentViewModel: BillingFormViewModelDelegate {

    func onTapDoneButton(data: BillingForm) {
        self.billingFormData = data
    }
}

extension DefaultPaymentViewModel: PaymentViewControllerDelegate {
    //TODO: Will fixed in payment ticket
    func expiryDateIsUpdated(value: ExpiryDate) {

    }

    func addBillingButtonIsPressed(sender: UINavigationController?) {
        onTapAddressView(sender: sender)
    }

    func editBillingButtonIsPressed(sender: UINavigationController?) {
        onTapAddressView(sender: sender)
    }

    private func onTapAddressView(sender: UINavigationController?) {
        guard let viewController = BillingFormFactory.getBillingFormViewController(style: billingFormStyle, data: billingFormData, delegate: self) else { return  }
        sender?.present(viewController, animated: true)
    }
}

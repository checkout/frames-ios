import UIKit

class DefaultPaymentViewModel: PaymentViewModel {

    var updateEditBillingSummaryView: (() -> Void)?
    var updateAddBillingDetailsView: (() -> Void)?
    var updateExpiryDateView: (() -> Void)?

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
        updateExpiryDate()
        if isAddBillingSummaryNotUpdated() {
            updateBillingSummaryView()
        }
    }

    func updateBillingSummaryView() {
        guard paymentFormStyle?.editBillingSummary != nil else { return }
        var summaryValue = ""

        billingFormStyle?.cells.forEach {
            switch $0.index {

                    // name
                case BillingFormCell.fullName(nil).index:
                    updateSummaryValue(with: billingFormData?.name, summaryValue: &summaryValue)

                    // addressLine1
                case BillingFormCell.addressLine1(nil).index:
                    updateSummaryValue(with: billingFormData?.address?.addressLine1, summaryValue: &summaryValue)

                    // addressLine2
                case BillingFormCell.addressLine2(nil).index:
                    updateSummaryValue(with: billingFormData?.address?.addressLine2, summaryValue: &summaryValue)

                    // state
                case BillingFormCell.state(nil).index:
                    updateSummaryValue(with: billingFormData?.address?.state, summaryValue: &summaryValue)

                    //country
                case BillingFormCell.country(nil).index:
                    updateSummaryValue(with: billingFormData?.address?.country?.name, summaryValue: &summaryValue)

                    // city
                case BillingFormCell.city(nil).index:
                    updateSummaryValue(with: billingFormData?.address?.city, summaryValue: &summaryValue)

                    //postcode
                case BillingFormCell.postcode(nil).index:
                    updateSummaryValue(with: billingFormData?.address?.zip, summaryValue: &summaryValue)

                    // phone number
                case BillingFormCell.phoneNumber(nil).index:
                    updateSummaryValue(with: billingFormData?.phone?.number, summaryValue: &summaryValue, withNewLine: false)
                default:
                    return

            }
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

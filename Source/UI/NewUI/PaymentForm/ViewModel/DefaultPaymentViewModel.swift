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
            switch $0 {
                case .fullName:
                    updateSummaryValue(with: billingFormData?.name, summaryValue: &summaryValue)
                case .addressLine1:
                    updateSummaryValue(with: billingFormData?.address?.addressLine1, summaryValue: &summaryValue)
                case .addressLine2:
                    updateSummaryValue(with: billingFormData?.address?.addressLine2, summaryValue: &summaryValue)
                case .state:
                    updateSummaryValue(with: billingFormData?.address?.state, summaryValue: &summaryValue)
                case .country:
                    updateSummaryValue(with: billingFormData?.address?.country?.name, summaryValue: &summaryValue)
                case .city:
                    updateSummaryValue(with: billingFormData?.address?.city, summaryValue: &summaryValue)
                case .postcode:
                    updateSummaryValue(with: billingFormData?.address?.zip, summaryValue: &summaryValue)
                case .phoneNumber:
                    updateSummaryValue(with: billingFormData?.phone?.number, summaryValue: &summaryValue, withNewLine: false)
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

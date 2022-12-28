import UIKit
import Checkout

class DefaultPaymentViewModel: PaymentViewModel {
    weak var delegate: PaymentViewModelDelegate?
    var cardTokenRequested: ((Result<TokenDetails, TokenisationError.TokenRequest>) -> Void)?
    var supportedSchemes: [Card.Scheme]
    var cardValidator: CardValidator
    var logger: FramesEventLogging
    var checkoutAPIService: CheckoutAPIProtocol
    var paymentFormStyle: PaymentFormStyle?
    var billingFormStyle: BillingFormStyle?
    var currentScheme: Card.Scheme = .unknown
    var billingFormData: BillingForm?
    var isLoading = false {
        didSet {
            if isLoading != oldValue {
                delegate?.loadingStateChanged()
            }
        }
    }

    private var cardDetails = CardCreationModel()

    init(checkoutAPIService: CheckoutAPIProtocol,
         cardValidator: CardValidator,
         logger: FramesEventLogging,
         billingFormData: BillingForm?,
         paymentFormStyle: PaymentFormStyle?,
         billingFormStyle: BillingFormStyle?,
         supportedSchemes: [Card.Scheme]) {
        self.checkoutAPIService = checkoutAPIService
        self.supportedSchemes = NSOrderedSet(array: supportedSchemes).array as? [Card.Scheme] ?? []
        self.cardValidator = cardValidator
        self.paymentFormStyle = paymentFormStyle
        self.billingFormStyle = billingFormStyle
        self.logger = logger

        if let billingFormData = billingFormData {
            updateBillingData(to: billingFormData)
        }
    }

    func viewControllerWillAppear() {
        logger.log(.paymentFormPresented)
    }

    func viewControllerCancelled() {
        logger.log(.paymentFormCanceled)
    }

    func updateBillingSummaryView() {
        guard paymentFormStyle?.editBillingSummary != nil,
              let formStyle = billingFormStyle else { return }
        let summary = formStyle.summaryFrom(form: billingFormData)
        guard !summary.isEmpty else {
            let addBillingSummary = paymentFormStyle?.addBillingSummary ?? DefaultAddBillingDetailsViewStyle()
            paymentFormStyle?.addBillingSummary = addBillingSummary
            delegate?.updateAddBillingDetails()
            return
        }
        paymentFormStyle?.editBillingSummary?.summary?.text = summary
        delegate?.updateEditBillingSummary()
    }

    private func updateBillingData(to billingForm: BillingForm) {
        self.billingFormData = billingForm
        cardDetails.phone = billingForm.phone
        cardDetails.billingAddress = billingForm.address
        if let billingName = billingForm.name {
            cardDetails.name = billingName
            paymentFormStyle?.cardholderInput?.textfield.text = billingName
            delegate?.updateCardholder()
        }
        if isAddBillingSummaryNotUpdated() {
            updateBillingSummaryView()
        }
        validateMandatoryInputProvided()
    }

    private func isAddBillingSummaryNotUpdated() -> Bool {
        guard billingFormData?.address != nil ||
                billingFormData?.phone != nil else {
            let addBillingSummary = paymentFormStyle?.addBillingSummary ?? DefaultAddBillingDetailsViewStyle()
            paymentFormStyle?.addBillingSummary = addBillingSummary
            delegate?.updateAddBillingDetails()
            return false
        }
        return true
    }

}

extension DefaultPaymentViewModel: BillingFormViewModelDelegate {
    func onBillingScreenShown() {
        logger.log(.billingFormPresented)
    }

    func onTapDoneButton(data: BillingForm) {
        logger.log(.billingFormSubmit)
        updateBillingData(to: data)
    }

    func onTapCancelButton() {
        logger.log(.billingFormCanceled)
    }
}

extension DefaultPaymentViewModel {
    func expiryDateIsUpdated(result: Result<ExpiryDate, ExpiryDateError>) {
        switch result {
        case .failure:
            cardDetails.expiryDate = nil
        case .success(let expiryDate):
            cardDetails.expiryDate = expiryDate
        }
        validateMandatoryInputProvided()
    }

    func securityCodeIsUpdated(to newCode: String) {
        cardDetails.cvv = newCode
        validateMandatoryInputProvided()
    }

    func payButtonIsPressed() {
        guard let card = cardDetails.getCard() else {
            logger.log(.warn(message: "Pay button pressed without all required fields input"))
            return
        }
        logger.log(.paymentFormSubmitted)
        isLoading = true
        checkoutAPIService.createToken(.card(card)) { [weak self] result in
            self?.logTokenResult(result)
            self?.isLoading = false
            self?.cardTokenRequested?(result)
        }
    }

    func presentBilling(presenter: UIPresenter) {
        guard let viewController = FramesFactory.getBillingFormViewController(style: billingFormStyle,
                                                                              data: billingFormData,
                                                                              delegate: self,
                                                                              sender: presenter) else { return }
        presenter.present(viewController, animated: true)
    }

    func cardholderIsUpdated(value: String) {
        cardDetails.name = value
        validateMandatoryInputProvided()
    }

    private func validateMandatoryInputProvided() {
        var isMandatoryInputProvided = false
        defer {
            delegate?.refreshPayButtonState(isEnabled: isMandatoryInputProvided)
        }

        // If a scheme is not recorded the number hasn't started being inputted
        // so we can safely know mandatory fields are not provided
        guard let cardScheme = cardDetails.scheme else { return }

        // Check if cardholder is required and if so whether it is provided
        let isCardholderRequired = paymentFormStyle?.cardholderInput?.isMandatory == true
        if isCardholderRequired && cardDetails.name.isEmpty { return }

        // Check if security code is displayed and if so whether it is valid
        // This is business logic that wants Security code to be mandatory whenever its shown
        let isSecurityCodeRequired = paymentFormStyle?.securityCode != nil
        if isSecurityCodeRequired, !cardValidator.isValid(cvv: cardDetails.cvv, for: cardScheme) { return }

        // Check if Billing is required and if so whether it exists
        let isAddBillingRequired = paymentFormStyle?.addBillingSummary?.isMandatory == true
        let isEditBillingRequired = paymentFormStyle?.editBillingSummary?.isMandatory == true
        let isBillingRequired = isAddBillingRequired && isEditBillingRequired
        if isBillingRequired && cardDetails.billingAddress == nil { return }

        // Ensure compulsory fields of Card Number and Expiry date have valid values
        guard case .success(let scheme) = cardValidator.validateCompleteness(cardNumber: cardDetails.number),
              scheme.isComplete else {
            // Incomplete card number
            return
        }

        guard let expiryDate = cardDetails.expiryDate,
              case .success = cardValidator.validate(expiryMonth: expiryDate.month, expiryYear: expiryDate.year) else {
            // Missing / invalid expiry date
            return
        }
        isMandatoryInputProvided = true
    }

    private func logTokenResult(_ result: Result<TokenDetails, TokenisationError.TokenRequest>) {
        switch result {
        case .success(let tokenDetails):
            logger.log(.paymentFormSubmittedResult(token: tokenDetails.token))
        case .failure(let requestError):
            logger.log(.warn(message: "\(requestError.code) " + requestError.localizedDescription))
        }
    }
}

extension DefaultPaymentViewModel: CardNumberViewModelDelegate {
    func update(result: Result<CardInfo, CardNumberError>) {
        switch result {
        case .failure:
            cardDetails.number = ""
            cardDetails.scheme = nil
        case .success(let cardInfo):
            cardDetails.number = cardInfo.cardNumber
            cardDetails.scheme = cardInfo.scheme
            delegate?.updateCardScheme(cardInfo.scheme)
        }
        validateMandatoryInputProvided()
    }

    func schemeUpdatedEagerly(to newScheme: Card.Scheme) {
        delegate?.updateCardScheme(newScheme)
    }
}

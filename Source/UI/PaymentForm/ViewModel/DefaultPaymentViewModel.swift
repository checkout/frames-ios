import UIKit
import Checkout

class DefaultPaymentViewModel: PaymentViewModel {
    var updateLoading: (() -> Void)?
    var updateEditBillingSummaryView: (() -> Void)?
    var updateAddBillingDetailsView: (() -> Void)?
    var updateExpiryDateView: (() -> Void)?
    var updateCardholderView: (() -> Void)?
    var updateCardNumberView: (() -> Void)?
    var updateSecurityCodeViewStyle: (() -> Void)?
    var updatePayButtonView: (() -> Void)?
    var updateHeaderView: (() -> Void)?
    var updateSecurityCodeViewScheme: ((Card.Scheme) -> Void)?
    var shouldEnablePayButton: ((Bool) -> Void)?
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
            updateLoading?()
        }
    }

    private var cardDetails: CardCreationModel

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
        let isCVVOptional = paymentFormStyle?.securityCode == nil
        self.cardDetails = CardCreationModel(isCVVOptional: isCVVOptional)

        if let billingFormData = billingFormData {
            updateBillingData(to: billingFormData)
        }
    }

    deinit {
        PhoneNumberValidator.removeSingleton()
    }

    func viewControllerWillAppear() {
        logger.log(.paymentFormPresented)
    }

    func viewControllerCancelled() {
        logger.log(.paymentFormCanceled)
        cardTokenRequested?(.failure(.userCancelled))
    }

    func updateAll() {
        updateHeaderView?()
        updateCardholderView?()
        updateCardNumberView?()
        updateExpiryDateView?()
        updateSecurityCodeViewStyle?()
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
            case .phoneNumber:
                    guard let phoneString = billingFormData?.phone?.displayFormatted(), !phoneString.isEmpty else { return }
                    summaryValue.append(phoneString)
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

    private func updateBillingData(to billingForm: BillingForm) {
        self.billingFormData = billingForm
        cardDetails.phone = billingForm.phone
        cardDetails.billingAddress = billingForm.address
        if let billingName = billingForm.name {
            cardDetails.name = billingName
            paymentFormStyle?.cardholderInput?.textfield.text = billingName
            updateCardholderView?()
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
        logger.log(.billingFormSubmit)
        updateBillingData(to: data)
    }

    func onTapCancelButton() {
        logger.log(.billingFormCanceled)
    }
}

extension DefaultPaymentViewModel: PaymentViewControllerDelegate {
    func expiryDateIsUpdated(result: Result<ExpiryDate, ValidationError.ExpiryDate>) {
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

    func addBillingButtonIsPressed(sender: UINavigationController?) {
        onTapAddressView(sender: sender)
    }

    func editBillingButtonIsPressed(sender: UINavigationController?) {
        onTapAddressView(sender: sender)
    }

    func cardholderIsUpdated(value: String) {
        cardDetails.name = value
        validateMandatoryInputProvided()
    }

    private func validateMandatoryInputProvided() {
        var isMandatoryInputProvided = false
        defer { shouldEnablePayButton?(isMandatoryInputProvided) }

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

    private func onTapAddressView(sender: UINavigationController?) {
        guard let viewController = FramesFactory.getBillingFormViewController(style: billingFormStyle,
                                                                              data: billingFormData,
                                                                              delegate: self,
                                                                              sender: sender) else { return }
        sender?.present(viewController, animated: true)
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
            updateSecurityCodeViewScheme?(cardInfo.scheme)
        }
        validateMandatoryInputProvided()
    }

    func schemeUpdatedEagerly(to newScheme: Card.Scheme) {
        updateSecurityCodeViewScheme?(newScheme)
    }
}

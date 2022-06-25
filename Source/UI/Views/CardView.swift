import Foundation
import UIKit
import Checkout

protocol CardViewDelegate: AnyObject {
    func selectionButtonIsPressed()
}

/// A view that displays card information inputs
class CardView: UIView {

    // MARK: - Properties
    weak var delegate: CardViewDelegate?

    let schemeIconsStackView = SchemeIconsStackView()
    // Input options
    let cardHolderNameState: InputState
    let billingDetailsState: InputState
    /// Accepted Card Label
    let acceptedCardLabel = UILabel()

    /// Card number input view
    let cardNumberInputView: CardNumberInputView

    /// Card holder's name input view
    let cardHolderNameInputView = StandardInputView()

    /// Expiration date input view
    let expirationDateInputView = ExpirationDateInputView()

    /// Cvv input view
    let cvvInputView: CvvInputView

    /// Billing details input view
    let billingDetailsInputView = DetailsInputView()
    let addressTapGesture = UITapGestureRecognizer()
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    
    private let contentView = UIView()
    private var scrollViewBottomConstraint: NSLayoutConstraint!

    //MARK: NEW UI
    private(set) var isNewUI: Bool = false
    private var billingFormData: BillingForm?

    private lazy var billingFormSummaryView: BillingFormSummaryView = {
        let view = BillingFormSummaryView()
        view.delegate = self
        return view
    }()

    private lazy var addBillingFormButtonView: SelectionButtonView = {
        let view = SelectionButtonView()
        view.delegate = self
        return view
    }()

    private lazy var expiryDateView: InputView = {
        let view = InputView()
        return view
    }()

    // MARK: - Initialization

    /// Initializes and returns a newly allocated view object with the specified frame rectangle.
    override init(frame: CGRect) {
        cardHolderNameState = .required
        billingDetailsState = .required
        cardNumberInputView = CardNumberInputView(cardValidator: nil)
        cvvInputView = CvvInputView(cardValidator: nil)
        super.init(frame: frame)
        setup()
    }

    /// Returns an object initialized from data in a given unarchiver.
    required init?(coder aDecoder: NSCoder) {
        cardHolderNameState = .required
        billingDetailsState = .required
        cardNumberInputView = CardNumberInputView(cardValidator: nil)
        cvvInputView = CvvInputView(cardValidator: nil)
        super.init(coder: aDecoder)
        setup()
    }

    /// Initializes and returns a newly  allocated card view with the specified input states.
    init(isNewUI: Bool, billingFormData: BillingForm?, cardHolderNameState: InputState, billingDetailsState: InputState, cardValidator: CardValidating?) {
        self.isNewUI = isNewUI
        self.billingFormData = billingFormData
        self.cardHolderNameState = cardHolderNameState
        self.billingDetailsState = billingDetailsState
        self.cardNumberInputView = CardNumberInputView(cardValidator: cardValidator)
        cvvInputView = CvvInputView(cardValidator: cardValidator)
        super.init(frame: .zero)
        setup()
    }

    // MARK: - Methods

    private func setup() {
        scrollView.keyboardDismissMode = .onDrag
        addViews()
        addInitialConstraints()
        backgroundColor = CheckoutTheme.primaryBackgroundColor
        acceptedCardLabel.text = "acceptedCards".localized(forClass: CardView.self)
        acceptedCardLabel.font = CheckoutTheme.font
        acceptedCardLabel.textColor = CheckoutTheme.color
        cardNumberInputView.set(label: "cardNumber", backgroundColor: CheckoutTheme.secondaryBackgroundColor)
        expirationDateInputView.set(label: "expirationDate", backgroundColor: CheckoutTheme.secondaryBackgroundColor)
        cvvInputView.set(label: "cvv", backgroundColor: CheckoutTheme.secondaryBackgroundColor)
        // card holder name
        if cardHolderNameState == .required {
            cardHolderNameInputView.set(label: "cardholderNameRequired",
                                        backgroundColor: CheckoutTheme.secondaryBackgroundColor)
        } else {
            cardHolderNameInputView.set(label: "cardholderName",
                                        backgroundColor: CheckoutTheme.secondaryBackgroundColor)
        }
        // billing details
        if billingDetailsState == .required {
            billingDetailsInputView.set(label: "billingDetailsRequired",
                                        backgroundColor: CheckoutTheme.secondaryBackgroundColor)
        } else {
            billingDetailsInputView.set(label: "billingDetails",
                                        backgroundColor: CheckoutTheme.secondaryBackgroundColor)
        }

        cardNumberInputView.textField.placeholder = "4242"
        expirationDateInputView.textField.placeholder = "06/20"
        cvvInputView.textField.placeholder = "100"

        schemeIconsStackView.spacing = 8
        stackView.axis = .vertical
        stackView.spacing = 16
        // keyboard
        var textFields = [cardNumberInputView.textField,
                          expirationDateInputView.textField,
                          cvvInputView.textField]
        if cardHolderNameState != .hidden {
            textFields.insert(cardHolderNameInputView.textField, at: 1)
        }
        addKeyboardToolbarNavigation(textFields: textFields)
    }

    private func addViews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(acceptedCardLabel)
        contentView.addSubview(schemeIconsStackView)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(cardNumberInputView)
        if cardHolderNameState != .hidden {
            stackView.addArrangedSubview(cardHolderNameInputView)
        }
        stackView.addArrangedSubview(expirationDateInputView)
        stackView.addArrangedSubview(cvvInputView)
        stackView.addArrangedSubview(expiryDateView)
        setupBillingForm()
    }

    private func setupBillingForm() {
        let showBillingFormDetailsInputView = billingDetailsState != .hidden && isNewUI
        billingFormSummaryView.isHidden = !showBillingFormDetailsInputView
        let showBillingDetailsInputView = billingDetailsState != .hidden && !isNewUI
        billingDetailsInputView.isHidden = !showBillingDetailsInputView
        if billingDetailsState != .hidden {
            if isNewUI {
                if billingFormData?.address == nil && billingFormData?.phone == nil {
                    stackView.addArrangedSubview(addBillingFormButtonView)
                } else {
                    stackView.addArrangedSubview(billingFormSummaryView)
                }
            } else {
                stackView.addArrangedSubview(billingDetailsInputView)
            }
        }
    }

    private func addInitialConstraints() {
        scrollViewBottomConstraint = self.addScrollViewContraints(scrollView: scrollView, contentView: contentView)
        acceptedCardLabel.translatesAutoresizingMaskIntoConstraints = false
        schemeIconsStackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false

        acceptedCardLabel.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor, constant: -8)
            .isActive = true
        acceptedCardLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        acceptedCardLabel.topAnchor.constraint(equalTo: contentView.safeTopAnchor, constant: 16).isActive = true
        acceptedCardLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
            .isActive = true

        schemeIconsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
            .isActive = true
        schemeIconsStackView.topAnchor.constraint(equalTo: acceptedCardLabel.bottomAnchor, constant: 16).isActive = true
        schemeIconsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true

        stackView.trailingAnchor.constraint(equalTo: contentView.safeTrailingAnchor, constant: -20).isActive = true
        stackView.topAnchor.constraint(equalTo: schemeIconsStackView.safeBottomAnchor, constant: 16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.safeLeadingAnchor, constant: 20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.safeBottomAnchor).isActive = true
    }

    func updateExpiryDateView(style: CellTextFieldStyle) {
        expiryDateView.update(style: style)
    }

    func updateAddBillingFormButtonView(style: CellButtonStyle?) {
        guard let style = style else { return }
        addBillingFormButtonView.update(style: style)
    }

    func updateBillingFormSummaryView(style: BillingSummaryViewStyle) {
        billingFormSummaryView.update(style: style)
    }
}

extension CardView: SelectionButtonViewDelegate {
    func selectionButtonIsPressed() {
        delegate?.selectionButtonIsPressed()
    }
}

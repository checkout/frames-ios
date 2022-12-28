import UIKit
import Checkout

// swiftlint:disable file_length
final class PaymentViewController: UIViewController, UIPresenter {

  // MARK: - Variables
  private(set) var viewModel: PaymentViewModel
  private var notificationCenter = NotificationCenter.default

  // MARK: - UI properties

  private lazy var headerView: PaymentHeaderView = {
    PaymentHeaderView(supportedSchemes: viewModel.supportedSchemes).disabledAutoresizingIntoConstraints()
  }()

  private lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView().disabledAutoresizingIntoConstraints()
    scrollView.keyboardDismissMode = .onDrag
    scrollView.delegate = self
    return scrollView
  }()

  private lazy var stackView: UIStackView = {
    let view = UIStackView().disabledAutoresizingIntoConstraints()
    view.axis = .vertical
    view.spacing = Constants.Padding.l.rawValue
    return view
  }()

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

  private lazy var expiryDateView: ExpiryDateView = {
    let view = ExpiryDateView(cardValidator: viewModel.cardValidator)
    view.delegate = self
    return view
  }()

  private lazy var cardholderView: CardholderView = {
    let cardholderViewModel = CardholderViewModel()
    cardholderViewModel.delegate = self
    let view = CardholderView(viewModel: cardholderViewModel)
    return view
  }()

  private lazy var cardNumberView: CardNumberView = {
    let cardNumberViewModel = CardNumberViewModel(cardValidator: viewModel.cardValidator, supportedSchemes: viewModel.supportedSchemes)
    cardNumberViewModel.delegate = viewModel as? CardNumberViewModelDelegate
    let cardNumberView = CardNumberView(viewModel: cardNumberViewModel)
    return cardNumberView
  }()

  private lazy var securityCodeView: SecurityCodeView = {
    let viewModel = SecurityCodeViewModel(cardValidator: viewModel.cardValidator)
    let view = SecurityCodeView(viewModel: viewModel)
    view.delegate = self
    return view
  }()

  private lazy var payButtonView: ButtonView = {
    let view = ButtonView(startEnabled: false)
    view.delegate = self
    return view
  }()

  private lazy var headerBackgroundView: UIView = {
    UIView().disabledAutoresizingIntoConstraints()
  }()

  // MARK: - functions

  init(viewModel: PaymentViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    UITextField.disableHardwareLayout()
    guard let paymentFormStyle = viewModel.paymentFormStyle else {
      return
    }
    view.backgroundColor = paymentFormStyle.backgroundColor
    stackView.backgroundColor = paymentFormStyle.backgroundColor
    setupNavigationBar()
    setupViewsInOrder()

    headerView.update(style: paymentFormStyle.headerView)
    headerBackgroundView.backgroundColor = paymentFormStyle.headerView.backgroundColor
    cardNumberView.update(style: paymentFormStyle.cardNumber)
    securityCodeView.update(style: paymentFormStyle.securityCode)
    payButtonView.update(with: paymentFormStyle.payButton)
    expiryDateView.update(style: paymentFormStyle.expiryDate)
    viewModel.updateBillingSummaryView()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    deregisterKeyboardHandlers(notificationCenter: notificationCenter)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)

    setUpKeyboard()
    viewModel.viewControllerWillAppear()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupNavigationBar() {
      navigationItem.leftBarButtonItem = UIBarButtonItem(
        image: Constants.Bundle.Images.leftArrow.image?.imageFlippedForRightToLeftLayoutDirection(),
        style: .plain,
        target: self,
        action: #selector(popViewController))
  }

  @objc private func popViewController() {
    viewModel.viewControllerCancelled()
    self.navigationController?.popViewController(animated: true)
  }

  @objc private func keyboardWillShow(notification: Notification) {
    guard let userInfo = notification.userInfo,
    let keyboardFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    var keyboardFrame = keyboardFrameValue.cgRectValue
    keyboardFrame = view.convert(keyboardFrame, from: nil)
    var contentInset: UIEdgeInsets = scrollView.contentInset
    contentInset.bottom = keyboardFrame.size.height + Constants.Padding.l.rawValue
    updateScrollViewInset(to: contentInset, from: notification)
  }

  @objc private func keyboardWillHide(notification: Notification) {
    updateScrollViewInset(to: .zero, from: notification)
  }

  private func setUpKeyboard() {
    registerKeyboardHandlers(notificationCenter: notificationCenter,
                             keyboardWillShow: #selector(keyboardWillShow),
                             keyboardWillHide: #selector(keyboardWillHide))
  }

  private func updateScrollViewInset(to contentInset: UIEdgeInsets, from notification: Notification) {
    var animationDuration: Double = 0
    if let userInfo = notification.userInfo,
       let notificationAnimationDuration: Double = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
      animationDuration = notificationAnimationDuration
    }
    UIView.animate(withDuration: animationDuration) {
      self.scrollView.contentInset = contentInset
    }
  }
}

// MARK: ViewModel Delegate
extension PaymentViewController: PaymentViewModelDelegate {

    func loadingStateChanged() {
        DispatchQueue.main.async { [weak self] in
            self?.payButtonView.isLoading = self?.viewModel.isLoading ?? false
        }
    }

    func updateEditBillingSummary() {
        DispatchQueue.main.async { [weak self] in
            guard let style = self?.viewModel.paymentFormStyle?.editBillingSummary else { return }
            self?.addBillingFormButtonView.isHidden = true
            self?.billingFormSummaryView.isHidden = false
            self?.billingFormSummaryView.update(style: style)
        }
    }

    func updateAddBillingDetails() {
        DispatchQueue.main.async { [weak self] in
            guard let style = self?.viewModel.paymentFormStyle?.addBillingSummary else { return }
            self?.addBillingFormButtonView.isHidden = false
            self?.billingFormSummaryView.isHidden = true
            self?.addBillingFormButtonView.update(style: style)
        }
    }

    func updateCardholder() {
        DispatchQueue.main.async { [weak self] in
            guard let style = self?.viewModel.paymentFormStyle?.cardholderInput else { return }
            self?.cardholderView.update(style: style)
        }
    }

    func updateCardScheme(_ newScheme: Card.Scheme) {
        DispatchQueue.main.async { [weak self] in
            self?.securityCodeView.updateCardScheme(cardScheme: newScheme)
        }
    }

    func refreshPayButtonState(isEnabled: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.payButtonView.isEnabled = isEnabled
        }
    }
}

// MARK: Setup UI
extension PaymentViewController {
  private func setupViewsInOrder() {
    setupScrollView()
    setupStackView()
    addArrangedSubviewForStackView()
    setupHeaderBackground()
  }

  private func addArrangedSubviewForStackView() {
    var paymentViews: [UIView] = [
      headerView
    ]
    if let cardholderStyle = viewModel.paymentFormStyle?.cardholderInput {
      paymentViews.append(cardholderView)
      cardholderView.update(style: cardholderStyle)
    }
    paymentViews.append(contentsOf: [cardNumberView, expiryDateView])

    if viewModel.paymentFormStyle?.securityCode != nil {
      paymentViews.append(securityCodeView)
    }

    if viewModel.paymentFormStyle?.addBillingSummary != nil && viewModel.paymentFormStyle?.editBillingSummary != nil {
      paymentViews.append(contentsOf: [
        addBillingFormButtonView,
        billingFormSummaryView])
    }

    paymentViews.append(payButtonView)
    stackView.addArrangedSubviews(paymentViews)
    stackView.layoutMargins = UIEdgeInsets(top: 0,
                                           left: Constants.Padding.l.rawValue,
                                           bottom: Constants.Padding.l.rawValue,
                                           right: Constants.Padding.l.rawValue)
    stackView.isLayoutMarginsRelativeArrangement = true
  }

  private func setupHeaderBackground() {
    stackView.addSubview(headerBackgroundView)
    stackView.sendSubviewToBack(headerBackgroundView)
    NSLayoutConstraint.activate([
      headerBackgroundView.topAnchor.constraint(equalTo: headerView.topAnchor),
      headerBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      headerBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      headerBackgroundView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
    ])
  }

  func setupScrollView() {
    view.addSubview(scrollView)
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }

  func setupStackView() {
    scrollView.addSubview(stackView)
    stackView.setupConstraintEqualTo(view: scrollView)
    stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
  }
}

// MARK: SubView Delegate
extension PaymentViewController: SelectionButtonViewDelegate {
  func selectionButtonIsPressed() {
    viewModel.presentBilling(presenter: navigationController ?? self)
  }
}

extension PaymentViewController: BillingFormSummaryViewDelegate {
  func summaryButtonIsPressed() {
    viewModel.presentBilling(presenter: navigationController ?? self)
  }
}

extension PaymentViewController: ExpiryDateViewDelegate {
  func update(result: Result<ExpiryDate, ExpiryDateError>) {
    viewModel.expiryDateIsUpdated(result: result)
  }
}

extension PaymentViewController: CardholderDelegate {
  func cardholderUpdated(to cardholderInput: String) {
    viewModel.cardholderIsUpdated(value: cardholderInput)
  }
}

extension PaymentViewController: SecurityCodeViewDelegate {
  func update(securityCode: String) {
    viewModel.securityCodeIsUpdated(to: securityCode)
  }
}

extension PaymentViewController: ButtonViewDelegate {
  func selectionButtonIsPressed(sender: UIView) {
    viewModel.payButtonIsPressed()
  }
}

extension PaymentViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let contentOffsetY = scrollView.contentOffset.y + scrollView.adjustedContentInset.top

    if headerView.frame.maxY > 0, contentOffsetY > headerView.frame.maxY / 2 {
      title = viewModel.paymentFormStyle?.headerView.headerLabel?.text
      scrollView.backgroundColor = viewModel.paymentFormStyle?.backgroundColor
    } else {
      title = nil
      if scrollView.contentSize.height > scrollView.frame.maxY {
        scrollView.backgroundColor = viewModel.paymentFormStyle?.headerView.backgroundColor
      }
    }
  }
}

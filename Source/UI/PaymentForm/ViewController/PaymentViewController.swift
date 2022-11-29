import UIKit
import Checkout

protocol PaymentViewControllerDelegate: AnyObject {
  func addBillingButtonIsPressed(sender: UINavigationController?)
  func editBillingButtonIsPressed(sender: UINavigationController?)
  func expiryDateIsUpdated(result: Result<ExpiryDate, ExpiryDateError>)
  func securityCodeIsUpdated(to newCode: String)
  func cardholderIsUpdated(value: String)
  func payButtonIsPressed()
}

// swiftlint:disable file_length
open class PaymentViewController: UIViewController {

  // MARK: - Variables

  weak var delegate: PaymentViewControllerDelegate?

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

   public lazy var payButtonView: ButtonView = {
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

    open override func viewDidLoad() {
    super.viewDidLoad()
    UITextField.disableHardwareLayout()
    setupNavigationBar()
    setupViewModel()
    setupViewsInOrder()
    viewModel.updateAll()
  }

    open override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    deregisterKeyboardHandlers(notificationCenter: notificationCenter)
  }

    open override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)

    setUpKeyboard()
    viewModel.viewControllerWillAppear()
  }

    required public init?(coder: NSCoder) {
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
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          
          let info = notification.userInfo!
          let rect: CGRect = info[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
          let kbSize = rect.size
          
          let insets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
          
          
          // If active text field is hidden by keyboard, scroll it so it's visible
          // Your application might not need or want this behavior.
          var aRect = self.view.frame;
          aRect.size.height -= kbSize.height;
          
          let activeField: UITextField? = self.view.firstResponder as? UITextField
          
          if let activeField = activeField {
              if !aRect.contains(activeField.frame.origin) {
                  self.scrollView.contentInset = insets
                  self.scrollView.scrollIndicatorInsets = insets
                  let scrollPoint = CGPoint(x: 0, y: activeField.frame.origin.y-kbSize.height)
                  self.scrollView.setContentOffset(scrollPoint, animated: true)
              }
          }
      }
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

// MARK: View Model Integration

extension PaymentViewController {
  private func setupViewModel() {
    delegate = self.viewModel as? PaymentViewControllerDelegate
    updateBackgroundViews()
    setupAddBillingDetailsViewClosure()
    setupEditBillingSummaryViewClosure()
    setupExpiryDateViewClosure()
    setupCardholderViewClosure()
    setupCardNumberViewClosure()
    setupSecurityCodeViewClosures()
    setupPayButtonViewClosure()
    setupHeaderViewClosure()
    setupLoadingIndicatorClosure()
  }

    private func setupLoadingIndicatorClosure() {
        viewModel.updateLoading = { [weak self] in
            DispatchQueue.main.async {
                self?.payButtonView.isLoading = self?.viewModel.isLoading ?? false
            }
        }
    }

  private func setupHeaderViewClosure() {
    viewModel.updateHeaderView = { [weak self] in
      DispatchQueue.main.async {
        self?.updateHeaderView()
      }
    }
  }

  private func setupAddBillingDetailsViewClosure() {
    viewModel.updateAddBillingDetailsView = { [weak self] in
      DispatchQueue.main.async {
        self?.updateAddBillingFormButtonView()
      }
    }
  }

  private func setupEditBillingSummaryViewClosure() {
    viewModel.updateEditBillingSummaryView = { [weak self] in
      DispatchQueue.main.async {
        self?.updateEditBillingSummaryView()
      }
    }
  }

  private func setupExpiryDateViewClosure() {
    viewModel.updateExpiryDateView = { [weak self] in
      DispatchQueue.main.async {
        self?.updateExpiryDate()
      }
    }
  }

  private func setupCardholderViewClosure() {
    viewModel.updateCardholderView = { [weak self] in
      DispatchQueue.main.async {
        self?.updateCardholder()
      }
    }
  }

  private func setupCardNumberViewClosure() {
    viewModel.updateCardNumberView = { [weak self] in
      DispatchQueue.main.async {
        self?.updateCardNumber()
      }
    }
  }

  private func setupSecurityCodeViewClosures() {
    viewModel.updateSecurityCodeViewStyle = { [weak self] in
      DispatchQueue.main.async {
        self?.updateSecurityCode()
      }
    }

    viewModel.updateSecurityCodeViewScheme = {  [weak self] scheme in
      DispatchQueue.main.async {
        self?.securityCodeView.updateCardScheme(cardScheme: scheme)
      }
    }
  }

  private func setupPayButtonViewClosure() {
    viewModel.updatePayButtonView = { [weak self] in
      DispatchQueue.main.async {
        self?.updatePayButtonView()
      }
    }

    viewModel.shouldEnablePayButton = { [weak self] isEnabled in
      self?.payButtonView.isEnabled = isEnabled
    }
  }

  private func updateBackgroundViews() {
    view.backgroundColor = viewModel.paymentFormStyle?.backgroundColor
    stackView.backgroundColor = viewModel.paymentFormStyle?.backgroundColor
  }

  private func updateCardholder() {
    guard let style = viewModel.paymentFormStyle?.cardholderInput else { return }
    cardholderView.update(style: style)
  }

  private func updateCardNumber() {
    guard let style = viewModel.paymentFormStyle?.cardNumber else { return }
    cardNumberView.update(style: style)
  }

  private func updateExpiryDate() {
    guard let style = viewModel.paymentFormStyle?.expiryDate else { return }
    expiryDateView.update(style: style)
  }

  private func updateSecurityCode() {
    guard let style = viewModel.paymentFormStyle?.securityCode else { return }
    securityCodeView.update(style: style)
  }

  private func updatePayButtonView() {
      // guard let style = viewModel.paymentFormStyle?.payButton else { return }
   // payButtonView.update(with: style)
  }

  private func updateAddBillingFormButtonView() {
    guard let style = viewModel.paymentFormStyle?.addBillingSummary else { return }
    addBillingFormButtonView.isHidden = false
    billingFormSummaryView.isHidden = true
    addBillingFormButtonView.update(style: style)
  }

  private func updateEditBillingSummaryView() {
    guard let style = viewModel.paymentFormStyle?.editBillingSummary else { return }
    addBillingFormButtonView.isHidden = true
    billingFormSummaryView.isHidden = false
    billingFormSummaryView.update(style: style)
  }

  public func updateHeaderView() {
    guard let style = viewModel.paymentFormStyle?.headerView else { return }
    headerView.update(style: style)
    headerBackgroundView.backgroundColor = style.backgroundColor
  }
}

// MARK: Setup Views

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

extension PaymentViewController: SelectionButtonViewDelegate {
  func selectionButtonIsPressed() {
    delegate?.addBillingButtonIsPressed(sender: navigationController)
  }
}

extension PaymentViewController: BillingFormSummaryViewDelegate {
  func summaryButtonIsPressed() {
    delegate?.editBillingButtonIsPressed(sender: navigationController)
  }
}

extension PaymentViewController: ExpiryDateViewDelegate {
  func update(result: Result<ExpiryDate, ExpiryDateError>) {
    delegate?.expiryDateIsUpdated(result: result)
  }
}

extension PaymentViewController: CardholderDelegate {
  func cardholderUpdated(to cardholderInput: String) {
    delegate?.cardholderIsUpdated(value: cardholderInput)
  }
}

extension PaymentViewController: SecurityCodeViewDelegate {
  func update(securityCode: String) {
    delegate?.securityCodeIsUpdated(to: securityCode)
  }
}

extension PaymentViewController: ButtonViewDelegate {
  func selectionButtonIsPressed(sender: UIView) {
    delegate?.payButtonIsPressed()
  }
}

extension PaymentViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
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

extension UIView {
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }

        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }

        return nil
    }
}

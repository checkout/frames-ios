import UIKit
import Checkout

protocol PaymentViewControllerDelegate: AnyObject {
  func addBillingButtonIsPressed(sender: UINavigationController?)
  func editBillingButtonIsPressed(sender: UINavigationController?)
  func expiryDateIsUpdated(result: Result<ExpiryDate, ValidationError.ExpiryDate>)
  func securityCodeIsUpdated(to newCode: String)
  func cardholderIsUpdated(value: String)
  func payButtonIsPressed()
}

// swiftlint:disable file_length
final class FramesPaymentViewController: UIViewController {

  // MARK: - Variables

  weak var delegate: PaymentViewControllerDelegate?

  private(set) var viewModel: PaymentViewModel
  private var notificationCenter = NotificationCenter.default

  /// Overridable in tests to supply a scene object without requiring a real
  /// scene-backed window. When nil the implementation resolves the scene from
  /// view.window?.windowScene at registration time.
  var windowSceneProvider: (() -> AnyObject?)?

  // MARK: - Privacy cover

  /// Opaque overlay shown while the app is inactive so the system snapshot
  /// (app-switcher thumbnail) contains no card data.
  private lazy var privacyCoverView: UIView = {
    let cover = UIView()
    cover.backgroundColor = .systemBackground
    cover.translatesAutoresizingMaskIntoConstraints = false
    cover.isHidden = true
    return cover
  }()

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
    view.accessibilityIdentifier = AccessibilityIdentifiers.PaymentForm.cardExpiry
    return view
  }()

  private lazy var cardholderView: CardholderView = {
    let cardholderViewModel = CardholderViewModel()
    cardholderViewModel.delegate = self
    let view = CardholderView(viewModel: cardholderViewModel)
    view.accessibilityIdentifier = AccessibilityIdentifiers.PaymentForm.cardholder
    return view
  }()

  private lazy var cardNumberView: CardNumberView = {
    let cardNumberViewModel = CardNumberViewModel(cardValidator: viewModel.cardValidator, supportedSchemes: viewModel.supportedSchemes)
    cardNumberViewModel.delegate = viewModel as? CardNumberViewModelDelegate
    let cardNumberView = CardNumberView(viewModel: cardNumberViewModel)
    cardNumberView.accessibilityIdentifier = AccessibilityIdentifiers.PaymentForm.cardNumber
    return cardNumberView
  }()

  private lazy var securityCodeView: SecurityCodeView = {
    let viewModel = SecurityCodeViewModel(cardValidator: viewModel.cardValidator)
    let view = SecurityCodeView(viewModel: viewModel)
    view.accessibilityIdentifier = AccessibilityIdentifiers.PaymentForm.cardSecurityCode
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
    setupNavigationBar()
    setupViewModel()
    setupViewsInOrder()
    setupPrivacyCover()
    viewModel.updateAll()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    deregisterKeyboardHandlers(notificationCenter: notificationCenter)
    deregisterPrivacyCoverHandlers()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)

    setUpKeyboard()
    registerPrivacyCoverHandlers()
    viewModel.viewControllerWillAppear()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    // The view is now attached to a window. If viewWillAppear registered
    // app-level fallback observers because no scene was available yet,
    // re-register now that the owning scene is resolvable so that scene-scoped
    // observers are used for the remainder of the presentation.
    if #available(iOS 13.0, *), resolvedWindowScene() != nil {
      deregisterPrivacyCoverHandlers()
      registerPrivacyCoverHandlers()
    }
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

  // MARK: - Privacy cover

  private func setupPrivacyCover() {
    view.addSubview(privacyCoverView)
    NSLayoutConstraint.activate([
      privacyCoverView.topAnchor.constraint(equalTo: view.topAnchor),
      privacyCoverView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      privacyCoverView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      privacyCoverView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }

  private func registerPrivacyCoverHandlers() {
    if #available(iOS 13.0, *), let owningScene = resolvedWindowScene() {
      // Scope notifications to the specific scene that owns this window so that
      // activity in an unrelated window/scene cannot affect this cover.
      notificationCenter.addObserver(self,
                                     selector: #selector(addPrivacyCover),
                                     name: UIScene.willDeactivateNotification,
                                     object: owningScene)
      notificationCenter.addObserver(self,
                                     selector: #selector(removePrivacyCover),
                                     name: UIScene.didActivateNotification,
                                     object: owningScene)
      // Sync immediately: if the VC reappears while the scene is already inactive
      // (e.g. app-switched while the VC was off-screen), show the cover now.
      syncPrivacyCoverToCurrentState(scene: owningScene)
    } else {
      // Fallback for pre-scene hosts: use application-level notifications.
      notificationCenter.addObserver(self,
                                     selector: #selector(addPrivacyCover),
                                     name: UIApplication.willResignActiveNotification,
                                     object: nil)
      notificationCenter.addObserver(self,
                                     selector: #selector(removePrivacyCover),
                                     name: UIApplication.didBecomeActiveNotification,
                                     object: nil)
      // Sync immediately against the current application state.
      syncPrivacyCoverToCurrentState(scene: nil)
    }
  }

  /// Returns the scene token to scope notifications to. Uses windowSceneProvider
  /// when injected (for tests); otherwise falls back to view.window?.windowScene.
  @available(iOS 13.0, *)
  private func resolvedWindowScene() -> AnyObject? {
    if let provider = windowSceneProvider {
      return provider()
    }
    return view.window?.windowScene
  }

  private func deregisterPrivacyCoverHandlers() {
    notificationCenter.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
    notificationCenter.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    if #available(iOS 13.0, *) {
      notificationCenter.removeObserver(self, name: UIScene.willDeactivateNotification, object: nil)
      notificationCenter.removeObserver(self, name: UIScene.didActivateNotification, object: nil)
    }
  }

  /// Aligns cover visibility with the current activation state so stale cover
  /// state cannot persist across disappear/appear cycles.
  private func syncPrivacyCoverToCurrentState(scene: AnyObject?) {
    if #available(iOS 13.0, *), let windowScene = scene as? UIWindowScene {
      if windowScene.activationState == .foregroundActive {
        removePrivacyCover()
      } else {
        addPrivacyCover()
      }
    } else {
      if UIApplication.shared.applicationState == .active {
        removePrivacyCover()
      } else {
        addPrivacyCover()
      }
    }
  }

  @objc private func addPrivacyCover() {
    view.bringSubviewToFront(privacyCoverView)
    privacyCoverView.isHidden = false
  }

  @objc private func removePrivacyCover() {
    privacyCoverView.isHidden = true
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

extension FramesPaymentViewController {
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
    guard let style = viewModel.paymentFormStyle?.payButton else { return }
    payButtonView.update(with: style)
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

extension FramesPaymentViewController {
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
    }
    paymentViews.append(contentsOf: [cardNumberView, expiryDateView])

    if viewModel.paymentFormStyle?.securityCode != nil {
      paymentViews.append(securityCodeView)
    }

    if viewModel.billingFormStyle != nil &&
        viewModel.paymentFormStyle?.addBillingSummary != nil &&
        viewModel.paymentFormStyle?.editBillingSummary != nil {
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

extension FramesPaymentViewController: SelectionButtonViewDelegate {
  func selectionButtonIsPressed() {
    delegate?.addBillingButtonIsPressed(sender: navigationController)
  }
}

extension FramesPaymentViewController: BillingFormSummaryViewDelegate {
  func summaryButtonIsPressed() {
    delegate?.editBillingButtonIsPressed(sender: navigationController)
  }
}

extension FramesPaymentViewController: ExpiryDateViewDelegate {
  func update(result: Result<ExpiryDate, ValidationError.ExpiryDate>) {
    delegate?.expiryDateIsUpdated(result: result)
  }
}

extension FramesPaymentViewController: CardholderDelegate {
  func cardholderUpdated(to cardholderInput: String) {
    delegate?.cardholderIsUpdated(value: cardholderInput)
  }
}

extension FramesPaymentViewController: SecurityCodeViewDelegate {
  func update(securityCode: String) {
    delegate?.securityCodeIsUpdated(to: securityCode)
  }
}

extension FramesPaymentViewController: ButtonViewDelegate {
  func selectionButtonIsPressed(sender: UIView) {
    delegate?.payButtonIsPressed()
  }
}

extension FramesPaymentViewController: UIScrollViewDelegate {
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

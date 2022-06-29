import UIKit

protocol PaymentViewControllerDelegate: AnyObject {
    func addBillingButtonIsPressed(sender: UINavigationController?)
    func editBillingButtonIsPressed(sender: UINavigationController?)
}

final class PaymentViewController: UIViewController {

    //MARK: - Variables

    weak var delegate: PaymentViewControllerDelegate?
    private(set) var viewModel: PaymentViewModel

    //MARK: - UI properties

    //TODO: Replace it with new header
    private lazy var emptyHeader: UIView = {
        UIView().disabledAutoresizingIntoConstraints()
    }()

    private lazy var scrollView: UIScrollView = {
        UIScrollView().disabledAutoresizingIntoConstraints()
    }()

    private(set) lazy var stackView: UIStackView = {
        let view = UIStackView().disabledAutoresizingIntoConstraints()
        view.axis = .vertical
        view.spacing = 20
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

    private lazy var expiryDateView: InputView = {
        InputView()
    }()

    //MARK: - functions

    init(viewModel: PaymentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UIFont.loadAllCheckoutFonts
        UITextField.disableHardwareLayout()
        view.backgroundColor = .white
        setupViewModel()
        setupViewsInOrder()
        viewModel.updateAll()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //TODO: Remove when the new header view is added
        navigationController?.isNavigationBarHidden = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//Mark: View Model Integration

extension PaymentViewController {

    private func setupViewModel() {
        delegate = self.viewModel as? PaymentViewControllerDelegate
        setupAddBillingDetailsViewClosure()
        setupEditBillingSummaryViewClosure()
        setupExpiryDateViewClosure()
    }

    private func setupAddBillingDetailsViewClosure(){
        viewModel.updateAddBillingDetailsView = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.updateAddBillingFormButtonView()
            }
        }
    }

    private func setupEditBillingSummaryViewClosure(){
        viewModel.updateEditBillingSummaryView = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.updateEditBillingSummaryView()
            }
        }
    }

    private func setupExpiryDateViewClosure(){
        viewModel.updateExpiryDateView = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.updateExpiryDate()
            }
        }
    }

    private func updateExpiryDate(){
        guard let style = viewModel.paymentFormStyle?.expiryDate else { return }
        expiryDateView.update(style: style)
    }

    private func updateAddBillingFormButtonView(){
        guard let style = viewModel.paymentFormStyle?.addBillingSummary else { return }
        addBillingFormButtonView.isHidden = false
        billingFormSummaryView.isHidden = true
        addBillingFormButtonView.update(style: style)
    }

    private func updateEditBillingSummaryView(){
        guard let style = viewModel.paymentFormStyle?.editBillingSummary else { return }
        addBillingFormButtonView.isHidden = true
        billingFormSummaryView.isHidden = false
        billingFormSummaryView.update(style: style)
    }
}

//MARK: Setup Views

extension PaymentViewController {

    private func setupViewsInOrder() {
        setupHeaderView()
        setupScrollView()
        setupStackView()
        addArrangedSubviewForStackView()
    }

    private func addArrangedSubviewForStackView(){
        stackView.addArrangedSubview(expiryDateView)
        stackView.addArrangedSubview(addBillingFormButtonView)
        stackView.addArrangedSubview(billingFormSummaryView)
    }

    func setupHeaderView() {
        view.addSubview(emptyHeader)
        NSLayoutConstraint.activate([
            emptyHeader.topAnchor.constraint(equalTo: view.topAnchor,
                                             constant: CheckoutTheme.Padding.l.rawValue),
            emptyHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                 constant: CheckoutTheme.Padding.l.rawValue),
            emptyHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                  constant: -CheckoutTheme.Padding.l.rawValue),
            emptyHeader.heightAnchor.constraint(equalToConstant: 160)
        ])
    }

    func setupScrollView() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: emptyHeader.bottomAnchor,
                                            constant: CheckoutTheme.Padding.l.rawValue),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                constant: CheckoutTheme.Padding.l.rawValue),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                 constant: -CheckoutTheme.Padding.l.rawValue),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                               constant: CheckoutTheme.Padding.l.rawValue),
        ])
    }

    func setupStackView(){
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


import Checkout
import UIKit

protocol BillingFormTableViewDelegate: AnyObject {
    func tableView(numberOfRowsInSection section: Int) -> Int
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    func tableView(tableView: UITableView, cellForRowAt indexPath: IndexPath, sender: UIViewController) -> UITableViewCell
    func tableView(estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
}

protocol BillingFormTextFieldDelegate: AnyObject {
    func textFieldShouldEndEditing(textField: BillingFormTextField, replacementString: String)
    func textFieldShouldChangeCharactersIn(textField: UITextField, replacementString string: String)
}

protocol BillingFormViewControllerDelegate: AnyObject {
    func doneButtonIsPressed(sender: UIViewController)
    func cancelButtonIsPressed(sender: UIViewController)
    func getViewForHeader(sender: UIViewController) -> UIView?
    func update(country: Country, tag: Int)
    func phoneNumberIsUpdated(number: String)
}

/**
 This class is for billing form list that allow user to fill required fields
 */

final class BillingFormViewController: UIViewController {

    // MARK: - Properties

    weak var delegate: BillingFormViewControllerDelegate?
    weak var tableViewDelegate: BillingFormTableViewDelegate?
    weak var textFieldDelegate: BillingFormTextFieldDelegate?

    private var focusedTextField: UITextField?
    private var viewModel: BillingFormViewModel
    private var notificationCenter = NotificationCenter.default

    // MARK: - UI elements

    private lazy var headerView: UIView? = {
        let view = delegate?.getViewForHeader(sender: self)
        view?.translatesAutoresizingMaskIntoConstraints = false
        return view ?? UIView()
    }()

    private(set) lazy var tableView: UITableView? = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 300
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.allowsSelection = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.register(CellTextField.self)
        view.register(CellButton.self)

        return view
    }()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewModel.style.mainBackground
        setupViewsInOrder()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        setUpKeyboard()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deregisterKeyboardHandlers(notificationCenter: notificationCenter)
    }

    /**
     Initializes a view controller with view model protocol

     - Parameters:
        - viewModel: The bill form view model implementation.
     */

    init(viewModel: BillingFormViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupViewModel()
        tableView?.register(CellTextField.self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViewModel() {
        delegate = viewModel as? BillingFormViewControllerDelegate
        tableViewDelegate = viewModel as? BillingFormTableViewDelegate
        textFieldDelegate = viewModel as? BillingFormTextFieldDelegate

        viewModel.updateRow = { [weak self] in
            DispatchQueue.main.async {
                self?.refreshCell(at: self?.viewModel.updatedRow)
            }
        }
    }

    private func refreshCell(at row: Int?) {
        guard let row = row else { return }
        let indexPath = IndexPath(row: row, section: 0)
        tableView?.reloadRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Keyboard

    @objc private func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let scrollView = tableView else { return }
        scrollViewOnKeyboardWillShow(notification: notification,
                                     scrollView: scrollView,
                                          activeField: focusedTextField)
    }

    @objc private func keyboardWillHide(notification: Notification) {
        tableView?.setBottomInset(to: 0.0)
        self.focusedTextField = nil
    }

    private func setUpKeyboard() {
        registerKeyboardHandlers(notificationCenter: notificationCenter,
                                      keyboardWillShow: #selector(keyboardWillShow),
                                      keyboardWillHide: #selector(keyboardWillHide))
    }
}

// MARK: - Views Layout Constraint

extension BillingFormViewController {

    private func setupViewsInOrder() {
        setupHeaderView()
        setupTableView()
    }

    private func setupHeaderView() {
        guard let headerView = headerView else { return }
        view.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(
                equalTo: view.safeTopAnchor,
                constant: 20),
            headerView.leadingAnchor.constraint(
                equalTo: view.safeLeadingAnchor,
                constant: 20),
            headerView.trailingAnchor.constraint(
                equalTo: view.safeTrailingAnchor,
                constant: -20),
            headerView.heightAnchor.constraint(
                equalToConstant: 130)
        ])
    }

    private func setupTableView() {
        guard let tableView = tableView else { return }
        guard let headerView = headerView else { return }
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: headerView.safeBottomAnchor),
            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 20),
            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -20),
            tableView.bottomAnchor.constraint(
                equalTo: view.safeBottomAnchor,
                constant: 20)
        ])
    }

}

// MARK: - UITableViewDataSource and UITableViewDelegate

extension BillingFormViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewDelegate?.tableView(numberOfRowsInSection: section) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableViewDelegate?.tableView(tableView: tableView, cellForRowAt: indexPath, sender: self) ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        tableViewDelegate?.tableView(estimatedHeightForRowAt: indexPath) ?? 0.0
    }
}

// MARK: - Text Field Delegate

extension BillingFormViewController: CellTextFieldDelegate {
    func phoneNumberIsUpdated(number: String) {
        delegate?.phoneNumberIsUpdated(number: number)
    }

    func textFieldShouldChangeCharactersIn(textField: UITextField, replacementString string: String) {
        textFieldDelegate?.textFieldShouldChangeCharactersIn(textField: textField, replacementString: string)
    }

    func textFieldShouldEndEditing(textField: UITextField, replacementString: String) {
        guard let textField = textField as? BillingFormTextField else { return }
        textFieldDelegate?.textFieldShouldEndEditing(textField: textField, replacementString: replacementString)
    }

    func textFieldShouldBeginEditing(textField: UITextField) {
        self.focusedTextField = textField
    }

    func textFieldShouldReturn() {
        view.endEditing(true)
    }

}

// MARK: - Header Cell Delegate

extension BillingFormViewController: BillingFormHeaderCellDelegate {

    func doneButtonIsPressed() {
        delegate?.doneButtonIsPressed(sender: self)
    }

    func cancelButtonIsPressed() {
        delegate?.cancelButtonIsPressed(sender: self)
    }
}

extension BillingFormViewController: CellButtonDelegate {
    func buttonIsPressed(tag: Int) {
        let countryViewController = CountrySelectionViewController()
        countryViewController.delegate = self
        countryViewController.view.tag = tag
        navigationController?.pushViewController(countryViewController, animated: true)
    }
}

extension BillingFormViewController: CountrySelectionViewControllerDelegate {
    func onCountrySelected(country: Country, tag: Int) {
        delegate?.update(country: country, tag: tag)
    }
}

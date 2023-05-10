import Checkout
import UIKit

protocol BillingFormTableViewDelegate: AnyObject {
    func tableView(numberOfRowsInSection section: Int) -> Int
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    func tableView(tableView: UITableView, cellForRowAt indexPath: IndexPath, sender: UIViewController) -> UITableViewCell
    func tableView(estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
}

protocol BillingFormTextFieldDelegate: AnyObject {
    func textFieldShouldEndEditing(textField: BillingFormTextField, replacementString: String) -> Bool
    func textFieldShouldChangeCharactersIn(textField: UITextField, replacementString string: String)
}

protocol BillingFormViewControllerDelegate: AnyObject {
    func doneButtonIsPressed(sender: UIViewController)
    func cancelButtonIsPressed(sender: UIViewController)
    func update(country: Country)
    func textFieldDidEndEditing(tag: Int)
}

/**
 This final class is for billing form list that allow user to fill required fields
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
    private(set) lazy var cancelItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: viewModel.style.header.cancelButton.text,
                         style: .plain,
                         target: self,
                         action: #selector(cancelButtonIsPressed))
        return item
    }()

    private(set) lazy var doneItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: viewModel.style.header.doneButton.text,
                         style: .done,
                         target: self,
                         action: #selector(doneButtonIsPressed))
       return item
    }()

    private lazy var headerView: UIView = {
        let view = BillingFormHeaderView(style: viewModel.style.header)
        view.update(style: viewModel.style.header)
        return view
    }()

    private(set) lazy var tableView: UITableView? = {
        let view = UITableView(frame: .zero, style: .grouped).disabledAutoresizingIntoConstraints()
        view.dataSource = self
        view.delegate = self
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 700
        view.sectionHeaderHeight = UITableView.automaticDimension
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.allowsSelection = false
        view.backgroundColor = .clear
        view.keyboardDismissMode = .onDrag
        view.register(BillingFormCellTextField.self)
        view.register(SelectionButtonTableViewCell.self)
        return view
    }()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()

        view.backgroundColor = viewModel.style.mainBackground
        setupViewsInOrder()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpKeyboard()
        viewModel.viewControllerWillAppear()
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
        tableView?.register(BillingFormCellTextField.self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViewModel() {
        delegate = viewModel as? BillingFormViewControllerDelegate
        tableViewDelegate = viewModel as? BillingFormTableViewDelegate
        textFieldDelegate = viewModel as? BillingFormTextFieldDelegate
        viewModel.updateRows = { [weak self] rows in
            DispatchQueue.main.async {
                self?.refreshCells(at: rows)
            }
        }
    }

    private func refreshCells(at rows: [Int]) {
        let indexPaths = rows.map { IndexPath(row: $0, section: 0) }
        tableView?.reloadRows(at: indexPaths, with: .automatic)
    }

    // MARK: - Keyboard

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

    @objc func cancelButtonIsPressed() {
        delegate?.cancelButtonIsPressed(sender: self)
    }

    @objc func doneButtonIsPressed() {
        delegate?.doneButtonIsPressed(sender: self)
    }
}

// MARK: - Views Layout Constraint

extension BillingFormViewController {
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = cancelItem
        navigationItem.rightBarButtonItem = doneItem
        navigationController?.isNavigationBarHidden = false
    }

    private func setupViewsInOrder() {
        setupTableView()
    }

    private func setupTableView() {
        guard let tableView = tableView else { return }
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.Padding.l.rawValue),
            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Constants.Padding.l.rawValue),
            tableView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: Constants.Padding.l.rawValue)
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

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerView
    }
}

// MARK: - Text Field Delegate

extension BillingFormViewController: CellTextFieldDelegate {
    func textFieldDidEndEditing(tag: Int) {
        delegate?.textFieldDidEndEditing(tag: tag)
    }

    func textFieldShouldChangeCharactersIn(textField: UITextField, replacementString string: String) {
        textFieldDelegate?.textFieldShouldChangeCharactersIn(textField: textField, replacementString: string)
    }

    func textFieldShouldEndEditing(textField: UITextField, replacementString: String) -> Bool {
        guard let textField = textField as? BillingFormTextField else { return true }
        return textFieldDelegate?.textFieldShouldEndEditing(textField: textField, replacementString: replacementString) ?? true
    }

    func textFieldShouldBeginEditing(textField: UITextField) {
        self.focusedTextField = textField
    }

    func textFieldShouldReturn() -> Bool {
        view.endEditing(true)
        return false
    }

}

extension BillingFormViewController: SelectionButtonTableViewCellDelegate {
    func selectionButtonIsPressed(tag: Int) {
        let countryViewController = CountrySelectionViewController()
        countryViewController.delegate = self
        countryViewController.view.tag = tag
        navigationController?.pushViewController(countryViewController, animated: true)
    }
}

extension BillingFormViewController: CountrySelectionViewControllerDelegate {
    func onCountrySelected(country: Country) {
        delegate?.update(country: country)
    }
}

extension BillingFormViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let contentOffsetY = scrollView.contentOffset.y + scrollView.adjustedContentInset.top

    if headerView.frame.maxY > 0, contentOffsetY > headerView.frame.maxY / 2 {
      title = viewModel.style.header.headerLabel.text
    } else {
      title = nil
    }
  }
}
extension BillingFormViewController: BillingFormViewModelEditingDelegate {
    func didFinishEditingBillingForm(successfully: Bool) {
        doneItem.isEnabled = successfully
        doneItem.tintColor = successfully ? navigationController?.navigationBar.tintColor : viewModel.style.header.doneButton.disabledTextColor
    }
}

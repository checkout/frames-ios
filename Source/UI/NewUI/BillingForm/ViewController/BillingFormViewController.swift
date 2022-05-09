import UIKit

protocol BillingFormViewControllerdelegate: AnyObject {
    func doneButtonIsPressed(sender: UIViewController)
    func cancelButtonIsPressed(sender: UIViewController)
    func tableView(numberOfRowsInSection section: Int) -> Int
    func getViewForHeader(sender: UIViewController) -> UIView?
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    func tableView(tableView: UITableView, cellForRowAt indexPath: IndexPath, sender: UIViewController) -> UITableViewCell
    func tableView(estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    func validate(textField: BillingFormTextField)
    func textFieldShouldEndEditing(textField: BillingFormTextField, replacementString: String)
}

final class BillingFormViewController: UIViewController {
    weak var delegate: BillingFormViewControllerdelegate?

    fileprivate var focusedTextField: UITextField?
    private var viewModel: BillingFormViewModel
    private var notificationCenter = NotificationCenter.default

    private lazy var headerView: UIView = {
        let view = delegate?.getViewForHeader(sender: self)
        view?.translatesAutoresizingMaskIntoConstraints = false
        return view ?? UIView()
    }()
    
    private lazy var tableView: UITableView = {
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
        view.register(BillingFormTextFieldCell.self, forCellReuseIdentifier: "BillingFormTextFieldCellId")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  viewModel.style.mainBackground
        setupHeaderView()
        setupTableView()
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
    
    init(viewModel: BillingFormViewModel) {
        self.viewModel = viewModel
        self.delegate = viewModel as? BillingFormViewControllerdelegate
        super.init(nibName: nil, bundle: nil)
        self.setupViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        scrollViewOnKeyboardWillShow(notification: notification,
                                     scrollView: tableView as UIScrollView,
                                          activeField: focusedTextField)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        tableView.setBottomInset(to: 0.0)
        self.focusedTextField = nil
    }
}

// setup views
extension BillingFormViewController {
    
    private func setupHeaderView(){
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
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: headerView.safeBottomAnchor,
                constant: 0),
            tableView.leadingAnchor.constraint(
                equalTo: view.safeLeadingAnchor,
                constant: 20),
            tableView.trailingAnchor.constraint(
                equalTo: view.safeTrailingAnchor,
                constant: -20),
            tableView.bottomAnchor.constraint(
                equalTo: view.safeBottomAnchor,
                constant: 20)
        ])
    }
    
    private func setUpKeyboard() {
        registerKeyboardHandlers(notificationCenter: notificationCenter,
                                      keyboardWillShow: #selector(keyboardWillShow),
                                      keyboardWillHide: #selector(keyboardWillHide))
    }
}

// UITableViewDataSource
extension BillingFormViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        delegate?.tableView(numberOfRowsInSection: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        delegate?.tableView(tableView: tableView, cellForRowAt: indexPath, sender: self) ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        delegate?.tableView(estimatedHeightForRowAt: indexPath) ?? 0.0
    }
}

//FormCellDelegate
extension BillingFormViewController: BillingFormTextFieldCellDelegate {
    func textFieldShouldEndEditing(textField: UITextField, replacementString: String) {
        guard let textField = textField as? BillingFormTextField else { return }
        delegate?.textFieldShouldEndEditing(textField: textField, replacementString: replacementString)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) {
        self.focusedTextField = textField
    }
    
    func textFieldShouldReturn() {
        view.endEditing(true)
    }
}

//FormHeaderCellDelegate
extension BillingFormViewController: BillingFormHeaderCellDelegate {
    
    func doneButtonIsPressed() {
        delegate?.doneButtonIsPressed(sender: self)
    }
    
    func cancelButtonIsPressed() {
        delegate?.cancelButtonIsPressed(sender: self)
    }
}

// ViewModel
extension BillingFormViewController {
    private func setupViewModel() {
        viewModel.updateRow = {
            DispatchQueue.main.async { [weak self] in
                guard let row = self?.viewModel.updatedRow else { return }
                let indexPath = IndexPath(row: row, section: 0)
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
           
        }
    }
}
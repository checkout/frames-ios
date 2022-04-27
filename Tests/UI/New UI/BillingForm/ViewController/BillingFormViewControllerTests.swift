import XCTest
@testable import Frames

class BillingFormViewControllerTests: XCTestCase {
    var billingFormViewController: BillingFormViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let style = DefaultBillingFormStyle()
        let viewModel = DefaultBillingFormViewModel(style: style)
        billingFormViewController = BillingFormViewController(viewModel: viewModel)
        let navigation = UINavigationController()
        navigation.viewControllers = [billingFormViewController]
    }
    
    func testInitialization() {
        billingFormViewController.viewDidLoad()
        billingFormViewController.viewDidLayoutSubviews()
        XCTAssertEqual(billingFormViewController.view.subviews.count, 1)
        XCTAssertTrue(billingFormViewController.view.subviews.first is UITableView)
    }
    
    func testCallDelegateMethodOnTapDoneButton() {
        let delegate = BillingFormViewControllerMockDelegate()
        billingFormViewController.viewDidLoad()
        billingFormViewController.delegate = delegate

        billingFormViewController.doneButtonIsPressed()
        XCTAssertEqual(delegate.doneButtonIsPressedCalledTimes, 1)
        XCTAssertEqual(delegate.doneButtonIsPressedLastCalledWithSender, billingFormViewController)
    }
    
    func testCallDelegateMethodOnTapCancelButton() {
        let delegate = BillingFormViewControllerMockDelegate()
        billingFormViewController.viewDidLoad()
        billingFormViewController.delegate = delegate

        billingFormViewController.cancelButtonIsPressed()
        XCTAssertEqual(delegate.cancelButtonIsPressedCalledTimes, 1)
        XCTAssertEqual(delegate.cancelButtonIsPressedLastCalledWithSender, billingFormViewController)
    }
    
    func testCallDelegateMethodTableViewCellForRow() {
        let delegate = BillingFormViewControllerMockDelegate()
        billingFormViewController.viewDidLoad()
        billingFormViewController.delegate = delegate
        
        let indexthPath = IndexPath(row: 2, section: 2)
        let cell = billingFormViewController.tableView(UITableView(), cellForRowAt: indexthPath)
        
        XCTAssertNotNil(cell)
        XCTAssertEqual(delegate.cellForRowAtCalledTimes, 1)
        XCTAssertEqual(delegate.cellForRowAtLastCalledWithSender, billingFormViewController)
        XCTAssertEqual(delegate.cellForRowAtLastCalledWithIndexPath, indexthPath)
    }
    
    func testCallDelegateMethodTableViewNumberOfRowsInSection() {
        let delegate = BillingFormViewControllerMockDelegate()
        billingFormViewController.viewDidLoad()
        billingFormViewController.delegate = delegate
        
        let section = 0
        let cell = billingFormViewController.tableView(UITableView(), numberOfRowsInSection: section)
        
        XCTAssertNotNil(cell)
        XCTAssertEqual(delegate.numberOfRowsInSectionCalledTimes, 1)
        XCTAssertEqual(delegate.numberOfRowsInSectionLastCalledWithSection, section)
    }
    
    func testCallDelegateMethodTableViewEstimatedHeightForRow() {
        let delegate = BillingFormViewControllerMockDelegate()
        billingFormViewController.viewDidLoad()
        billingFormViewController.delegate = delegate
        
        let indexthPath = IndexPath(row: 2, section: 2)
        let cell = billingFormViewController.tableView(UITableView(), estimatedHeightForRowAt: indexthPath)
        
        XCTAssertNotNil(cell)
        XCTAssertEqual(delegate.estimatedHeightForRowCalledTimes, 1)
        XCTAssertEqual(delegate.estimatedHeightForRowLastCalledWithIndexPath, indexthPath)
    }
    
    func testCallDelegateMethodValidate() {
        let delegate = BillingFormViewControllerMockDelegate()
        billingFormViewController.viewDidLoad()
        billingFormViewController.delegate = delegate
        
        let textfield = BillingFormTextField(type: .fullName)
        
        billingFormViewController.textFieldDidEndEditing(textField: textfield)
        
        XCTAssertEqual(delegate.validateCalledTimes, 1)
        XCTAssertEqual(delegate.validateLastCalledWithBillingFormTextField, textfield)
    }
    
    func testCallDelegateMethodTextFieldIsChanged() {
        let delegate = BillingFormViewControllerMockDelegate()
        billingFormViewController.viewDidLoad()
        billingFormViewController.delegate = delegate
        
        let textfield = BillingFormTextField(type: .fullName)
        let text = "Test"
        billingFormViewController.textFieldDidChangeCharacters(textField: textfield, replacementString: text)
        
        XCTAssertEqual(delegate.textFieldIsChangedCalledTimes, 1)
        XCTAssertEqual(delegate.textFieldIsChangedLastCalledWithReplacementString, text)
        XCTAssertEqual(delegate.textFieldIsChangedLastCalledWithBillingFormTextField, textfield)
    }
}

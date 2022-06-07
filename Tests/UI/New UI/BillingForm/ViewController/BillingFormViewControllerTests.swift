import XCTest
@testable import Frames

class BillingFormViewControllerTests: XCTestCase {
    var billingFormViewController: BillingFormViewController!

    override func setUp() {
        super.setUp()
        UIFont.loadAllCheckoutFonts
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let style = DefaultBillingFormStyle()
        let viewModel = DefaultBillingFormViewModel(style: style, data: nil)
        billingFormViewController = BillingFormViewController(viewModel: viewModel)
        let navigation = UINavigationController()
        navigation.viewControllers = [billingFormViewController]
    }

    func testInitialization() {
        billingFormViewController.viewDidLoad()
        billingFormViewController.viewDidLayoutSubviews()
        XCTAssertEqual(billingFormViewController.view.subviews.count, 2)
        XCTAssertTrue(billingFormViewController.view.subviews.first is BillingFormHeaderCell)
        XCTAssertTrue(billingFormViewController.view.subviews.last is UITableView)
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
        let delegate = BillingFormTableViewMockDelegate()
        billingFormViewController.viewDidLoad()
        billingFormViewController.tableViewDelegate = delegate

        let indexPath = IndexPath(row: 2, section: 2)
        let cell = billingFormViewController.tableView(billingFormViewController.tableView!, cellForRowAt: indexPath)

        XCTAssertNotNil(cell)
        XCTAssertEqual(delegate.cellForRowAtCalledTimes, 1)
        XCTAssertEqual(delegate.cellForRowAtLastCalledWithSender, billingFormViewController)
        XCTAssertEqual(delegate.cellForRowAtLastCalledWithIndexPath, indexPath)
    }

    func testCallDelegateMethodTableViewNumberOfRowsInSection() {
        let delegate = BillingFormTableViewMockDelegate()
        billingFormViewController.viewDidLoad()
        billingFormViewController.tableViewDelegate = delegate

        let section = 0
        let cell = billingFormViewController.tableView(UITableView(), numberOfRowsInSection: section)

        XCTAssertNotNil(cell)
        XCTAssertEqual(delegate.numberOfRowsInSectionCalledTimes, 1)
        XCTAssertEqual(delegate.numberOfRowsInSectionLastCalledWithSection, section)
    }

    func testCallDelegateMethodTableViewEstimatedHeightForRow() {
        let delegate = BillingFormTableViewMockDelegate()
        billingFormViewController.viewDidLoad()
        billingFormViewController.tableViewDelegate = delegate

        let indexthPath = IndexPath(row: 2, section: 2)
        let cell = billingFormViewController.tableView(UITableView(), estimatedHeightForRowAt: indexthPath)

        XCTAssertNotNil(cell)
        XCTAssertEqual(delegate.estimatedHeightForRowCalledTimes, 1)
        XCTAssertEqual(delegate.estimatedHeightForRowLastCalledWithIndexPath, indexthPath)
    }

}

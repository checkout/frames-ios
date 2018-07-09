import XCTest
@testable import FramesIos

class CvvConfirmationViewControllerTests: XCTestCase {

    var cvvConfirmationViewController: CvvConfirmationViewController!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        cvvConfirmationViewController = CvvConfirmationViewController()
        cvvConfirmationViewController.viewDidLoad()
    }

    func testInitialization() {
        /// Empty constructor
        let cvvConfirmationViewController = CvvConfirmationViewController()
        cvvConfirmationViewController.viewDidLoad()
        XCTAssertEqual(cvvConfirmationViewController.view.subviews.count, 1)
    }

    func testCallDelegateOnConfirmCvv() {
        let delegate = CvvViewControllerDelegateMock()
        cvvConfirmationViewController.delegate = delegate
        cvvConfirmationViewController.textField.text = "100"
        cvvConfirmationViewController.onConfirmCvv()
        XCTAssertEqual(delegate.onConfirmCalledTimes, 1)
        XCTAssertEqual(delegate.onConfirmLastCalledWith?.0, cvvConfirmationViewController)
        XCTAssertEqual(delegate.onConfirmLastCalledWith?.1, "100")
    }

    func testCallDelegateOnCancel() {
        let delegate = CvvViewControllerDelegateMock()
        cvvConfirmationViewController.delegate = delegate
        cvvConfirmationViewController.onCancel()
        XCTAssertEqual(delegate.onCancelCalledTimes, 1)
        XCTAssertEqual(delegate.onCancelLastCalledWith, cvvConfirmationViewController)
    }
}

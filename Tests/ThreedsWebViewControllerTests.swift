import XCTest
import WebKit
@testable import FramesIos

class ThreedsWebViewControllerMockDelegate: ThreedsWebViewControllerDelegate {

    var onSuccess3DCalledTimes = 0
    var onFailure3DCalledTimes = 0

    func onSuccess3D() {
        onSuccess3DCalledTimes += 1
    }

    func onFailure3D() {
        onFailure3DCalledTimes += 1
    }
}

class ThreedsWebViewControllerForDismiss: ThreedsWebViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        completion?()
    }
}

class ThreedsWebViewControllerTests: XCTestCase {

    var threedsWebViewController: ThreedsWebViewController!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let successUrl = "https://www.successurl.com/"
        let failUrl = "https://www.failurl.com/"
        threedsWebViewController = ThreedsWebViewController(successUrl: successUrl, failUrl: failUrl)
        let window = UIWindow()
        window.rootViewController = threedsWebViewController
    }

    func loadUrl(url: String) {
        threedsWebViewController.url = url
        threedsWebViewController.loadView()
        threedsWebViewController.viewDidLoad()
    }

    func addAsModal(viewController: ThreedsWebViewController) {
        let viewController = UIViewController()
        let window = UIWindow()
        window.rootViewController = viewController
        viewController.present(threedsWebViewController, animated: false, completion: nil)
    }

    func testInitialization() {
        /// Empty constructor
        let threedsWebViewController = ThreedsWebViewController()
        XCTAssertEqual(threedsWebViewController.successUrl, "")
        XCTAssertEqual(threedsWebViewController.failUrl, "")
    }

    func testInitializationWithUrls() {
        let successUrl = "https://www.successurl.com/"
        let failUrl = "https://www.failurl.com/"
        let threedsWebViewController = ThreedsWebViewController(successUrl: successUrl, failUrl: failUrl)
        XCTAssertEqual(threedsWebViewController.successUrl, successUrl)
        XCTAssertEqual(threedsWebViewController.failUrl, failUrl)
    }

    func testInitializationNibBundle() {
        let threedsWebViewController = ThreedsWebViewController(nibName: nil, bundle: nil)
        XCTAssertEqual(threedsWebViewController.successUrl, "")
        XCTAssertEqual(threedsWebViewController.failUrl, "")
    }

    func testInitializationCoder() {
        let coder = NSKeyedUnarchiver(forReadingWith: Data())
        let threedsWebViewController = ThreedsWebViewController(coder: coder)
        XCTAssertEqual(threedsWebViewController?.successUrl, "")
        XCTAssertEqual(threedsWebViewController?.failUrl, "")
    }

    func testLoadView() {
        threedsWebViewController.loadView()
        let view = threedsWebViewController.view as? WKWebView
        XCTAssertNotNil(view)
    }

    func testViewDidLoadTheUrl() {
        let url = "https://example.com/"
        threedsWebViewController.url = url
        threedsWebViewController.loadView()
        threedsWebViewController.viewDidLoad()
        XCTAssertEqual(threedsWebViewController.webView.url?.absoluteString, url)
    }

//    func testDismissIfSuccessUrl() {
//        addAsModal(viewController: threedsWebViewController)
//        let delegate = ThreedsWebViewControllerMockDelegate()
//        threedsWebViewController.delegate = delegate
//        loadUrl(url: "https://www.successurl.com")
//        threedsWebViewController.webView.navigationDelegate?.webView!(threedsWebViewController.webView,
//          didCommit: WKNavigation())
//        XCTAssertEqual(delegate.onSuccess3DCalledTimes, 1)
//    }
//
//    func testDismissIfFailUrl() {
//
//    }

}

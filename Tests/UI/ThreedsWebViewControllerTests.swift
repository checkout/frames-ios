import XCTest
import WebKit
@testable import Frames

class ThreedsWebViewControllerMockDelegate: ThreedsWebViewControllerDelegate {

    private(set) var onSuccess3DCalledTimes = 0

    func onSuccess3D() {
        onSuccess3DCalledTimes += 1
    }

    private(set) var onFailure3DCalledTimes = 0

    func onFailure3D() {
        onFailure3DCalledTimes += 1
    }

    private(set) var threeDSWebViewControllerAuthenticationDidSucceedCalledWith: [(ThreedsWebViewController, token: String?)] = []

    func threeDSWebViewControllerAuthenticationDidSucceed(_ threeDSWebViewController: ThreedsWebViewController, token: String?) {
        threeDSWebViewControllerAuthenticationDidSucceedCalledWith.append((threeDSWebViewController, token))
    }

    private(set) var threeDSWebViewControllerAuthenticationDidFailCalledWith: [ThreedsWebViewController] = []

    func threeDSWebViewControllerAuthenticationDidFail(_ threeDSWebViewController: ThreedsWebViewController) {
        threeDSWebViewControllerAuthenticationDidFailCalledWith.append(threeDSWebViewController)
    }
}

class WKNavigationMock: WKNavigation {}

class ThreedsWebViewControllerForDismiss: ThreedsWebViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        completion?()
    }
}

class ThreedsWebViewControllerTests: XCTestCase {

    var threedsWebViewController: ThreedsWebViewController!
    let navigation = WKNavigationMock()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let successUrl = "https://www.successurl.com/"
        let failUrl = "https://www.failurl.com/"
        threedsWebViewController = ThreedsWebViewControllerForDismiss(successUrl: successUrl, failUrl: failUrl)
        let window = UIWindow()
        window.rootViewController = threedsWebViewController
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

    func testDismissIfSuccessUrl() {
        let delegate = ThreedsWebViewControllerMockDelegate()
        threedsWebViewController.delegate = delegate
        threedsWebViewController.loadViewIfNeeded()

        let request = URLRequest(url: URL(string: "https://www.successurl.com/")!)
        threedsWebViewController.webView.load(request)
        threedsWebViewController.webView(threedsWebViewController.webView, didCommit: navigation)

        XCTAssertEqual(delegate.onSuccess3DCalledTimes, 1)
        XCTAssertEqual(delegate.threeDSWebViewControllerAuthenticationDidSucceedCalledWith.count, 1)

        XCTAssertEqual(delegate.onFailure3DCalledTimes, 0)
        XCTAssertEqual(delegate.threeDSWebViewControllerAuthenticationDidFailCalledWith.count, 0)

        XCTAssertEqual(delegate.threeDSWebViewControllerAuthenticationDidSucceedCalledWith.first?.0, threedsWebViewController)
        XCTAssertEqual(delegate.threeDSWebViewControllerAuthenticationDidSucceedCalledWith.first?.token, nil)
    }

    func testDismissIfSuccessUrl_tokenPresent_ckopaymenttoken() {
        let delegate = ThreedsWebViewControllerMockDelegate()
        threedsWebViewController.delegate = delegate
        threedsWebViewController.loadViewIfNeeded()

        let request = URLRequest(url: URL(string: "https://www.successurl.com/?cko-payment-token=testValue")!)
        threedsWebViewController.webView.load(request)
        threedsWebViewController.webView(threedsWebViewController.webView, didCommit: navigation)

        XCTAssertEqual(delegate.onSuccess3DCalledTimes, 1)
        XCTAssertEqual(delegate.threeDSWebViewControllerAuthenticationDidSucceedCalledWith.count, 1)

        XCTAssertEqual(delegate.onFailure3DCalledTimes, 0)
        XCTAssertEqual(delegate.threeDSWebViewControllerAuthenticationDidFailCalledWith.count, 0)

        XCTAssertEqual(delegate.threeDSWebViewControllerAuthenticationDidSucceedCalledWith.first?.0, threedsWebViewController)
        XCTAssertEqual(delegate.threeDSWebViewControllerAuthenticationDidSucceedCalledWith.first?.token, "testValue")
    }

    func testDismissIfSuccessUrl_tokenPresent_ckosessionid() {
        let delegate = ThreedsWebViewControllerMockDelegate()
        threedsWebViewController.delegate = delegate
        threedsWebViewController.loadViewIfNeeded()

        let request = URLRequest(url: URL(string: "https://www.successurl.com/?cko-session-id=testValue")!)
        threedsWebViewController.webView.load(request)
        threedsWebViewController.webView(threedsWebViewController.webView, didCommit: navigation)

        XCTAssertEqual(delegate.onSuccess3DCalledTimes, 1)
        XCTAssertEqual(delegate.threeDSWebViewControllerAuthenticationDidSucceedCalledWith.count, 1)

        XCTAssertEqual(delegate.onFailure3DCalledTimes, 0)
        XCTAssertEqual(delegate.threeDSWebViewControllerAuthenticationDidFailCalledWith.count, 0)

        XCTAssertEqual(delegate.threeDSWebViewControllerAuthenticationDidSucceedCalledWith.first?.0, threedsWebViewController)
        XCTAssertEqual(delegate.threeDSWebViewControllerAuthenticationDidSucceedCalledWith.first?.token, "testValue")
    }

    func testDismissIfSuccessUrl_tokenPresent_ckopaymenttoken_hasPriority() {
        let delegate = ThreedsWebViewControllerMockDelegate()
        threedsWebViewController.delegate = delegate
        threedsWebViewController.loadViewIfNeeded()

        let request = URLRequest(url: URL(string: "https://www.successurl.com/?cko-payment-token=testValue&cko-session-id=wrongValue")!)
        threedsWebViewController.webView.load(request)
        threedsWebViewController.webView(threedsWebViewController.webView, didCommit: navigation)

        XCTAssertEqual(delegate.onSuccess3DCalledTimes, 1)
        XCTAssertEqual(delegate.threeDSWebViewControllerAuthenticationDidSucceedCalledWith.count, 1)

        XCTAssertEqual(delegate.onFailure3DCalledTimes, 0)
        XCTAssertEqual(delegate.threeDSWebViewControllerAuthenticationDidFailCalledWith.count, 0)

        XCTAssertEqual(delegate.threeDSWebViewControllerAuthenticationDidSucceedCalledWith.first?.0, threedsWebViewController)
        XCTAssertEqual(delegate.threeDSWebViewControllerAuthenticationDidSucceedCalledWith.first?.token, "testValue")
    }

    func testDismissIfFailureUrl() {
        let delegate = ThreedsWebViewControllerMockDelegate()
        threedsWebViewController.delegate = delegate
        threedsWebViewController.loadViewIfNeeded()

        let request = URLRequest(url: URL(string: "https://www.failurl.com/")!)
        threedsWebViewController.webView.load(request)
        threedsWebViewController.webView(threedsWebViewController.webView, didCommit: navigation)

        XCTAssertEqual(delegate.onSuccess3DCalledTimes, 0)
        XCTAssertEqual(delegate.threeDSWebViewControllerAuthenticationDidSucceedCalledWith.count, 0)

        XCTAssertEqual(delegate.onFailure3DCalledTimes, 1)
        XCTAssertEqual(delegate.threeDSWebViewControllerAuthenticationDidFailCalledWith.count, 1)

        XCTAssertEqual(delegate.threeDSWebViewControllerAuthenticationDidFailCalledWith.first, threedsWebViewController)
    }
}

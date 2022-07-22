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

class WKNavigationActionMock: WKNavigationAction {

    var requestToReturn = URLRequest(url: URL(staticString: "https://www.example.com"))

    override var request: URLRequest { requestToReturn }
}

class ThreedsWebViewControllerForDismiss: ThreedsWebViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        completion?()
    }
}

class URLHelperMock: URLHelping {

    private(set) var urlsMatchCalledWith: [(redirectUrl: URL, matchingUrl: URL)] = []
    var urlsMatchToReturn: [URL: [URL: Bool]] = [:]

    func urlsMatch(redirectUrl: URL, matchingUrl: URL) -> Bool {

        urlsMatchCalledWith.append((redirectUrl, matchingUrl))
        return urlsMatchToReturn[redirectUrl]?[matchingUrl] ?? false
    }

    private(set) var extractTokenCalledWith: [URL] = []
    var extractTokenToReturn: String?

    func extractToken(from url: URL) -> String? {

        extractTokenCalledWith.append(url)
        return extractTokenToReturn
    }
}

enum TestError: Error {
    case one
}

class ThreedsWebViewControllerTests: XCTestCase {

    var threedsWebViewController: ThreedsWebViewController!
    let navigationAction = WKNavigationActionMock()
    var urlHelper = URLHelperMock()
    var logger: StubFramesEventLogger! = StubFramesEventLogger()

    let successUrl = URL(string: "https://www.successurl.com/")!
    let failUrl = URL(string: "https://www.failurl.com/")!

    override func setUp() {
        super.setUp()

        urlHelper = URLHelperMock()
        threedsWebViewController = ThreedsWebViewControllerForDismiss(successUrl: successUrl, failUrl: failUrl, urlHelper: urlHelper, logger: logger)
        let window = UIWindow()
        window.rootViewController = threedsWebViewController
    }

    override func tearDown() {
        logger = nil

        super.tearDown()
    }

    func testInitialization() {
        /// Empty constructor
        let threedsWebViewController = ThreedsWebViewController()
        XCTAssertEqual(threedsWebViewController.successUrl, nil)
        XCTAssertEqual(threedsWebViewController.failUrl, nil)
    }

    func testInitializationWithUrls() {
        let successUrl =  URL(string: "https://www.successurl.com/")!
        let failUrl =  URL(string: "https://www.failurl.com/")!
        let threedsWebViewController = ThreedsWebViewController(successUrl: successUrl, failUrl: failUrl)
        XCTAssertEqual(threedsWebViewController.successUrl, successUrl)
        XCTAssertEqual(threedsWebViewController.failUrl, failUrl)
    }

    func testInitializationWithStrings() {
        let successUrl =  "https://www.successurl.com/"
        let failUrl =  "https://www.failurl.com/"
        let threedsWebViewController = ThreedsWebViewController(successUrl: successUrl, failUrl: failUrl)
        XCTAssertEqual(threedsWebViewController.successUrl?.absoluteString, successUrl)
        XCTAssertEqual(threedsWebViewController.failUrl?.absoluteString, failUrl)
    }

    func testInitializationNibBundle() {
        let threedsWebViewController = ThreedsWebViewController(nibName: nil, bundle: nil)
        XCTAssertEqual(threedsWebViewController.successUrl, nil)
        XCTAssertEqual(threedsWebViewController.failUrl, nil)
    }

    func testInitializationCoder() {
        let coder = NSKeyedUnarchiver(forReadingWith: Data())
        let threedsWebViewController = ThreedsWebViewController(coder: coder)
        XCTAssertEqual(threedsWebViewController?.successUrl, nil)
        XCTAssertEqual(threedsWebViewController?.failUrl, nil)
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
        XCTAssertEqual(logger.logCalledWithFramesLogEvents, [.threeDSWebviewPresented])
    }

    func testDismissIfSuccessUrl() {
        let delegate = ThreedsWebViewControllerMockDelegate()
        threedsWebViewController.delegate = delegate
        threedsWebViewController.loadViewIfNeeded()

        urlHelper.urlsMatchToReturn = [successUrl: [successUrl: true]]

        navigationAction.requestToReturn = URLRequest(url: URL(staticString: "https://www.successurl.com/"))

        var policy: WKNavigationActionPolicy?
        threedsWebViewController.webView(threedsWebViewController.webView, decidePolicyFor: navigationAction) { policy = $0 }

        XCTAssertEqual(policy, .cancel)

        XCTAssertEqual(delegate.onSuccess3DCalledTimes, 1)
        XCTAssertEqual(delegate.threeDSWebViewControllerAuthenticationDidSucceedCalledWith.count, 1)

        XCTAssertEqual(delegate.onFailure3DCalledTimes, 0)
        XCTAssertEqual(delegate.threeDSWebViewControllerAuthenticationDidFailCalledWith.count, 0)

        XCTAssertEqual(delegate.threeDSWebViewControllerAuthenticationDidSucceedCalledWith.first?.0, threedsWebViewController)
        XCTAssertEqual(delegate.threeDSWebViewControllerAuthenticationDidSucceedCalledWith.first?.token, nil)

        XCTAssertEqual(urlHelper.urlsMatchCalledWith.count, 1)
        XCTAssertEqual(urlHelper.urlsMatchCalledWith.first?.redirectUrl, successUrl)
        XCTAssertEqual(urlHelper.urlsMatchCalledWith.first?.matchingUrl, successUrl)

        XCTAssertEqual(urlHelper.extractTokenCalledWith.count, 1)
        XCTAssertEqual(urlHelper.extractTokenCalledWith.first, successUrl)

        XCTAssertEqual(logger.logCalledWithFramesLogEvents, [.threeDSChallengeComplete(success: true, tokenID: nil)])
    }

    func testDismissIfSuccessUrl_tokenPresent() {
        let delegate = ThreedsWebViewControllerMockDelegate()
        threedsWebViewController.delegate = delegate
        threedsWebViewController.loadViewIfNeeded()

        let urlWithToken = URL(staticString: "https://www.successurl.com/?cko-payment-token=testValue")

        urlHelper.urlsMatchToReturn = [urlWithToken: [successUrl: true]]
        urlHelper.extractTokenToReturn = "testValue"

        navigationAction.requestToReturn = URLRequest(url: urlWithToken)

        var policy: WKNavigationActionPolicy?
        threedsWebViewController.webView(threedsWebViewController.webView, decidePolicyFor: navigationAction) { policy = $0 }

        XCTAssertEqual(policy, .cancel)

        XCTAssertEqual(delegate.onSuccess3DCalledTimes, 1)
        XCTAssertEqual(delegate.threeDSWebViewControllerAuthenticationDidSucceedCalledWith.count, 1)

        XCTAssertEqual(delegate.onFailure3DCalledTimes, 0)
        XCTAssertEqual(delegate.threeDSWebViewControllerAuthenticationDidFailCalledWith.count, 0)

        XCTAssertEqual(delegate.threeDSWebViewControllerAuthenticationDidSucceedCalledWith.first?.0, threedsWebViewController)
        XCTAssertEqual(delegate.threeDSWebViewControllerAuthenticationDidSucceedCalledWith.first?.token, "testValue")

        XCTAssertEqual(urlHelper.urlsMatchCalledWith.count, 1)
        XCTAssertEqual(urlHelper.urlsMatchCalledWith.first?.redirectUrl, urlWithToken)
        XCTAssertEqual(urlHelper.urlsMatchCalledWith.first?.matchingUrl, successUrl)

        XCTAssertEqual(urlHelper.extractTokenCalledWith.count, 1)
        XCTAssertEqual(urlHelper.extractTokenCalledWith.first, urlWithToken)

        XCTAssertEqual(logger.logCalledWithFramesLogEvents, [.threeDSChallengeComplete(success: true, tokenID: "testValue")])
    }

    func testDismissIfFailureUrl() {
        let delegate = ThreedsWebViewControllerMockDelegate()
        threedsWebViewController.delegate = delegate
        threedsWebViewController.loadViewIfNeeded()

        urlHelper.urlsMatchToReturn = [failUrl: [failUrl: true]]

        navigationAction.requestToReturn = URLRequest(url: URL(staticString: "https://www.failurl.com/"))

        var policy: WKNavigationActionPolicy?
        threedsWebViewController.webView(threedsWebViewController.webView, decidePolicyFor: navigationAction) { policy = $0 }

        XCTAssertEqual(policy, .cancel)

        XCTAssertEqual(delegate.onSuccess3DCalledTimes, 0)
        XCTAssertEqual(delegate.threeDSWebViewControllerAuthenticationDidSucceedCalledWith.count, 0)

        XCTAssertEqual(delegate.onFailure3DCalledTimes, 1)
        XCTAssertEqual(delegate.threeDSWebViewControllerAuthenticationDidFailCalledWith.count, 1)

        XCTAssertEqual(delegate.threeDSWebViewControllerAuthenticationDidFailCalledWith.first, threedsWebViewController)

        XCTAssertEqual(urlHelper.urlsMatchCalledWith.count, 2)
        XCTAssertEqual(urlHelper.urlsMatchCalledWith[0].redirectUrl, failUrl)
        XCTAssertEqual(urlHelper.urlsMatchCalledWith[0].matchingUrl, successUrl)
        XCTAssertEqual(urlHelper.urlsMatchCalledWith[1].redirectUrl, failUrl)
        XCTAssertEqual(urlHelper.urlsMatchCalledWith[1].matchingUrl, failUrl)

        XCTAssertEqual(urlHelper.extractTokenCalledWith.count, 0)

        XCTAssertEqual(logger.logCalledWithFramesLogEvents, [.threeDSChallengeComplete(success: false, tokenID: nil)])
    }

    func testNoDismissIfOtherUrl() {
        let delegate = ThreedsWebViewControllerMockDelegate()
        threedsWebViewController.delegate = delegate
        threedsWebViewController.loadViewIfNeeded()

        urlHelper.urlsMatchToReturn = [failUrl: [failUrl: true]]
        let otherUrl =  URL(staticString: "https://www.test.com/")

        navigationAction.requestToReturn = URLRequest(url: otherUrl)

        var policy: WKNavigationActionPolicy?
        threedsWebViewController.webView(threedsWebViewController.webView, decidePolicyFor: navigationAction) { policy = $0 }

        XCTAssertEqual(policy, .allow)

        XCTAssertEqual(delegate.onSuccess3DCalledTimes, 0)
        XCTAssertEqual(delegate.threeDSWebViewControllerAuthenticationDidSucceedCalledWith.count, 0)

        XCTAssertEqual(delegate.onFailure3DCalledTimes, 0)
        XCTAssertEqual(delegate.threeDSWebViewControllerAuthenticationDidFailCalledWith.count, 0)

        XCTAssertEqual(urlHelper.urlsMatchCalledWith.count, 2)
        XCTAssertEqual(urlHelper.urlsMatchCalledWith[0].redirectUrl, otherUrl)
        XCTAssertEqual(urlHelper.urlsMatchCalledWith[0].matchingUrl, successUrl)
        XCTAssertEqual(urlHelper.urlsMatchCalledWith[1].redirectUrl, otherUrl)
        XCTAssertEqual(urlHelper.urlsMatchCalledWith[1].matchingUrl, failUrl)

        XCTAssertEqual(urlHelper.extractTokenCalledWith.count, 0)

        XCTAssertEqual(logger.logCalledWithFramesLogEvents, [])
    }

    func testLocalStorageSessionStoragePresent() {
        let delegate = ThreedsWebViewControllerMockDelegate()
        threedsWebViewController.delegate = delegate
        threedsWebViewController.loadViewIfNeeded()

        XCTAssertFalse(threedsWebViewController.webView.configuration.websiteDataStore.isPersistent)
    }

    func testLogOnLoaded() {
        let url = "https://example.com/"
        threedsWebViewController.url = url
        threedsWebViewController.loadView()
        threedsWebViewController.viewDidLoad()
        XCTAssertEqual(logger.logCalledWithFramesLogEvents, [.threeDSWebviewPresented])
        let navigation = WKNavigation()
        threedsWebViewController.authUrlNavigation = navigation
        threedsWebViewController.webView(threedsWebViewController.webView, didFinish: navigation)
        XCTAssertEqual(logger.logCalledWithFramesLogEvents, [.threeDSWebviewPresented, .threeDSChallengeLoaded(success: true)])
    }

    func testLogOnLoadFailed() {
        let url = "https://example.com/"
        threedsWebViewController.url = url
        threedsWebViewController.loadView()
        threedsWebViewController.viewDidLoad()
        XCTAssertEqual(logger.logCalledWithFramesLogEvents, [.threeDSWebviewPresented])
        let navigation = WKNavigation()
        threedsWebViewController.authUrlNavigation = navigation
        threedsWebViewController.webView(threedsWebViewController.webView, didFail: navigation, withError: TestError.one)
        XCTAssertEqual(logger.logCalledWithFramesLogEvents, [.threeDSWebviewPresented, .threeDSChallengeLoaded(success: false)])
    }
}

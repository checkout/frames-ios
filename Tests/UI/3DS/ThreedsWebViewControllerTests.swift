import XCTest
import WebKit
@testable import Frames
@testable import Checkout

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
    convenience init(
        checkoutAPIProtocol checkoutAPIService: Frames.CheckoutAPIProtocol,
        successUrl: URL,
        failUrl: URL,
        threeDSWKNavigationHelperFactory: ThreeDSWKNavigationHelperFactoryProtocol
    ) {
        let threeDSWKNavigationHelper = threeDSWKNavigationHelperFactory.build(successURL: successUrl, failureURL: failUrl)
        self.init(threeDSWKNavigationHelper: threeDSWKNavigationHelper, logger: checkoutAPIService.logger)
    }

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
    private var checkoutAPIService: StubCheckoutAPIService! = StubCheckoutAPIService()
    private var mockThreeDSWKNavigationHelperFactory: MockThreeDSWKNavigationHelperFactory! = MockThreeDSWKNavigationHelperFactory()

    let successUrl = URL(string: "https://www.successurl.com/")!
    let failUrl = URL(string: "https://www.failurl.com/")!

    override func setUp() {
        super.setUp()

        urlHelper = URLHelperMock()

        threedsWebViewController = ThreedsWebViewControllerForDismiss(checkoutAPIProtocol: checkoutAPIService, successUrl: successUrl, failUrl: failUrl, threeDSWKNavigationHelperFactory: mockThreeDSWKNavigationHelperFactory)
        let window = UIWindow()
        window.rootViewController = threedsWebViewController
    }

    override func tearDown() {
        checkoutAPIService = nil
        mockThreeDSWKNavigationHelperFactory = nil

        super.tearDown()
    }

    func testInitialization() {
        /// Empty constructor
        let threedsWebViewController = ThreedsWebViewController()
        XCTAssertNotNil(threedsWebViewController)
    }

    func testInitializationWithUrls() {
        let successUrl =  URL(string: "https://www.successurl.com/")!
        let failUrl =  URL(string: "https://www.failurl.com/")!
        _ = ThreedsWebViewController(environment: .sandbox, successUrl: successUrl, failUrl: failUrl)
    }

    func testInitializationNibBundle() {
        _ = ThreedsWebViewController(nibName: nil, bundle: nil)
    }

    func testLoadView() {
        threedsWebViewController.loadView()
        let view = threedsWebViewController.view as? WKWebView
        XCTAssertNotNil(view)
    }

    func testViewDidLoadTheUrl() {
        guard let logger = checkoutAPIService.logger as? StubFramesEventLogger else {
            XCTFail("logger was not mocked")
            return
        }

        let url = URL(string: "https://example.com/")
        threedsWebViewController.authURL = url
        threedsWebViewController.loadView()
        threedsWebViewController.viewDidLoad()
        XCTAssertEqual(threedsWebViewController.webView.url, url)
        XCTAssertEqual(logger.logCalledWithFramesLogEvents, [.threeDSWebviewPresented])
    }

    func testLocalStorageSessionStoragePresent() {
        let delegate = ThreedsWebViewControllerMockDelegate()
        threedsWebViewController.delegate = delegate
        threedsWebViewController.loadViewIfNeeded()

        XCTAssertFalse(threedsWebViewController.webView.configuration.websiteDataStore.isPersistent)
    }

    func testLogOnLoaded() {
        guard let logger = checkoutAPIService.logger as? StubFramesEventLogger else {
            XCTFail("logger was not mocked")
            return
        }

        let url = URL(string: "https://example.com/")
        threedsWebViewController.authURL = url
        threedsWebViewController.loadView()
        threedsWebViewController.viewDidLoad()
        XCTAssertEqual(logger.logCalledWithFramesLogEvents, [.threeDSWebviewPresented])
        let navigation = WKNavigation()
        threedsWebViewController.authUrlNavigation = navigation

        mockThreeDSWKNavigationHelperFactory.buildToReturn.delegate?.didFinishLoading(navigation: navigation, success: true)
        XCTAssertEqual(logger.logCalledWithFramesLogEvents, [.threeDSWebviewPresented, .threeDSChallengeLoaded(success: true)])
    }

    func testLogOnLoadFailed() {
        guard let logger = checkoutAPIService.logger as? StubFramesEventLogger else {
            XCTFail("logger was not mocked")
            return
        }

        let url = URL(string: "https://example.com/")
        threedsWebViewController.authURL = url
        threedsWebViewController.loadView()
        threedsWebViewController.viewDidLoad()
        XCTAssertEqual(logger.logCalledWithFramesLogEvents, [.threeDSWebviewPresented])
        let navigation = WKNavigation()
        threedsWebViewController.authUrlNavigation = navigation
        mockThreeDSWKNavigationHelperFactory.buildToReturn.delegate?.didFinishLoading(navigation: navigation, success: false)
        XCTAssertEqual(logger.logCalledWithFramesLogEvents, [.threeDSWebviewPresented, .threeDSChallengeLoaded(success: false)])
    }
}

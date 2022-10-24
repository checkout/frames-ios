import UIKit
import WebKit
import Checkout
import CheckoutEventLoggerKit

/// A view controller to manage 3ds
public class ThreedsWebViewController: UIViewController {

    // MARK: - Properties

    let webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.websiteDataStore = .nonPersistent()
        return WKWebView(frame: .zero, configuration: webConfiguration)
    }()

    /// Delegate
    public weak var delegate: ThreedsWebViewControllerDelegate?

    /// Authentication URL
    public var authURL: URL?

    private let threeDSWKNavigationHelper: ThreeDSWKNavigationHelping?
    private let logger: FramesEventLogging?

    private var webViewPresented = false
    var authUrlNavigation: WKNavigation?

    // MARK: - Initialization

    /// Initializes a web view controller adapted to handle 3dsecure.
    public convenience init(environment: Environment, successUrl: URL, failUrl: URL) {
        let logger = FramesEventLogger(environment: environment, correlationID: UUID().uuidString)
        let threeDSWKNavigationHelper = ThreeDSWKNavigationHelperFactory().build(successURL: successUrl, failureURL: failUrl)

        self.init(threeDSWKNavigationHelper: threeDSWKNavigationHelper, logger: logger)
    }

    init(threeDSWKNavigationHelper: ThreeDSWKNavigationHelping, logger: FramesEventLogging) {
        self.threeDSWKNavigationHelper = threeDSWKNavigationHelper
        self.logger = logger
        super.init(nibName: nil, bundle: nil)

        threeDSWKNavigationHelper.delegate = self
    }

    /// Returns a newly initialized view controller with the nib file in the specified bundle.
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Foundation.Bundle?) {
        threeDSWKNavigationHelper = nil
        logger = nil
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    /// Returns an object initialized from data in a given unarchiver.
    required public init?(coder aDecoder: NSCoder) {
        threeDSWKNavigationHelper = nil
        logger = nil
        super.init(coder: aDecoder)
    }

    // MARK: - Lifecycle

    /// Creates the view that the controller manages.
    public override func loadView() {
        view = webView
    }

    /// Called after the controller's view is loaded into memory.
    public override func viewDidLoad() {
        super.viewDidLoad()

        guard let authURL = authURL else {
            return
        }

        logger?.log(.threeDSWebviewPresented)

        let authRequest = URLRequest(url: authURL)
        webView.navigationDelegate = threeDSWKNavigationHelper
        authUrlNavigation = webView.load(authRequest)
    }
}

// MARK: - WKNavigationDelegate
extension ThreedsWebViewController: ThreeDSWKNavigationHelperDelegate {
    public func didFinishLoading(navigation: WKNavigation, success: Bool) {
        guard navigation == authUrlNavigation else {
            return
        }

        logger?.log(.threeDSChallengeLoaded(success: success))
    }

    public func threeDSWKNavigationHelperDelegate(didReceiveResult result: Result<String, ThreeDSError>) {
        switch result {
        case .success(let token):
            logger?.log(.threeDSChallengeComplete(success: true, tokenID: token))
            delegate?.threeDSWebViewControllerAuthenticationDidSucceed(self, token: token)
        case .failure(let error):
            switch error {
            case .couldNotExtractToken:
                logger?.log(.threeDSChallengeComplete(success: false, tokenID: nil))
                delegate?.threeDSWebViewControllerAuthenticationDidSucceed(self, token: nil)
            default:
                logger?.log(.threeDSChallengeComplete(success: false, tokenID: nil))
                delegate?.threeDSWebViewControllerAuthenticationDidFail(self)
            }
        }
    }
}

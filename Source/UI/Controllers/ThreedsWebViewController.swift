import UIKit
import WebKit
import CheckoutEventLoggerKit

/// A view controller to manage 3ds
public class ThreedsWebViewController: UIViewController {

    // MARK: - Properties

    var webView: WKWebView!
    let successUrl: URL?
    let failUrl: URL?

    /// Delegate
    public weak var delegate: ThreedsWebViewControllerDelegate?

    /// Url
    @available(*, deprecated, renamed: "authUrl")
    public var url: String? {
        didSet {
            if let url = url {
                authUrl = URL(string: url)
            }
        }
    }

    /// Authentication Url
    public var authUrl: URL?

    private let urlHelper: URLHelping
    private let logger: FramesEventLogging?

    private var webViewPresented = false
    var authUrlNavigation: WKNavigation?

    // MARK: - Initialization

    /// Initializes a web view controller adapted to handle 3dsecure.
    @available(*, deprecated, renamed: "init(successUrl:failUrl:)")
    public convenience init(successUrl successUrlString: String, failUrl failUrlString: String) {
        let successUrl = URL(string: successUrlString)
        let failUrl = URL(string: failUrlString)

        self.init(successUrl: successUrl, failUrl: failUrl)
    }

    public convenience init (successUrl: URL, failUrl: URL) {
        self.init(successUrl: .some(successUrl), failUrl: .some(failUrl))
    }

    /// Initializes a web view controller adapted to handle 3dsecure.
    convenience init(successUrl: URL?, failUrl: URL?) {
        // in 4.0.0 release we should ask for the environment
        #if DEBUG
        let environment = Environment.sandbox
        #else
        let environment = Environment.live
        #endif

        let appBundle = Foundation.Bundle.main
        let appPackageName = appBundle.bundleIdentifier ?? "unavailableAppPackageName"
        let appPackageVersion = appBundle.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unavailableAppPackageVersion"

        let uiDevice = UIKit.UIDevice.current

        let remoteProcessorMetadata = CheckoutAPIClient.buildRemoteProcessorMetadata(environment: environment,
                                                                                     appPackageName: appPackageName,
                                                                                     appPackageVersion: appPackageVersion,
                                                                                     uiDevice: uiDevice)

        let checkoutEventLogger = CheckoutEventLogger(productName: Constants.productName)
        checkoutEventLogger.enableRemoteProcessor(
            environment: .production,
            remoteProcessorMetadata: remoteProcessorMetadata)
        let dateProvider = DateProvider()
        let correlationIDManager = CorrelationIDManager()
        let framesEventLogger = FramesEventLogger(correlationID: correlationIDManager.generateCorrelationID(),
                                                  checkoutEventLogger: checkoutEventLogger, dateProvider: dateProvider)
        framesEventLogger.add(metadata: correlationIDManager.generateCorrelationID(),
                              forKey: CheckoutEventLogger.MetadataKey.correlationID)

        self.init(successUrl: successUrl, failUrl: failUrl, urlHelper: URLHelper(), logger: framesEventLogger)
    }

    init(successUrl: URL?, failUrl: URL?, urlHelper: URLHelping, logger: FramesEventLogging?) {
        self.successUrl = successUrl
        self.failUrl = failUrl
        self.urlHelper = urlHelper
        self.logger = logger
        super.init(nibName: nil, bundle: nil)
    }

    /// Returns a newly initialized view controller with the nib file in the specified bundle.
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Foundation.Bundle?) {
        successUrl = nil
        failUrl = nil
        urlHelper = URLHelper()
        logger = nil
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    /// Returns an object initialized from data in a given unarchiver.
    required public init?(coder aDecoder: NSCoder) {
        successUrl = nil
        failUrl = nil
        urlHelper = URLHelper()
        logger = nil
        super.init(coder: aDecoder)
    }

    // MARK: - Lifecycle

    /// Creates the view that the controller manages.
    public override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.websiteDataStore = .nonPersistent()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        view = webView
    }

    /// Called after the controller's view is loaded into memory.
    public override func viewDidLoad() {
        super.viewDidLoad()

        guard let authUrl = authUrl else {
            return
        }

        logger?.log(.threeDSWebviewPresented)

        let authRequest = URLRequest(url: authUrl)
        webView.navigationDelegate = self
        authUrlNavigation = webView.load(authRequest)
    }
}

// MARK: - WKNavigationDelegate
extension ThreedsWebViewController: WKNavigationDelegate {

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let dismissed = navigationAction.request.url.map { handleDismiss(redirectUrl: $0) } ?? false

        decisionHandler(dismissed ? .cancel : .allow)
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard navigation == authUrlNavigation else {
            return
        }

        logger?.log(.threeDSChallengeLoaded(success: true))
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        guard navigation == authUrlNavigation else {
            return
        }

        logger?.log(.threeDSChallengeLoaded(success: false))
    }

    private func handleDismiss(redirectUrl: URL) -> Bool {

        if let successUrl = successUrl,
           urlHelper.urlsMatch(redirectUrl: redirectUrl, matchingUrl: successUrl) {
            // success url, dismissing the page with the payment token

            self.dismiss(animated: true) { [urlHelper, delegate, logger] in
                let token = urlHelper.extractToken(from: redirectUrl)
                delegate?.threeDSWebViewControllerAuthenticationDidSucceed(self, token: token)
                delegate?.onSuccess3D()
                logger?.log(.threeDSChallengeComplete(success: true, tokenID: token))
            }

            return true
        } else if let failUrl = failUrl,
                  urlHelper.urlsMatch(redirectUrl: redirectUrl, matchingUrl: failUrl) {
            // fail url, dismissing the page
            self.dismiss(animated: true) { [delegate, logger] in
                delegate?.threeDSWebViewControllerAuthenticationDidFail(self)
                delegate?.onFailure3D()
                logger?.log(.threeDSChallengeComplete(success: false, tokenID: nil))
            }

            return true
        }

        return false
    }
}

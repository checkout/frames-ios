import UIKit
import WebKit

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

    // MARK: - Initialization

    /// Initializes a web view controller adapted to handle 3dsecure.
    @available(*, deprecated, renamed: "init(successUrl:failUrl:)")
    public convenience init(successUrl successUrlString: String, failUrl failUrlString: String) {
        let successUrl = URL(string: successUrlString)
        let failUrl = URL(string: failUrlString)

        self.init(successUrl: successUrl, failUrl: failUrl, urlHelper: URLHelper())
    }

    /// Initializes a web view controller adapted to handle 3dsecure.
    public convenience init(successUrl: URL, failUrl: URL) {
        self.init(successUrl: successUrl, failUrl: failUrl, urlHelper: URLHelper())
    }

    init(successUrl: URL?, failUrl: URL?, urlHelper: URLHelping) {
        self.successUrl = successUrl
        self.failUrl = failUrl
        self.urlHelper = urlHelper
        super.init(nibName: nil, bundle: nil)
    }

    /// Returns a newly initialized view controller with the nib file in the specified bundle.
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Foundation.Bundle?) {
        successUrl = nil
        failUrl = nil
        urlHelper = URLHelper()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    /// Returns an object initialized from data in a given unarchiver.
    required public init?(coder aDecoder: NSCoder) {
        successUrl = nil
        failUrl = nil
        urlHelper = URLHelper()
        super.init(coder: aDecoder)
    }

    // MARK: - Lifecycle

    /// Creates the view that the controller manages.
    public override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        view = webView
    }

    /// Called after the controller's view is loaded into memory.
    public override func viewDidLoad() {
        super.viewDidLoad()

        guard let authUrl = authUrl else {
            return
        }

        let authRequest = URLRequest(url: authUrl)
        webView.navigationDelegate = self
        webView.load(authRequest)
    }
}

// MARK: - WKNavigationDelegate
extension ThreedsWebViewController: WKNavigationDelegate {

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let dismissed = navigationAction.request.url.map { handleDismiss(redirectUrl: $0) } ?? false

        decisionHandler(dismissed ? .cancel : .allow)
    }

    private func handleDismiss(redirectUrl: URL) -> Bool {

        if let successUrl = successUrl,
           urlHelper.urlsMatch(redirectUrl: redirectUrl, matchingUrl: successUrl) {
            // success url, dismissing the page with the payment token

            self.dismiss(animated: true) { [urlHelper, delegate] in
                let token = urlHelper.extractToken(from: redirectUrl)
                delegate?.threeDSWebViewControllerAuthenticationDidSucceed(self, token: token)
                delegate?.onSuccess3D()
            }

            return true
        } else if let failUrl = failUrl,
                  urlHelper.urlsMatch(redirectUrl: redirectUrl, matchingUrl: failUrl) {
            // fail url, dismissing the page
            self.dismiss(animated: true) { [delegate] in
                delegate?.threeDSWebViewControllerAuthenticationDidFail(self)
                delegate?.onFailure3D()
            }

            return true
        }

        return false
    }
}

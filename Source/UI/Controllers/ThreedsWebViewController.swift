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
    public var url: String?

    // MARK: - Initialization

    /// Initializes a web view controller adapted to handle 3dsecure.
    @available(*, deprecated, renamed: "init(successUrl:failUrl:)")
    public init(successUrl: String, failUrl: String) {
        self.successUrl = URL(string: successUrl)
        self.failUrl = URL(string: failUrl)
        super.init(nibName: nil, bundle: nil)
    }

    /// Initializes a web view controller adapted to handle 3dsecure.
    public init(successUrl: URL, failUrl: URL) {
        self.successUrl = successUrl
        self.failUrl = failUrl
        super.init(nibName: nil, bundle: nil)
    }

    /// Returns a newly initialized view controller with the nib file in the specified bundle.
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Foundation.Bundle?) {
        successUrl = nil
        failUrl = nil
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    /// Returns an object initialized from data in a given unarchiver.
    required public init?(coder aDecoder: NSCoder) {
        successUrl = nil
        failUrl = nil
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

        guard let authUrl = url,
              let url = URL(string: authUrl) else {
            return
        }

        let myRequest = URLRequest(url: url)
        webView.navigationDelegate = self
        webView.load(myRequest)
    }
}

// MARK: - WKNavigationDelegate
extension ThreedsWebViewController: WKNavigationDelegate {

    /// Called when the web view begins to receive web content.
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {

        guard let absoluteUrl = webView.url else {
            return
        }

        shouldDismiss(absoluteUrl: absoluteUrl)
    }

    /// Called when a web view receives a server redirect.
    public func webView(_ webView: WKWebView,
                        didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        // stop the redirection
        guard let absoluteUrl = webView.url else {
            return
        }

        shouldDismiss(absoluteUrl: absoluteUrl)
    }

    private func shouldDismiss(absoluteUrl: URL) {
        // get URL conforming to RFC 1808 without the query
        let url = absoluteUrl.withoutQuery

        if url == successUrl {
            // success url, dismissing the page with the payment token
            self.dismiss(animated: true) {
                let token = self.extractToken(from: absoluteUrl)
                self.delegate?.threeDSWebViewControllerAuthenticationDidSucceed(self, token: token)
                self.delegate?.onSuccess3D()
            }
        } else if url == failUrl {
            // fail url, dismissing the page
            self.dismiss(animated: true) {
                self.delegate?.threeDSWebViewControllerAuthenticationDidFail(self)
                self.delegate?.onFailure3D()
            }
        }
    }

    private func extractToken(from url: URL) -> String? {

        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }

        return components.queryItems?.first { $0.name == "cko-payment-token" }?.value
            ?? components.queryItems?.first { $0.name == "cko-session-id" }?.value
    }

}

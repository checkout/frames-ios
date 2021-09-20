import Foundation

/// Methods to handle the response in the 3ds web view
public protocol ThreedsWebViewControllerDelegate: AnyObject {

    /// Called if the response is successful
    @available(*, deprecated, renamed: "threeDSWebViewControllerAuthenticationDidSucceed(_:token:)")
    func onSuccess3D()

    /// Called if the response is unsuccesful
    @available(*, deprecated, renamed: "threeDSWebViewControllerAuthenticationDidFail(_:)")
    func onFailure3D()

    /// Called upon successful 3D Secure authentication.
    /// - Parameters:
    ///   - threeDSWebViewController: The `ThreedsWebViewController` instance calling this method.
    ///   - token: The token extracted from the success URL.
    func threeDSWebViewControllerAuthenticationDidSucceed(_ threeDSWebViewController: ThreedsWebViewController,
                                                          token: String?)

    /// Called upon unsuccessful 3D Secure authentication.
    /// - Parameters:
    ///   - threeDSWebViewController: The `ThreedsWebViewController` instance calling this method.
    func threeDSWebViewControllerAuthenticationDidFail(_ threeDSWebViewController: ThreedsWebViewController)

}

public extension ThreedsWebViewControllerDelegate {

    func onSuccess3D() {}

    func onFailure3D() {}

    func threeDSWebViewControllerAuthenticationDidSucceed(_ threeDSWebViewController: ThreedsWebViewController,
                                                          token: String?) {}

    func threeDSWebViewControllerAuthenticationDidFail(_ threeDSWebViewController: ThreedsWebViewController) {}
}

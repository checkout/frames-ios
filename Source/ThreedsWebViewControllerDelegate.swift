import Foundation

/// Methods to handle the response in the 3ds web view
public protocol ThreedsWebViewControllerDelegate: class {

    /// Called if the response is successful
    func onSuccess3D()

    /// Called if the response is unsuccesful
    func onFailure3D()
}

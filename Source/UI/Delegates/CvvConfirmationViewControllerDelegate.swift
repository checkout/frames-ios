import Foundation

/// Methods used to handle action on the cvv confirmation page
public protocol CvvConfirmationViewControllerDelegate: AnyObject {

    /// Called when the user confirms the cvv
    ///
    /// - parameter controller: `CvvConfirmationViewController`
    /// - parameter cvv: cvv
    func onConfirm(controller: CvvConfirmationViewController, cvv: String)

    /// Called when the user cancel
    ///
    /// - parameter controller: `CvvConfirmationViewController`
    func onCancel(controller: CvvConfirmationViewController)
}

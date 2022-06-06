import Foundation
import Checkout

/// Method that you can use to manage the editing of the expiration date.
public protocol CardViewControllerDelegate: AnyObject {

    /// Executed when an user tap on the done button.
    ///
    /// - parameter controller: `CardViewController`
    /// - parameter result: result of tokenisation request
    func onTapDone(controller: CardViewController, result: Result<TokenDetails, TokenisationError.TokenRequest>)


    /// Called just before a request to make a card token.
    /// - Parameter controller: `CardViewController`
    func onSubmit(controller: CardViewController)
}

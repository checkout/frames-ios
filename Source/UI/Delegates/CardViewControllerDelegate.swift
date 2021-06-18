import Foundation

/// Method that you can use to manage the editing of the expiration date.
public protocol CardViewControllerDelegate: AnyObject {

    /// Executed when an user tap on the done button.
    ///
    /// - parameter controller: `CardViewController`
    /// - parameter card: Card entered by the user
    func onTapDone(controller: CardViewController, cardToken: CkoCardTokenResponse?, status: CheckoutTokenStatus)


    /// Called just before a request to make a card token.
    /// - Parameter controller: `CardViewController`
    func onSubmit(controller: CardViewController)
}

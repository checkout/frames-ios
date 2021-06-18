import Foundation

/// Method that you can use to handle the cvv changes.
public protocol CvvInputViewDelegate: AnyObject {

    /// Called when the cvv changed.
    func onChangeCvv()

}

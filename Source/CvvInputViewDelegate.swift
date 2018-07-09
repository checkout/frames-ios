import Foundation

/// Method that you can use to handle the cvv changes.
public protocol CvvInputViewDelegate: class {

    /// Called when the cvv changed.
    func onChangeCvv()

}

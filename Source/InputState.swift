import Foundation

/// Input State
///
/// - normal
/// - required
/// - hidden
public enum InputState {

    /// input should be displayed and is not a required field
    case normal

    /// input should be displayed and is a required field
    case required

    /// input should not be displayed
    case hidden
}

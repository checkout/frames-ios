import Foundation

/// Data about a card type
public struct CardType: Equatable {

    /// Card Scheme
    public let scheme: CardScheme

    /// Name of the scheme (e.g. Visa, Mastercard)
    public let name: String

    /// Pattern to detect the scheme based on the card number
    public let pattern: String

    /// The position of the gaps
    public let gaps: [Int]

    /// The valid lengths
    public let validLengths: [Int]

    /// The valid lengths for the cvv (card verification value)
    public let validCvvLengths: [Int]

    /// True if the validity of the card number can be checked using the luhn algorithm
    public let isLuhnChecked: Bool
}

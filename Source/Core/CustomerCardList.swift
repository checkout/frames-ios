import Foundation

/// Customer card list
public struct CustomerCardList: Codable {

    /// Number of cards
    public var count: Int

    /// Cards associated to the customer
    public var data: [CustomerCard]
}

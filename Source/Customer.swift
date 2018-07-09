import Foundation

/// Customer object returned by Checkout Merchant API.
public struct Customer: Codable {

    /// A string of characters (prefixed with cust_) that uniquely identifies the customer
    public let id: String

    /// The UTC date and time expressed according to ISO 8601.
    /// (e.g., 2015-11-05T13:10:30Z or 2015-11-05T08:10:30-05:00)
    public let created: String

    /// An array of card objects
    public let cards: CustomerCardList

    /// The card ID of the customer's default card
    public let defaultCard: String

    /// The description specified in the request.
    public let description: String?

    /// The customer's email address.
    public let email: String

    /// Defined as:
    /// - true if the live keys were used in the request.
    /// - false if the test keys were used in the request.
    public let livemode: Bool

    /// The customer's name.
    public let name: String?

    /// Phone number of the customer.
    public let phone: CkoPhoneNumber
}

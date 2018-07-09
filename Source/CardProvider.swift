import Foundation

/// Card Provider
public struct CardProvider: Codable, Equatable {

    /// Card provider id (e.g. cp_1)
    public let id: String

    /// Name of the card provider (e.g. VISA)
    public let name: String
}

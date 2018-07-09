import Foundation

struct Authorize3dsResponse: Codable {
    let chargeMode: Int
    let enrolled: String?
    let id: String
    let liveMode: Bool
    let redirectUrl: String
    let responseCode: String
}

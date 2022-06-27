import Foundation

enum StubError: CustomNSError {

    static let errorDomain = String(describing: Self.self)

    case errorOne
    case errorTwo

}

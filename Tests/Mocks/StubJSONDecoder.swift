import Foundation

@testable import Frames

final class StubJSONDecoder: JSONDecoder {
    private(set) var decodeCalledWithData: Data?
    var decodeThrownErrors: [Error] = []
    // swiftlint:disable:next implicitly_unwrapped_optional
    var decodeReturnValue: Any!

    override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        if !decodeThrownErrors.isEmpty {
            throw decodeThrownErrors.removeFirst()
        }

        decodeCalledWithData = data
        // swiftlint:disable:next force_cast
        return decodeReturnValue as! T
    }
}

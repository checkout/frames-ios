import Foundation

@testable import Frames

final class StubJSONEncoder: JSONEncoder {
    private(set) var encodeCalledWithValue: Any?

    // swiftlint:disable:next implicitly_unwrapped_optional
    var encodeReturnValue: Data!

    override func encode<T>(_ value: T) throws -> Data where T: Encodable {
        encodeCalledWithValue = value
        return encodeReturnValue
    }
}

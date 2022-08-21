import XCTest

@testable import Frames

final class Dictionary_AdditionsTests: XCTestCase {
    // MARK: - updating

    func test_updating_value_returnsDictionaryWithNewKeyValuePair() {
        let expectedDictionary = ["key_1": "value_1", "key_2": "value_2"]
        let actualDictionary = ["key_1": "value_1"].updating(key: "key_2", value: "value_2")

        XCTAssertEqual(expectedDictionary, actualDictionary)
    }

    func test_updating_value_existingValueInDictionary_returnsDictionaryWithNewKeyValuePair() {
        let expectedDictionary = ["key_1": "value_1", "key_2": "value_2"]
        let actualDictionary = ["key_1": "value_1", "key_2": "test"].updating(key: "key_2", value: "value_2")

        XCTAssertEqual(expectedDictionary, actualDictionary)
    }

    func test_updating_valueIsNil_returnsDictionaryWithoutNewKeyValuePair() {
        let expectedDictionary = ["key_1": "value_1"]
        let actualDictionary = ["key_1": "value_1"].updating(key: "key_2", value: nil)

        XCTAssertEqual(expectedDictionary, actualDictionary)
    }

    // MARK: - mapKeys

    func test_mapKeys_returnsCorrectDictionary() {
        let expectedDictionary = ["1": "value_1", "2": "value_2"]
        let actualDictionary = [1: "value_1", 2: "value_2"].mapKeys(\.description)

        XCTAssertEqual(expectedDictionary, actualDictionary)
    }
}

//
//  NetworkErrorTests.swift
//  FramesIosTests
//
//  Created by Daven.Gomes on 02/12/2020.
//  Copyright © 2020 Checkout. All rights reserved.
//

import XCTest
@testable import Frames

final class NetworkErrorTests: XCTestCase {

    func test_init_allValuesExist_checkoutErrorReturned() {

        let responseJSON = makeResponseJSON(
            requestID: "stubRequestID",
            errorType: "stubErrorType",
            errorCodes: ["stubErrorCode1",
                         "stubErrorCode2"]
        )

        do {

            let data = try JSONSerialization.data(withJSONObject: responseJSON, options: .prettyPrinted)
            let snakeCaseDecoder = JSONDecoder()
            snakeCaseDecoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try snakeCaseDecoder.decode(NetworkError.self, from: data)

            guard case .checkout(let requestId, let errorType, let errorCodes) = result else {
                return XCTFail("Unexpected NetworkError type.")
            }

            XCTAssertEqual(requestId, "stubRequestID")
            XCTAssertEqual(errorType, "stubErrorType")
            XCTAssertEqual(errorCodes, ["stubErrorCode1",
                                        "stubErrorCode2"])

        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_init_emptyData_throwsError() {
        
        let data = Data()
        XCTAssertThrowsError(try JSONDecoder().decode(NetworkError.self, from: data))
    }

    func test_init_requestIDNil_throwsError() throws {

        let responseJSON = makeResponseJSON(
            requestID: nil,
            errorType: "stubErrorType",
            errorCodes: ["stubErrorCode1",
                         "stubErrorCode2"]
        )
        
        let data = try XCTUnwrap(JSONSerialization.data(withJSONObject: responseJSON, options: .prettyPrinted))
        XCTAssertThrowsError(try JSONDecoder().decode(NetworkError.self, from: data))
    }

    func test_init_errorTypeNil_throwsError() throws {

        let responseJSON = makeResponseJSON(
            requestID: "stubRequestID",
            errorType: nil,
            errorCodes: ["stubErrorCode1",
                         "stubErrorCode2"]
        )

        let data = try XCTUnwrap(JSONSerialization.data(withJSONObject: responseJSON, options: .prettyPrinted))
        XCTAssertThrowsError(try JSONDecoder().decode(NetworkError.self, from: data))
    }

    func test_init_errorCodesNil_throwsError() throws {

        let responseJSON = makeResponseJSON(
            requestID: "stubRequestID",
            errorType: "stubErrorType",
            errorCodes: nil
        )

        let data = try XCTUnwrap(JSONSerialization.data(withJSONObject: responseJSON, options: .prettyPrinted))
        XCTAssertThrowsError(try JSONDecoder().decode(NetworkError.self, from: data))
    }


    private func makeResponseJSON(requestID: String? = nil,
                                  errorType: String? = nil,
                                  errorCodes: [String]? = nil) -> [String: Any?] {

        return ["request_id": requestID,
                "error_type": errorType,
                "error_codes": errorCodes]
    }
}

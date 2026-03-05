//
//  StubRisk.swift
//
//
//  Created by Precious Ossai on 20/02/2024.
//

import Foundation
@testable import RiskSDK
@testable import Checkout

// swiftlint:disable large_tuple
class StubRisk: RiskProtocol {
    
    var configureCalledCount = 0
    var publishDataCalledCount = 0

    // If set to false, Risk SDK will hang and not call the completion block for that specific function.
    // It will mimic the behaviour of a bug we have. We need to call Frames's completion block after the defined timeout period in that case.
    var shouldConfigureFunctionCallCompletion: Bool = true
    var shouldPublishFunctionCallCompletion: Bool = true

    func configure(completion: @escaping (Result<Void, RiskError.Configuration>) -> Void) {
        configureCalledCount += 1
        if shouldConfigureFunctionCallCompletion {
          completion(.success(()))
        }
    }
    
    func publishData (cardToken: String? = nil, completion: @escaping (Result<PublishRiskData, RiskError.Publish>) -> Void) {
        publishDataCalledCount += 1
        if shouldPublishFunctionCallCompletion {
          completion(.success(PublishRiskData(deviceSessionId: "dsid_testDeviceSessionId")))
        }
    }
}


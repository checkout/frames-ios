//
//  StubRisk.swift
//
//
//  Created by Precious Ossai on 20/02/2024.
//

import Foundation
@testable import Risk
@testable import Checkout

// swiftlint:disable large_tuple
class StubRisk: RiskProtocol {
    
    var configureCalledCount = 0
    var publishDataCalledCount = 0
    
    func configure(completion: @escaping (Result<Void, RiskError.Configuration>) -> Void) {
        configureCalledCount += 1
        completion(.success(()))
    }
    
    func publishData (cardToken: String? = nil, completion: @escaping (Result<PublishRiskData, RiskError.Publish>) -> Void) {
        publishDataCalledCount += 1
        completion(.success(PublishRiskData(deviceSessionId: "dsid_testDeviceSessionId")))
    }
}


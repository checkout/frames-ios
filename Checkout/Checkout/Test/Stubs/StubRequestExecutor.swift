//
//  StubRequestExecutor.swift
//  
//
//  Created by Harry Brown on 02/12/2021.
//

import Foundation
@testable import Checkout

final class StubRequestExecutor<A: Decodable, B: Decodable>: RequestExecuting {
  private(set) var executeCalledWithRequestParameters: NetworkManager.RequestParameters?
  private(set) var executeCalledWithResponseType: A.Type?
  private(set) var executeCalledWithResponseErrorType: B.Type?
  private(set) var executeCalledWithCompletion: ((NetworkRequestResult<A, B>, HTTPURLResponse?) -> Void)?

  func execute<T, U>(
    _ requestParameters: NetworkManager.RequestParameters,
    responseType: T.Type,
    responseErrorType: U.Type,
    completion: @escaping (NetworkRequestResult<T, U>, HTTPURLResponse?) -> Void
  ) where T: Decodable, U: Decodable {
    executeCalledWithRequestParameters = requestParameters
    executeCalledWithResponseType = responseType as? A.Type
    executeCalledWithResponseErrorType = responseErrorType as? B.Type
    executeCalledWithCompletion = completion as? ((NetworkRequestResult<A, B>, HTTPURLResponse?) -> Void)
  }
}

//
//  StubRequestFactory.swift
//  
//
//  Created by Harry Brown on 02/12/2021.
//

import Foundation
@testable import Checkout

final class StubRequestFactory: RequestProviding {
  var createToReturn: Result<
    NetworkManager.RequestParameters,
    RequestFactory.RequestError
  > = .failure(.baseURLCouldNotBeConvertedToComponents)
  private(set) var createCalledWith: RequestFactory.Request?

  func create(request: RequestFactory.Request) -> Result<NetworkManager.RequestParameters, RequestFactory.RequestError> {
    createCalledWith = request

    return createToReturn
  }
}

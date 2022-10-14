//
//  StubURLSession.swift
//  
//
//  Created by Harry Brown on 02/12/2021.
//

import Foundation

final class StubURLSession: URLSession {
  private(set) var dataTaskCalledWithRequest: URLRequest?
  private(set) var dataTaskCalledWithCompletionHandler: ((Data?, URLResponse?, Error?) -> Void)?
  var dataTaskReturnValue: URLSessionDataTask = StubURLSessionDataTask()

  override func dataTask(
    with request: URLRequest,
    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
  ) -> URLSessionDataTask {
    dataTaskCalledWithRequest = request
    dataTaskCalledWithCompletionHandler = completionHandler

    return dataTaskReturnValue
  }
}

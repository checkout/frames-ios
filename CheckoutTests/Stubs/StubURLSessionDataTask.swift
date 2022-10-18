//
//  StubURLSessionDataTask.swift
//  
//
//  Created by Harry Brown on 02/12/2021.
//

import Foundation

final class StubURLSessionDataTask: URLSessionDataTask {
  private(set) var resumeCalled = false

  override func resume() {
    resumeCalled = true
  }
}

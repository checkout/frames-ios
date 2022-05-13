//
//  NetworkRequestResult.swift
//  
//
//  Created by Harry Brown on 24/11/2021.
//

import Foundation

enum NetworkRequestResult<Response, ErrorResponse> {
  case response(Response)
  case errorResponse(ErrorResponse)
  case networkError(NetworkError)
}

extension NetworkRequestResult: Equatable where Response: Equatable, ErrorResponse: Equatable {}

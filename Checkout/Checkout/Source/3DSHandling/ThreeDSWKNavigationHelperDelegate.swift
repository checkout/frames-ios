//
//  ThreeDSWKNavigationHelperDelegate.swift
//
//
//  Created by Daven.Gomes on 02/02/2022.
//

import Foundation

public protocol ThreeDSWKNavigationHelperDelegate: AnyObject {
  func threeDSWKNavigationHelperDelegate(didReceiveResult: Result<String, ThreeDSError>)
}

//
//  ThreeDSWKNavigationHelperDelegate.swift
//
//
//  Created by Daven.Gomes on 02/02/2022.
//

import WebKit

public protocol ThreeDSWKNavigationHelperDelegate: AnyObject {
  func didFinishLoading(navigation: WKNavigation, success: Bool)
  func threeDSWKNavigationHelperDelegate(didReceiveResult: Result<String, ThreeDSError>)
}

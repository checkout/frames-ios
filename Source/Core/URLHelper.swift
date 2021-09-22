//
//  URLHelper.swift
//  Frames
//
//  Created by Harry.Brown on 21/09/2021.
//

import Foundation

protocol URLHelping {

    func urlsMatch(redirectUrl: URL, matchingUrl: URL) -> Bool
    func extractToken(from url: URL) -> String?
}

final class URLHelper: URLHelping {

    func extractToken(from url: URL) -> String? {

        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }

        return components.queryItems?.first { $0.name == "cko-payment-token" }?.value
            ?? components.queryItems?.first { $0.name == "cko-session-id" }?.value
    }

    func urlsMatch(redirectUrl: URL, matchingUrl: URL) -> Bool {

        guard let redirectURLComponents = URLComponents(url: redirectUrl, resolvingAgainstBaseURL: false),
              let matchingURLComponents = URLComponents(url: matchingUrl, resolvingAgainstBaseURL: false) else {
            return false
        }

        if let matchingQueryItems = matchingURLComponents.queryItems {
            for matchingItem in matchingQueryItems {

                let queryItemIsPresent = redirectURLComponents.queryItems?.contains(where: {
                    matchingItem.name == $0.name && matchingItem.value == $0.value
                }) ?? false

                guard queryItemIsPresent else {
                    return false
                }
            }
        }

        return redirectURLComponents.scheme == matchingURLComponents.scheme
            && redirectURLComponents.host == matchingURLComponents.host
            && redirectURLComponents.path == matchingURLComponents.path
            && redirectURLComponents.fragment == matchingURLComponents.fragment
    }
}

//
//  Language.swift
//  iOS Example Frame Regression Tests
//
//  Created by Okhan Okbay on 10/08/2023.
//  Copyright © 2023 Checkout. All rights reserved.
//

import Foundation

enum Language: String, CaseIterable {
    case fr, es, it, de, nl, ar, ro, en

    var locale: String {
        switch self {
        case .fr: return "fr_FR"
        case .es: return "es_ES"
        case .it: return "it_IT"
        case .de: return "de_DE"
        case .nl: return "nl_NL"
        case .ar: return "ar_SA"
        case .ro: return "ro_RO"
        case .en: return "en_US"
        }
    }
}

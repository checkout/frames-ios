//
//  TestCard.swift
//  iOS Example Frame Regression Tests
//
//  Created by Okhan Okbay on 25/07/2023.
//  Copyright © 2023 Checkout. All rights reserved.
//

import Foundation

enum CardType {
    case visa, mastercard,amex, maestro, jcb, diners, discover, mada
}

struct TestCard: Hashable {
    let type: CardType
    let number: String
    var securityCode: String = "123"
    let expiryDate: String = "1228"
}

/**
 These are the test cards that we use to see if we can get a token by using them
 **/

let tokenableTestCards: [TestCard] = [
    .init(type: .visa, number: "4485040371536584"),
    .init(type: .visa, number: "4911830000000"),
    .init(type: .visa, number: "4917610000000000003"),
    .init(type: .mastercard, number: "5588686116426417"),
    .init(type: .amex, number: "345678901234564", securityCode: "1234"),
    .init(type: .maestro, number: "6759649826438453"),
    .init(type: .maestro, number: "6799990100000000019"),
    .init(type: .jcb, number: "3528982710432481"),
    .init(type: .diners, number: "36160940933914"),
    .init(type: .discover, number: "6011111111111117"),
    .init(type: .mada, number: "4464040000000007")
]

/**
 These are luhn numbers that are just 1 character less with the least character count of the relevant card schemes
 For example, Visa cards must be at least 13 characters and must start with 44.
 So, we needed a luhn number that starts with 4 and is 12 digits.
 To see that we check the character count beyond the luhn verifications.

 Textfields don't even allow us to enter more than the max character count of a card scheme's card.
 So, it's not testable.
 **/

let characterCountCheckTestCards: [(card: TestCard, shouldShowError: Bool)] = [
    (.init(type: .visa, number: "440000000002"), true),
    (.init(type: .visa, number: "4400000000008"), false),
    (.init(type: .mastercard, number: "550000000000004"), true),
    (.init(type: .mastercard, number: "5500000000000004"), false),
    (.init(type: .discover, number: "650000000000003"), true),
    (.init(type: .discover, number: "6500000000000002"), false),
    (.init(type: .amex, number: "34000000000000", securityCode: "1234"), true),
    (.init(type: .amex, number: "340000000000009", securityCode: "1234"), false),
    (.init(type: .diners, number: "3600000000004"), true),
    (.init(type: .diners, number: "36000000000008"), false),
]

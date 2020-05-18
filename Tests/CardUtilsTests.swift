import XCTest
@testable import FramesIos

class CardUtilsTests: XCTestCase {

    let cards = CardUtils()
    let visaCards = ["4651997672049328", "4485958561669511", "4929280692848862"]
    let mastercardCards = ["5185868732238239", "5490767572618494", "5336308433060853"]
    let amexCards = ["341347759839189", "346379996281789", "378587251292074"]
    let dinersClubCards = ["30569309025904", "38520000023237", "36148900647913"]
    let discoverCards = ["6011000400000000", "6011111111111117", "6011000990139424"]
    let unionPayCards = ["6269992058134322", "6221258812340000", "6221558812340000"]
    let maestroCards = ["6921566956623303", "6945584356562221", "6762006582539153"]
    let jcbCards = ["3566002020360505", "353445444300732639", "3537286818376838569"]

    let invalidCards = ["4651997672049324", "5185868732238231", "341347759839182", "30569309025906", "6011000400000004"]

    // Card types
    var visaCardType: CardType { return cards.getCardType(scheme: .visa)! }
    var mastercardCardType: CardType { return cards.getCardType(scheme: .mastercard)! }
    var amexCardType: CardType { return cards.getCardType(scheme: .americanExpress)! }
    var dinersClubCardType: CardType { return cards.getCardType(scheme: .dinersClub)! }
    var discoverCardType: CardType { return cards.getCardType(scheme: .discover)! }
    var unionPayCardType: CardType { return cards.getCardType(scheme: .unionPay)! }
    var maestroCardType: CardType { return cards.getCardType(scheme: .maestro)! }
    var jcbCardType: CardType { return cards.getCardType(scheme: .jcb)! }

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testLuhnCheckValid() {
        // Visa
        visaCards.forEach {
            XCTAssertTrue(cards.luhnCheck(cardNumber: $0), "Visa card \($0)")
        }
        // Mastercard
        mastercardCards.forEach {
            XCTAssertTrue(cards.luhnCheck(cardNumber: $0), "Mastercard card \($0)")
        }
        // American Express
        amexCards.forEach {
            XCTAssertTrue(cards.luhnCheck(cardNumber: $0), "American Express card \($0)")
        }
        // Diner's Club
        dinersClubCards.forEach {
            XCTAssertTrue(cards.luhnCheck(cardNumber: $0), "Diner's Club card \($0)")
        }
        // Discover
        discoverCards.forEach {
            XCTAssertTrue(cards.luhnCheck(cardNumber: $0), "Discover card \($0)")
        }
        // Maestro
        maestroCards.forEach {
            XCTAssertTrue(cards.luhnCheck(cardNumber: $0), "Maestro card \($0)")
        }
        // JCB
        jcbCards.forEach {
            XCTAssertTrue(cards.luhnCheck(cardNumber: $0), "JCB card \($0)")
        }

    }

    func testLuhnCheckInvalid() {
        invalidCards.forEach {
            XCTAssertFalse(cards.luhnCheck(cardNumber: $0), "Invalid card \($0)")
        }
    }

    func testGetTypeOfCardNumber() {
        // Visa
        visaCards.forEach {
            XCTAssertEqual(cards.getTypeOf(cardNumber: $0), cards.getCardType(scheme: .visa), "Visa card \($0)")
        }
        // Mastercard
        mastercardCards.forEach {
            XCTAssertEqual(cards.getTypeOf(cardNumber: $0), cards.getCardType(scheme: .mastercard),
                           "Mastercard card \($0)")
        }
        // American Express
        amexCards.forEach {
            XCTAssertEqual(cards.getTypeOf(cardNumber: $0), cards.getCardType(scheme: .americanExpress),
                           "American Express card \($0)")
        }
        // Diner's Club
        dinersClubCards.forEach {
            XCTAssertEqual(cards.getTypeOf(cardNumber: $0), cards.getCardType(scheme: .dinersClub),
                           "Diner's Club card \($0)")
        }
        // Discover
        discoverCards.forEach {
            XCTAssertEqual(cards.getTypeOf(cardNumber: $0), cards.getCardType(scheme: .discover),
                           "Discover card \($0)")
        }
        // Union Pay
        unionPayCards.forEach {
            XCTAssertEqual(cards.getTypeOf(cardNumber: $0), cards.getCardType(scheme: .unionPay),
                           "Union Pay card \($0)")
        }
        // Maestro
        maestroCards.forEach {
            XCTAssertEqual(cards.getTypeOf(cardNumber: $0), cards.getCardType(scheme: .maestro),
                           "Maestro card \($0)")
        }
        // JCB
        jcbCards.forEach {
            XCTAssertEqual(cards.getTypeOf(cardNumber: $0), cards.getCardType(scheme: .jcb),
                           "JCB card \($0)")
        }
        // Unknown
        XCTAssertNil(cards.getTypeOf(cardNumber: "1234567890"))
    }

    func testFormatCardNumber() {
        // Visa
        [
            ["4651997672049328", "4651 9976 7204 9328"],
            ["4485958561669511", "4485 9585 6166 9511"],
            ["4", "4"]
            ].forEach {
                XCTAssertEqual(cards.format(cardNumber: $0[0], cardType: visaCardType), $0[1])
        }
        // Mastercard
        [
            ["5185868732238239", "5185 8687 3223 8239"],
            ["5490767572618494", "5490 7675 7261 8494"]
            ].forEach {
                XCTAssertEqual(cards.format(cardNumber: $0[0], cardType: mastercardCardType), $0[1])
        }
        // American Express
        [
            ["341347759839189", "3413 477598 39189"],
            ["346379996281789", "3463 799962 81789"]
            ].forEach {
                XCTAssertEqual(cards.format(cardNumber: $0[0], cardType: amexCardType), $0[1])
        }
        // Diners Club
        [
            ["30569309025904", "3056 930902 5904"],
            ["38520000023237", "3852 000002 3237"]
            ].forEach {
                XCTAssertEqual(cards.format(cardNumber: $0[0], cardType: dinersClubCardType), $0[1])
        }
        // Discover
        [
            ["6011000400000000", "6011 0004 0000 0000"],
            ["6011111111111117", "6011 1111 1111 1117"]
            ].forEach {
                XCTAssertEqual(cards.format(cardNumber: $0[0], cardType: discoverCardType), $0[1])
        }
        // Union Pay
        [
            ["6269992058134322", "6269 992058 134322"],
            ["6221258812340000", "6221 258812 340000"]
            ].forEach {
                XCTAssertEqual(cards.format(cardNumber: $0[0], cardType: unionPayCardType), $0[1])
        }
        // Maestro
        [
            ["6921566956623303", "6921 5669 5662 3303"],
            ["6945584356562221", "6945 5843 5656 2221"]
            ].forEach {
                XCTAssertEqual(cards.format(cardNumber: $0[0], cardType: maestroCardType), $0[1])
        }
        // JCB
        [
            ["3566002020360505", "3566 0020 2036 0505"],
            ["353445444300732639", "3534 4544 4300 732639"]
            ].forEach {
                XCTAssertEqual(cards.format(cardNumber: $0[0], cardType: jcbCardType), $0[1])
        }

    }

    func testValidCardNumberWithType() {
        // Visa
        visaCards.forEach { cardNumber in
            XCTAssertTrue(cards.isValid(cardNumber: cardNumber, cardType: visaCardType),
                          "Visa card \(cardNumber)")
        }
        // Mastercard
        mastercardCards.forEach { cardNumber in
            XCTAssertTrue(cards.isValid(cardNumber: cardNumber, cardType: mastercardCardType),
                          "Mastercard card \(cardNumber)")
        }
        // American Express
        amexCards.forEach { cardNumber in
            XCTAssertTrue(cards.isValid(cardNumber: cardNumber, cardType: amexCardType),
                          "American Express card \(cardNumber)")
        }
        // Diner's Club
        dinersClubCards.forEach { cardNumber in
            XCTAssertTrue(cards.isValid(cardNumber: cardNumber, cardType: dinersClubCardType),
                          "Diner's Club card \(cardNumber)")
        }
        // Discover
        discoverCards.forEach { cardNumber in
            XCTAssertTrue(cards.isValid(cardNumber: cardNumber, cardType: discoverCardType),
                          "Discover card \(cardNumber)")
        }
        // Maestro
        maestroCards.forEach { cardNumber in
            XCTAssertTrue(cards.isValid(cardNumber: cardNumber, cardType: maestroCardType),
                          "Maestro card \(cardNumber)")
        }
        // JCB
        jcbCards.forEach { cardNumber in
            XCTAssertTrue(cards.isValid(cardNumber: cardNumber, cardType: jcbCardType), "JCB card \(cardNumber)")
        }
    }

    func testInvalidCardNumberWithType() {
        let invalidCards = ["4651997672049323",
         "5185868732238231",
         "62699920581",
         "6221558812340000567678"
            ]
        // Validate with the wrong card type
        invalidCards.forEach { cardNumber in
                XCTAssertFalse(cards.isValid(cardNumber: cardNumber, cardType: jcbCardType))
        }
        // Visa
        XCTAssertFalse(cards.isValid(cardNumber: "4651997672049323", cardType: visaCardType))
        // Mastercard
        XCTAssertFalse(cards.isValid(cardNumber: "5185868732238231", cardType: mastercardCardType))
        // UnionPay
        XCTAssertFalse(cards.isValid(cardNumber: "62699920581", cardType: unionPayCardType))
        XCTAssertFalse(cards.isValid(cardNumber: "6221558812340000567678", cardType: unionPayCardType))
    }

    func testValidCardNumber() {
        let cardNumbers = visaCards + mastercardCards + amexCards + dinersClubCards +
            discoverCards + maestroCards + jcbCards

        cardNumbers.forEach { cardNumber in
            XCTAssertTrue(cards.isValid(cardNumber: cardNumber),
                          "card \(cardNumber)")
        }
    }

    func testInvalidCardNumber() {
        let invalidCards = ["4651997672049323",
                            "5185868732238231",
                            "62699920581",
                            "6221558812340000567678",
                            "5436787"
        ]
        // Validate with the wrong card type
        invalidCards.forEach { cardNumber in
            XCTAssertFalse(cards.isValid(cardNumber: cardNumber))
        }
        // Visa
        XCTAssertFalse(cards.isValid(cardNumber: "4651997672049323"))
        // Mastercard
        XCTAssertFalse(cards.isValid(cardNumber: "5185868732238231"))
        // UnionPay
        XCTAssertFalse(cards.isValid(cardNumber: "62699920581"))
        XCTAssertFalse(cards.isValid(cardNumber: "6221558812340000567678"))
    }

    func testValidExpirationDate() {
        [
            ["01", "2022"],
            ["07", "2025"],
            ["05", "21"],
            ["06", "22"]
        ].forEach { date in
            XCTAssertTrue(cards.isValid(expirationMonth: date[0], expirationYear: date[1]))
        }
    }

    func testInvalidExpirationDate() {
        [
            ["01", "2018"],
            ["07", "2009"],
            ["15", "16"],
            ["06", "09"],
            ["08", "021"],
            ["hello", "world"]
        ].forEach { date in
            XCTAssertFalse(cards.isValid(expirationMonth: date[0], expirationYear: date[1]))
        }
    }

    func testValidCvv() {
        XCTAssertTrue(cards.isValid(cvv: "100", cardType: visaCardType))
        XCTAssertTrue(cards.isValid(cvv: "999", cardType: visaCardType))
        XCTAssertTrue(cards.isValid(cvv: "9991", cardType: amexCardType))
    }

    func testInvalidCvv() {
        XCTAssertFalse(cards.isValid(cvv: "1", cardType: visaCardType))
        XCTAssertFalse(cards.isValid(cvv: "9991", cardType: visaCardType))
        XCTAssertFalse(cards.isValid(cvv: "999", cardType: amexCardType))
        XCTAssertFalse(cards.isValid(cvv: "100", cardType: amexCardType))
    }

    func testStandardizeCardNumber() {
        [
            ["4242 4242 4242 4242", "4242424242424242"],
            ["4242424 24242copypaste some text with it", "424242424242"],
            ["ao23ao23ao23ao23", "23232323"]
        ].forEach { cardNumbers in
            XCTAssertEqual(cards.standardize(cardNumber: cardNumbers[0]), cardNumbers[1])
        }
    }

    func testStandardizeExpirationDate() {
        // tests: actual, expected month, expected year
        let tests = [
            ["05/2020", "05", "20"],
            ["11/2021", "11", "21"],
            ["5", "05", ""],
            ["11", "11", ""],
            ["1120", "11", "20"],
            // empty string
            ["", "", ""]
        ]

        tests.forEach { expirationDates in
            let (month: actualMonth, year: actualYear) = cards.standardize(expirationDate: expirationDates[0])
            XCTAssertEqual(actualMonth, expirationDates[1])
            XCTAssertEqual(actualYear, expirationDates[2])
        }
    }

}

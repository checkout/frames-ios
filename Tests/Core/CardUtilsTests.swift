import XCTest
@testable import Frames
import Checkout

class CardUtilsTests: XCTestCase {

    let cards = CardUtils()
    let visaCards = ["4651997672049328", "4485958561669511", "4929280692848862", "4000001234562345678"]
    let mastercardCards = ["5185868732238239", "5490767572618494", "5336308433060853"]
    let amexCards = ["341347759839189", "346379996281789", "378587251292074"]
    let dinersClubCards = ["30569309025904", "38520000023237", "36148900647913"]
    let discoverCards = ["6011000400000000", "6011111111111117", "6011000990139424"]
    let unionPayCards = ["6269992058134322", "6221258812340000", "6221558812340000"]
    let maestroCards = ["6921566956623303", "6945584356562221", "6762006582539153"]
    let jcbCards = ["3566002020360505", "353445444300732639", "3537286818376838569"]

    let invalidCards = ["4651997672049324", "5185868732238231", "341347759839182", "30569309025906", "6011000400000004"]

    func testFormatCardNumber() {
        // Visa
        [
            ["4651997672049328", "4651 9976 7204 9328"],
            ["4485958561669511", "4485 9585 6166 9511"],
            ["4000001234562345678", "4000 0012 3456 2345678"],
            ["4", "4"]
            ].forEach {
                XCTAssertEqual(cards.format(cardNumber: $0[0], scheme: .visa), $0[1])
        }
        // Mastercard
        [
            ["5185868732238239", "5185 8687 3223 8239"],
            ["5490767572618494", "5490 7675 7261 8494"]
            ].forEach {
                XCTAssertEqual(cards.format(cardNumber: $0[0], scheme: .mastercard), $0[1])
        }
        // American Express
        [
            ["341347759839189", "3413 477598 39189"],
            ["346379996281789", "3463 799962 81789"]
            ].forEach {
                XCTAssertEqual(cards.format(cardNumber: $0[0], scheme: .americanExpress), $0[1])
        }
        // Diners Club
        [
            ["30569309025904", "3056 930902 5904"],
            ["38520000023237", "3852 000002 3237"]
            ].forEach {
                XCTAssertEqual(cards.format(cardNumber: $0[0], scheme: .dinersClub), $0[1])
        }
        // Discover
        [
            ["6011000400000000", "6011 0004 0000 0000"],
            ["6011111111111117", "6011 1111 1111 1117"]
            ].forEach {
                XCTAssertEqual(cards.format(cardNumber: $0[0], scheme: .discover), $0[1])
        }
        // Maestro
        [
            ["6921566956623303", "6921 5669 5662 3303"],
            ["6945584356562221", "6945 5843 5656 2221"]
            ].forEach {
                XCTAssertEqual(cards.format(cardNumber: $0[0], scheme: .maestro()), $0[1])
        }
        // JCB
        [
            ["3566002020360505", "3566 0020 2036 0505"],
            ["353445444300732639", "3534 4544 4300 732639"]
            ].forEach {
                XCTAssertEqual(cards.format(cardNumber: $0[0], scheme: .jcb), $0[1])
        }
    }

    func testStandardizeCardNumber() {
        [
            ["4242 4242 4242 4242", "4242424242424242"],
            ["4242424 24242copypaste some text with it", "424242424242"],
            ["ao23ao23ao23ao23", "23232323"]
        ].forEach { cardNumbers in
            XCTAssertEqual(cards.removeNonDigits(from: cardNumbers[0]), cardNumbers[1])
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

    func testCardGaps() {
        XCTAssertEqual(Card.Scheme.allCases.filter { cards.cardGaps[$0] == nil }, [.unknown])
    }
}

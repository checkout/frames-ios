import XCTest
import Checkout
@testable import Frames

class CardListCellTests: XCTestCase {

    var cardListCell = CardListCell()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        cardListCell = CardListCell()
    }

    func testEmptyInitialization() {
        let cardListCell = CardListCell()
        XCTAssertNil(cardListCell.schemeImageView.image)
        XCTAssertNil(cardListCell.selectedImageView.image)
    }

    func testCoderInitialization() {
        let coder = NSKeyedUnarchiver(forReadingWith: Data())
        let cardListCell = CardListCell(coder: coder)
        XCTAssertNil(cardListCell?.schemeImageView.image)
        XCTAssertNil(cardListCell?.selectedImageView.image)
    }

    func testInitialization() {
        let cardListCell = CardListCell(style: .default, reuseIdentifier: nil)
        XCTAssertNil(cardListCell.schemeImageView.image)
        XCTAssertNil(cardListCell.selectedImageView.image)
    }

    func testSetSchemeIcons_WithIcons() {
        let schemesWithoutIcons: [Card.Scheme] = [.mada, .unknown]
        let testCases = Set(Card.Scheme.allCases).symmetricDifference(schemesWithoutIcons)

        testCases.forEach { scheme in
            cardListCell.schemeImageView.image = nil
            cardListCell.setSchemeIcon(scheme: scheme)
            XCTAssertNotNil(cardListCell.schemeImageView.image)
        }
    }

    func testSetSchemeIcons_WithoutIcons() {
        let testCases: [Card.Scheme] = [.mada, .unknown]

        testCases.forEach { scheme in
            cardListCell.setSchemeIcon(scheme: .visa)
            XCTAssertNotNil(cardListCell.schemeImageView.image)

            cardListCell.setSchemeIcon(scheme: scheme)
            XCTAssertNil(cardListCell.schemeImageView.image)
        }
    }

    func testSelectCardCell() {
        XCTAssertNil(cardListCell.selectedImageView.image)
        cardListCell.setSelected(true, animated: false)
        XCTAssertNotNil(cardListCell.selectedImageView.image)
    }

    func testUnselectCardCell() {
        testSelectCardCell()
        cardListCell.setSelected(false, animated: false)
        XCTAssertNil(cardListCell.selectedImageView.image)
    }

}

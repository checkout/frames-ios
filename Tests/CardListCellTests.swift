import XCTest
@testable import FramesIos

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

    func testSetSchemeIcons() {
        XCTAssertNil(cardListCell.schemeImageView.image)
        cardListCell.setSchemeIcon(scheme: .visa)
        XCTAssertNotNil(cardListCell.schemeImageView.image)
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

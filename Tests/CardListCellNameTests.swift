import XCTest
@testable import FramesIos

class CardListCellNameTests: XCTestCase {

    var cardListCellName = CardListCellName()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        cardListCellName = CardListCellName()
    }

    func testEmptyInitialization() {
        let cardListCellName = CardListCellName ()
        XCTAssertNil(cardListCellName.schemeImageView.image)
        XCTAssertNil(cardListCellName.selectedImageView.image)
    }

    func testCoderInitialization() {
        let coder = NSKeyedUnarchiver(forReadingWith: Data())
        let cardListCellName = CardListCellName (coder: coder)
        XCTAssertNil(cardListCellName?.schemeImageView.image)
        XCTAssertNil(cardListCellName?.selectedImageView.image)
    }

    func testInitialization() {
        let cardListCellName = CardListCellName (style: .default, reuseIdentifier: nil)
        XCTAssertNil(cardListCellName.schemeImageView.image)
        XCTAssertNil(cardListCellName.selectedImageView.image)
    }

}

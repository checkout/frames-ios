import XCTest
@testable import Frames

struct ErrorInputLabelStyleImp: ErrorInputLabelStyle {
    var isHidden: Bool
    var text: String { "Error" }
    var font: UIFont { UIFont.systemFont(ofSize: 17) }
    var textColor: UIColor { .red }
    var backgroundColor: UIColor { .white }
    var tintColor: UIColor { .red }
    var isWarningSympoleOnLeft: Bool { true }
    var height: Double { 120 }
}

class BillingFormTextFieldErrorViewTests: XCTestCase {
    var errorView: BillingFormTextFieldErrorView!
    let style = ErrorInputLabelStyleImp(isHidden: false)

    override func setUp() {
        super.setUp()
        errorView = BillingFormTextFieldErrorView(style: style)
    }
    
    func testStyleIsHidden(){
        XCTAssertEqual(errorView.isHidden, style.isHidden)
    }
    
    func testStyleFont(){
        XCTAssertEqual(errorView.headerLabel.font, style.font)
    }
    
    func testStyleTextColor(){
        XCTAssertEqual(errorView.headerLabel.textColor, style.textColor)
    }
    
    func testStyleBackgroundColor(){
        XCTAssertEqual(errorView.backgroundColor, style.backgroundColor)
    }
    
    func testStyleTintColor(){
        XCTAssertEqual(errorView.image.tintColor, style.tintColor)
    }

}

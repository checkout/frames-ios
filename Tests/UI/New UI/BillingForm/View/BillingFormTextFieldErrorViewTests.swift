import XCTest
@testable import Frames

struct ErrorInputLabelStyleImp: ElementErrorViewStyle {
    var isHidden: Bool
    var text: String
    var font: UIFont
    var textColor: UIColor
    var backgroundColor: UIColor
    var tintColor: UIColor
    var isWarningImageOnLeft: Bool
    var height: Double

    init(
        isHidden: Bool = false,
        text: String = "Error",
        font: UIFont = UIFont.systemFont(ofSize: 17),
        textColor: UIColor = .red,
        backgroundColor: UIColor = .white,
        tintColor: UIColor = .red,
        isWarningImageOnLeft: Bool = true,
        height: Double = 120 ) {
            self.isHidden = isHidden
            self.text = text
            self.font = font
            self.textColor = textColor
            self.backgroundColor = backgroundColor
            self.tintColor = tintColor
            self.isWarningImageOnLeft = isWarningImageOnLeft
            self.height = height
        }
}

class BillingFormTextFieldErrorViewTests: XCTestCase {
    var errorView: ErrorView!
    let style = ErrorInputLabelStyleImp(isHidden: false)

    override func setUp() {
        super.setUp()
        UIFont.loadAllCheckoutFonts
        errorView = ErrorView(style: style)
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

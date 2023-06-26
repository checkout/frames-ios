import XCTest
@testable import Frames

final class BorderViewTest: XCTestCase {

    func testInitDoesAddBorderLayer() {
        let borderView = BorderView()
        XCTAssertEqual(borderView.layer.sublayers?.count, 2)
    }

    func testLayoutSubviewsDoesNotAddAnotherLayer() {
        let borderView = BorderView()
        borderView.layoutSubviews()
        XCTAssertEqual(borderView.layer.sublayers?.count, 2)
    }

    func testUpdateStyleDoesNotAddLayer() {
        let borderView = BorderView()
        let style = DefaultBorderStyle(cornerRadius: 0, borderWidth: 0, normalColor: .clear, focusColor: .clear, errorColor: .clear)
        borderView.update(with: style)
        XCTAssertEqual(borderView.layer.sublayers?.count, 2)
    }

    func testInitDoesNotAddPath() throws {
        let borderView = BorderView()
        let shapeLayer = try XCTUnwrap(borderView.layer.sublayers?.first as? CAShapeLayer)
        XCTAssertNil(shapeLayer.path)
    }

    func testLayoutSubviewsDoesNotAddPathWithoutUpdateStyle() throws {
        let borderView = BorderView()
        borderView.layoutSubviews()
        let shapeLayer = try XCTUnwrap(borderView.layer.sublayers?.first as? CAShapeLayer)
        XCTAssertNil(shapeLayer.path)
    }

    func testLayersEqualToBoundsWhenLayoutSubviews() throws {
        let borderView = BorderView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        borderView.layoutSubviews()
        
        XCTAssertEqual(borderView.layer.sublayers?.isEmpty, false)
        borderView.layer.sublayers?.forEach { (layer: CALayer) in
            XCTAssertEqual((layer as? CAShapeLayer)?.frame, borderView.bounds)
        }
    }

    func testUpdateStyleDoesAddPath() throws {
        let borderView = BorderView()
        let style = DefaultBorderStyle(cornerRadius: 0, borderWidth: 0, normalColor: .clear, focusColor: .clear, errorColor: .clear)
        borderView.update(with: style)
        borderView.layoutSubviews()
        
        XCTAssertEqual(borderView.layer.sublayers?.isEmpty, false)
        borderView.layer.sublayers?.forEach { (layer: CALayer) in
            XCTAssertNotNil((layer as? CAShapeLayer)?.path)
        }
    }

    func testBorderColorUpdate() throws {
        let borderView = BorderView()
        let expectedColor = UIColor.black
        borderView.updateBorderColor(to: expectedColor)
        let shapeLayer = try XCTUnwrap(borderView.layer.sublayers?.last as? CAShapeLayer)
        XCTAssertEqual(shapeLayer.strokeColor, expectedColor.cgColor)
    }
    
    func testBackgroundColorUpdate() throws {
        let borderView = BorderView()
        let expectedColor = UIColor.black
        borderView.backgroundColor = expectedColor
        let shapeLayer = try XCTUnwrap(borderView.layer.sublayers?.first as? CAShapeLayer)
        XCTAssertEqual(shapeLayer.fillColor, expectedColor.cgColor)
    }
}

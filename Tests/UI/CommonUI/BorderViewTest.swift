import XCTest
@testable import Frames

final class BorderViewTest: XCTestCase {

    func testInitDoesAddBorderLayer() {
        let borderView = BorderView()
        XCTAssertEqual(borderView.layer.sublayers?.count, 1)
    }

    func testLayoutSubviewsDoesNotAddAnotherLayer() {
        let borderView = BorderView()
        borderView.layoutSubviews()
        XCTAssertEqual(borderView.layer.sublayers?.count, 1)
    }

    func testUpdateStyleDoesNotAddLayer() {
        let borderView = BorderView()
        let style = DefaultBorderStyle()
        borderView.update(with: style)
        XCTAssertEqual(borderView.layer.sublayers?.count, 1)
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

    func testLayerFrameEqualToBoundsWhenLayoutSubviews() throws {
        let borderView = BorderView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        borderView.layoutSubviews()
        let shapeLayer = try XCTUnwrap(borderView.layer.sublayers?.first as? CAShapeLayer)
        XCTAssertEqual(shapeLayer.frame, borderView.bounds)
    }

    func testUpdateStyleDoesAddPath() throws {
        let borderView = BorderView()
        let style = DefaultBorderStyle()
        borderView.update(with: style)
        borderView.layoutSubviews()
        let shapeLayer = try XCTUnwrap(borderView.layer.sublayers?.first as? CAShapeLayer)
        XCTAssertNotNil(shapeLayer.path)
    }

    func testBorderColorUpdate() throws {
        let borderView = BorderView()
        let expectedColor = UIColor.black
        borderView.updateBorderColor(to: expectedColor)
        let shapeLayer = try XCTUnwrap(borderView.layer.sublayers?.first as? CAShapeLayer)
        XCTAssertEqual(shapeLayer.strokeColor, expectedColor.cgColor)
    }
}

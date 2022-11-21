import XCTest
@testable import Frames

final class CAShapeLayerExtensionTests: XCTestCase {

    func testCreateCustomBorderStyle() {
        let layer = CAShapeLayer()
        let style = DefaultBorderStyle()
        layer.createCustomBorder(with: style)
        XCTAssertEqual(layer.fillColor, UIColor.clear.cgColor)
        XCTAssertEqual(layer.lineWidth, style.borderWidth)
    }

    func testApplyBordersOnLeft() {
        let minX = 0
        let minY = 0
        let maxX = 100
        let maxY = 30
        let edge = UIRectEdge.left

        let layer = CAShapeLayer()
        layer.frame = CGRect(x: minX, y: minY, width: maxX, height: maxY)
        let style = DefaultBorderStyle(edges: edge, corners: nil)

        layer.createCustomBorder(with: style)
        let cgPath = layer.path

        let expectedPath = UIBezierPath()
        let startPoint = CGPoint(x: layer.bounds.minX, y: layer.bounds.minY)
        let endPoint = CGPoint(x: layer.bounds.minX, y: layer.bounds.maxY)

        expectedPath.move(to: startPoint)
        expectedPath.addLine(to: endPoint)
        let expectedCGPath = expectedPath.cgPath
        
        XCTAssertEqual(cgPath, expectedCGPath)
    }

    func testApplyBordersOnRight() {
        let minX = 0
        let minY = 0
        let maxX = 100
        let maxY = 30
        let edge = UIRectEdge.right

        let layer = CAShapeLayer()
        layer.frame = CGRect(x: minX, y: minY, width: maxX, height: maxY)
        let style = DefaultBorderStyle(edges: edge, corners: nil)

        layer.createCustomBorder(with: style)
        let cgPath = layer.path

        let expectedPath = UIBezierPath()
        let startPoint = CGPoint(x: layer.bounds.maxX, y: layer.bounds.maxY)
        let endPoint = CGPoint(x: layer.bounds.maxX, y: layer.bounds.minY)

        expectedPath.move(to: startPoint)
        expectedPath.addLine(to: endPoint)
        let expectedCGPath = expectedPath.cgPath

        XCTAssertEqual(cgPath, expectedCGPath)
    }

    func testApplyBordersOnTop() {
        let minX = 0
        let minY = 0
        let maxX = 100
        let maxY = 30
        let edge = UIRectEdge.top

        let layer = CAShapeLayer()
        layer.frame = CGRect(x: minX, y: minY, width: maxX, height: maxY)
        let style = DefaultBorderStyle(edges: edge, corners: nil)

        layer.createCustomBorder(with: style)
        let cgPath = layer.path

        let expectedPath = UIBezierPath()
        let startPoint = CGPoint(x: layer.bounds.maxX, y: layer.bounds.minY)
        let endPoint = CGPoint(x: layer.bounds.minX, y: layer.bounds.minY)

        expectedPath.move(to: startPoint)
        expectedPath.addLine(to: endPoint)
        let expectedCGPath = expectedPath.cgPath

        XCTAssertEqual(cgPath, expectedCGPath)
    }

    func testApplyBordersOnBottom() {
        let minX = 0
        let minY = 0
        let maxX = 100
        let maxY = 30
        let edge = UIRectEdge.bottom

        let layer = CAShapeLayer()
        layer.frame = CGRect(x: minX, y: minY, width: maxX, height: maxY)
        let style = DefaultBorderStyle(edges: edge, corners: nil)

        layer.createCustomBorder(with: style)
        let cgPath = layer.path

        let expectedPath = UIBezierPath()
        let startPoint = CGPoint(x: layer.bounds.minX, y: layer.bounds.maxY)
        let endPoint = CGPoint(x: layer.bounds.maxX, y: layer.bounds.maxY)

        expectedPath.move(to: startPoint)
        expectedPath.addLine(to: endPoint)
        let expectedCGPath = expectedPath.cgPath

        XCTAssertEqual(cgPath, expectedCGPath)
    }
}

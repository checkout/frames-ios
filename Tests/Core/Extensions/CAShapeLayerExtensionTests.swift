import XCTest
@testable import Frames

final class CAShapeLayerExtensionTests: XCTestCase {

    func testCreateCustomBorderStyle() {
        let layer = CAShapeLayer()
        let style = DefaultBorderStyle(cornerRadius: 0, borderWidth: 0, normalColor: .clear, focusColor: .clear, errorColor: .clear)
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
        let style = DefaultBorderStyle(cornerRadius: 0, borderWidth: 0, normalColor: .clear, focusColor: .clear, errorColor: .clear, edges: edge, corners: nil)
        let rect = layer.bounds.insetBy(dx: style.borderWidth / 2, dy: style.borderWidth / 2)

        layer.createCustomBorder(with: style)
        let cgPath = layer.path

        let expectedPath = UIBezierPath()
        let startPoint = CGPoint(x: rect.minX, y: rect.minY)
        let endPoint = CGPoint(x: rect.minX, y: rect.maxY)

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
        let style = DefaultBorderStyle(cornerRadius: 0, borderWidth: 0, normalColor: .clear, focusColor: .clear, errorColor: .clear, edges: edge, corners: nil)
        let rect = layer.bounds.insetBy(dx: style.borderWidth / 2, dy: style.borderWidth / 2)

        layer.createCustomBorder(with: style)
        let cgPath = layer.path

        let expectedPath = UIBezierPath()
        let startPoint = CGPoint(x: rect.maxX, y: rect.maxY)
        let endPoint = CGPoint(x: rect.maxX, y: rect.minY)

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
        let style = DefaultBorderStyle(cornerRadius: 0, borderWidth: 0, normalColor: .clear, focusColor: .clear, errorColor: .clear, edges: edge, corners: nil)
        let rect = layer.bounds.insetBy(dx: style.borderWidth / 2, dy: style.borderWidth / 2)

        layer.createCustomBorder(with: style)
        let cgPath = layer.path

        let expectedPath = UIBezierPath()
        let startPoint = CGPoint(x: rect.maxX, y: rect.minY)
        let endPoint = CGPoint(x: rect.minX, y: rect.minY)

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
        let style = DefaultBorderStyle(cornerRadius: 0, borderWidth: 0, normalColor: .clear, focusColor: .clear, errorColor: .clear, edges: edge, corners: nil)
        let rect = layer.bounds.insetBy(dx: style.borderWidth / 2, dy: style.borderWidth / 2)

        layer.createCustomBorder(with: style)
        let cgPath = layer.path

        let expectedPath = UIBezierPath()
        let startPoint = CGPoint(x: rect.minX, y: rect.maxY)
        let endPoint = CGPoint(x: rect.maxX, y: rect.maxY)

        expectedPath.move(to: startPoint)
        expectedPath.addLine(to: endPoint)
        let expectedCGPath = expectedPath.cgPath

        XCTAssertEqual(cgPath, expectedCGPath)
    }
}

import XCTest
@testable import Frames

final class UIBezierPathExtensionTests: XCTestCase {
    func testDrawLine(){
        let testStartX: CGFloat = 0
        let testStartY: CGFloat = 0
        let testEndX: CGFloat = 100
        let testEndY: CGFloat = 300

        let testPath = UIBezierPath()
        testPath.drawLine(startX: testStartX, startY: testStartY, endX: testEndX, endY: testEndY)
        let testCGPath = testPath.cgPath

        let expectedPath = UIBezierPath()
        expectedPath.move(to: CGPoint(x: testStartX, y: testStartY))
        expectedPath.addLine(to: CGPoint(x: testEndX, y: testEndY))
        let expectedCGPath = expectedPath.cgPath

        XCTAssertEqual(testCGPath, expectedCGPath)
    }

    func testDrawCorner(){
        let testStartX: CGFloat = 0
        let testStartY: CGFloat = 0
        let testEndX: CGFloat = 100
        let testEndY: CGFloat = 300
        let testControlX: CGFloat = 200
        let testControlY: CGFloat = 200

        let testPath = UIBezierPath()
        testPath.drawCorner(startX: testStartX,
                            startY: testStartY,
                            endX: testEndX,
                            endY: testEndY,
                            controlX: testControlX,
                            controlY: testControlY)
        let testCGPath = testPath.cgPath

        let expectedPath = UIBezierPath()
        let startPoint = CGPoint(x: testStartX, y: testStartY)
        let endPoint = CGPoint(x: testEndX, y: testEndY)
        let controlPoint = CGPoint(x: testControlX, y: testControlY)
        expectedPath.move(to: startPoint)
        expectedPath.addQuadCurve(to: endPoint, controlPoint: controlPoint)
        let expectedCGPath = expectedPath.cgPath

        XCTAssertEqual(testCGPath, expectedCGPath)
    }
}

//
//  SecureDisplayViewTests.swift
//  FramesTests
//
//  Created by Alex Ioja-Yang
//  Copyright © 2022 Checkout. All rights reserved.
//
import XCTest
import UIKit
@testable import Frames

final class SecureDisplayViewUIKitTests: XCTestCase {

    func testCreateView() {
        let view = SecureDisplayView.secure(UIView())
        validateView(view)
    }

    func testSetAccessibilityLabel() {
        let view = SecureDisplayView.secure(UIView())
        view.isAccessibilityElement = true
        view.accessibilityLabel = "Shouldn't be"

        validateView(view)
    }

    func testInsertSubview() {
        let view = SecureDisplayView.secure(UIView())
        view.insertSubview(UILabel(), at: 2)

        validateView(view)
    }

    func testExchangeSubview() {
        let view = SecureDisplayView.secure(UIView())
        view.exchangeSubview(at: 3, withSubviewAt: 0)

        validateView(view)
    }

    func testAddingSubview() {
        let view = SecureDisplayView.secure(UIView())
        view.addSubview(UILabel())

        validateView(view)
    }

    func testInsertSubviewBelowSubview() {
        let view = SecureDisplayView.secure(UIView())
        view.insertSubview(UIButton(), belowSubview: UILabel())

        validateView(view)
    }

    func testInsertSubviewAboveSubview() {
        let view = SecureDisplayView.secure(UIView())
        view.insertSubview(UITextField(), aboveSubview: UILabel())

        validateView(view)
    }

    func testBringSubviewToFront() {
        let view = SecureDisplayView.secure(UIView())
        view.bringSubviewToFront(UILabel())

        validateView(view)
    }

    func testSendSubviewToBack() {
        let view = SecureDisplayView.secure(UIView())
        view.sendSubviewToBack(UILabel())

        validateView(view)
    }

    func testDidAddSubview() {
        let view = SecureDisplayView.secure(UIView())
        view.didAddSubview(UIButton())

        validateView(view)
    }

    func testWillRemoveSubview() {
        let view = SecureDisplayView.secure(UIView())
        view.willRemoveSubview(UITextField())

        validateView(view)
    }

    // MARK: Accepts inputs
    func testGestureExistsWhenContentAcceptsInput() {
        let toSecure = UITextField()
        let securedView = SecureDisplayView.secure(toSecure, acceptsInput: true)
        
        validateView(securedView)
        XCTAssertEqual(securedView.gestureRecognizers?.count, 1)
    }

    func testNoGesturesExist() {
        let toSecure = UITextField()
        let securedView = SecureDisplayView.secure(toSecure, acceptsInput: false)

        validateView(securedView)
        XCTAssertNil(securedView.gestureRecognizers)
    }

    @available(iOS 11.0, *)
    func testSecureView() {
        let secureText = "Hide ME NoW"
        let securedLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        securedLabel.text = secureText

        let secureView = SecureDisplayView(secure: securedLabel)

        // Ensure view is protecting content as expected
        validateView(secureView)

        // After forcing layout changes ensure protection still valid
        secureView.setNeedsLayout()
        secureView.setNeedsDisplay()
        secureView.layoutSubviews()
        secureView.layoutIfNeeded()
        validateView(secureView)

        // Try copying view and ensure still safe
        let secureViewArchive = try! NSKeyedArchiver.archivedData(withRootObject: secureView, requiringSecureCoding: true)
        XCTAssertThrowsError(try NSKeyedUnarchiver.unarchivedObject(ofClass: UIView.self, from: secureViewArchive))
        XCTAssertThrowsError(try NSKeyedUnarchiver.unarchivedObject(ofClass: SecureDisplayView.self, from: secureViewArchive))

        XCTAssertNotNil(securedLabel)
        XCTAssertEqual(securedLabel.text, secureText)
        XCTAssertTrue(securedLabel.superview === secureView)
        validateView(securedLabel.superview!)
    }

    func testIdealSizingOfProtectedViewIsProvidedToSecureViewUser() {
        let secureText = "Hide ME NoW"
        let securedLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        securedLabel.text = secureText

        let secureView = SecureDisplayView(secure: securedLabel)
        let desiredTargetSize = CGSize(width: 100, height: 200)

        XCTAssertNotEqual(securedLabel.systemLayoutSizeFitting(desiredTargetSize), .zero)
        XCTAssertNotEqual(secureView.systemLayoutSizeFitting(desiredTargetSize), .zero)
        XCTAssertEqual(secureView.systemLayoutSizeFitting(desiredTargetSize),
                       securedLabel.systemLayoutSizeFitting(desiredTargetSize))
    }

    func testSetProtectedViewAccessibilityLabel() {
        let secureText = "Hide ME NoW"
        let securedLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        securedLabel.isAccessibilityElement = true
        securedLabel.accessibilityLabel = secureText

        let secureView = SecureDisplayView(secure: securedLabel)
        secureView.isAccessibilityElement = true
        secureView.accessibilityLabel = "Shouldn't be"

        validateView(secureView)
    }

    private func validateView(_ testView: UIView, line: UInt = #line) {
        XCTAssertFalse(testView is UILabel)
        XCTAssertFalse(testView is UITextField)
        XCTAssertTrue(testView.subviews.isEmpty, line: line)
        XCTAssertNil(testView.inputView, line: line)
        XCTAssertNil(testView.inputViewController, line: line)
        XCTAssertNil(testView.textInputMode, line: line)
        XCTAssertFalse(testView.isAccessibilityElement, line: line)
        XCTAssertNil(testView.accessibilityLabel, line: line)
        XCTAssertNil(testView.accessibilityHint, line: line)
        XCTAssertNil(testView.accessibilityValue, line: line)
        XCTAssertNil(testView.accessibilityElements, line: line)
    }
}

// For testing purposes imagine the view was copied after an archive and unarchived
extension SecureDisplayView: NSSecureCoding {
    public static var supportsSecureCoding: Bool {
        true
    }
}

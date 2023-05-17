//
//  UITextField+ExtensionsTests.swift
//  
//
//  Created by Alex Ioja-Yang on 17/05/2023.
//

import UIKit
import XCTest
@testable import Frames

final class UITextFieldExtensionsTests: XCTestCase {
    
    func testNewTextWithEmptyNewString() {
        let startText = "testing"
        let textField = UITextField()
        textField.text = startText
        
        let output = textField.newTextAfter(applyingString: "", at: NSRange(location: 0, length: 0))
        XCTAssertEqual(output, startText)
    }
    
    func testNewTextWithInvalidRange() {
        let startText = "testing"
        let textField = UITextField()
        textField.text = startText
        
        let output = textField.newTextAfter(applyingString: "", at: NSRange(location: startText.count + 2, length: 0))
        XCTAssertNil(output)
    }
    
    func testNewTextRemovingPartOfString() {
        let startText = "testing"
        let textField = UITextField()
        textField.text = startText
        
        let output = textField.newTextAfter(applyingString: "", at: NSRange(location: 1, length: 3))
        XCTAssertEqual(output, "ting")
    }
    
    func testNewTextIsAtTheEnd() {
        let startText = "testing"
        let textField = UITextField()
        textField.text = startText
        
        let output = textField.newTextAfter(applyingString: "1", at: NSRange(location: startText.count, length: 0))
        XCTAssertEqual(output, "testing1")
    }
    
    func testNewTextAtTheStart() {
        let startText = "testing"
        let textField = UITextField()
        textField.text = startText
        
        let output = textField.newTextAfter(applyingString: "1", at: NSRange(location: 0, length: 0))
        XCTAssertEqual(output, "1testing")
    }
    
    func testNewTextInsideExistingText() {
        let startText = "testing"
        let textField = UITextField()
        textField.text = startText
        
        let output = textField.newTextAfter(applyingString: "1", at: NSRange(location: 4, length: 0))
        XCTAssertEqual(output, "test1ing")
    }
    
    func testNewTextRemovesAndAdds() {
        let startText = "testing"
        let textField = UITextField()
        textField.text = startText
        
        let output = textField.newTextAfter(applyingString: "-try-", at: NSRange(location: 1, length: 3))
        XCTAssertEqual(output, "t-try-ing")
    }
    
}

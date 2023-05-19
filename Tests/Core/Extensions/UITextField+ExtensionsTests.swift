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
        
        let output = textField.replacingCharacters(in: NSRange(location: 0, length: 0), with: "")
        XCTAssertEqual(output, startText)
    }
    
    func testNewTextWithInvalidRange() {
        let startText = "testing"
        let textField = UITextField()
        textField.text = startText
        
        let output = textField.replacingCharacters(in: NSRange(location: startText.count + 2, length: 0), with: "")
        XCTAssertNil(output)
    }
    
    func testNewTextRemovingPartOfString() {
        let startText = "testing"
        let textField = UITextField()
        textField.text = startText
        
        let output = textField.replacingCharacters(in: NSRange(location: 1, length: 3), with: "")
        XCTAssertEqual(output, "ting")
    }
    
    func testNewTextIsAtTheEnd() {
        let startText = "testing"
        let textField = UITextField()
        textField.text = startText
        
        let output = textField.replacingCharacters(in: NSRange(location: startText.count, length: 0), with: "1")
        XCTAssertEqual(output, "testing1")
    }
    
    func testNewTextAtTheStart() {
        let startText = "testing"
        let textField = UITextField()
        textField.text = startText
        
        let output = textField.replacingCharacters(in: NSRange(location: 0, length: 0), with: "1")
        XCTAssertEqual(output, "1testing")
    }
    
    func testNewTextInsideExistingText() {
        let startText = "testing"
        let textField = UITextField()
        textField.text = startText
        
        let output = textField.replacingCharacters(in: NSRange(location: 4, length: 0), with: "1")
        XCTAssertEqual(output, "test1ing")
    }
    
    func testNewTextRemovesAndAdds() {
        let startText = "testing"
        let textField = UITextField()
        textField.text = startText
        
        let output = textField.replacingCharacters(in: NSRange(location: 1, length: 3), with: "-try-")
        XCTAssertEqual(output, "t-try-ing")
    }
    
}

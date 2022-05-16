//
//  File.swift
//
//
//  Created by Ehab Alsharkawy on 11/05/2022.
//


import XCTest
@testable import Frames

final class CKOColorTests: XCTestCase {

    func testColorWithHexStartingWithHashSign(){
        
        let brandeisBlue = UIColor(hex: "#0B5FF0")
        let gray = UIColor(hex: "ff0000")
        
        XCTAssertNotNil(brandeisBlue)
        XCTAssertNotEqual(brandeisBlue, gray)
    }
    
    func testColorWithHexLowercassed(){
        
        let brandeisBlue = UIColor(hex: "#0b5ff0")
        let gray = UIColor(hex: "ff0000")
        
        XCTAssertNotNil(brandeisBlue)
        XCTAssertNotEqual(brandeisBlue, gray)
    }
    
    func testColorWithHexStartingWithOutHashSign(){
        
        let brandeisBlue = UIColor(hex: "0B5FF0")
        let gray = UIColor(hex: "ff0000")
        
        XCTAssertNotNil(brandeisBlue)
        XCTAssertNotEqual(brandeisBlue, gray)
    }
    
    func testColorWithHexEndingWithWhiteSpace(){
        
        let brandeisBlue = UIColor(hex: "#0B5FF0\n")
        let gray = UIColor(hex: "ff0000")
        
        XCTAssertNotNil(brandeisBlue)
        XCTAssertNotEqual(brandeisBlue, gray)
    }
    
    func testColorWithHexWithSpaces(){
        
        let brandeisBlue = UIColor(hex: "#0 B 5 F F    0\n")
        let gray = UIColor(hex: "ff0000")
        
        XCTAssertNotNil(brandeisBlue)
        XCTAssertNotEqual(brandeisBlue, gray)
    }
    
    func testColorWithHexMoreThan6Digits(){
        
        let invalidColor = UIColor(hex: "123456789")
        let gray = UIColor(hex: "ff0000")
        
        XCTAssertNotNil(invalidColor)
        XCTAssertEqual(invalidColor, gray)
    }
    
    func testColorWithHexLessThan6Digits(){
        
        let invalidColor = UIColor(hex: "1")
        let gray = UIColor(hex: "ff0000")
        
        XCTAssertNotNil(invalidColor)
        XCTAssertEqual(invalidColor, gray)
    }
    
    func testColorWithEmptyHex(){
        
        let invalidColor = UIColor(hex: "")
        let gray = UIColor(hex: "ff0000")
        
        XCTAssertNotNil(invalidColor)
        XCTAssertEqual(invalidColor, gray)
    }
}

//
//  File.swift
//  
//
//  Created by Ehab Alsharkawy on 11/05/2022.
//


import XCTest
@testable import Frames

final class CKOFontTests: XCTestCase {
    
    func testGraphikStyleRegular() {
        UIFont.loadAllFonts

        let fontName = "GraphikLCG-Regular"
        let expectedFontName = UIFont.GraphikStyle.regular.fontName
        XCTAssertEqual(fontName, expectedFontName)

        let font = UIFont(graphikStyle: .regular, size: 20)
        
        XCTAssertNotNil(font)
    }
    
    func testGraphikStyleThin() {
        UIFont.loadAllFonts

        let fontName = "GraphikLCG-Thin"
        let expectedFontName = UIFont.GraphikStyle.thin.fontName
        XCTAssertEqual(fontName, expectedFontName)

        let font = UIFont(graphikStyle: .thin, size: 20)
        
        XCTAssertNotNil(font)
    }
    
    func testGraphikStyleLight() {
        UIFont.loadAllFonts

        let fontName = "GraphikLCG-Light"
        let expectedFontName = UIFont.GraphikStyle.light.fontName
        XCTAssertEqual(fontName, expectedFontName)

        let font = UIFont(graphikStyle: .light, size: 20)
        
        XCTAssertNotNil(font)
    }
    
    func testGraphikStyleMedium() {
        UIFont.loadAllFonts

        let fontName = "GraphikLCG-Medium"
        let expectedFontName = UIFont.GraphikStyle.medium.fontName
        XCTAssertEqual(fontName, expectedFontName)

        let font = UIFont(graphikStyle: .medium, size: 20)
        
        XCTAssertNotNil(font)
    }
    
    func testGraphikStyleSemibold() {
        UIFont.loadAllFonts

        let fontName = "GraphikLCG-Semibold"
        let expectedFontName = UIFont.GraphikStyle.semibold.fontName
        XCTAssertEqual(fontName, expectedFontName)

        let font = UIFont(graphikStyle: .semibold, size: 20)
        
        XCTAssertNotNil(font)
    }
    
    func testGraphikStyleBold() {
        UIFont.loadAllFonts

        let fontName = "GraphikLCG-Bold"
        let expectedFontName = UIFont.GraphikStyle.bold.fontName
        XCTAssertEqual(fontName, expectedFontName)

        let font = UIFont(graphikStyle: .bold, size: 20)
        
        XCTAssertNotNil(font)
    }
    
    func testGraphikStyleBlack() {
        UIFont.loadAllFonts

        let fontName = "GraphikLCG-Black"
        let expectedFontName = UIFont.GraphikStyle.black.fontName
        XCTAssertEqual(fontName, expectedFontName)

        let font = UIFont(graphikStyle: .black, size: 20)
        
        XCTAssertNotNil(font)
    }
}

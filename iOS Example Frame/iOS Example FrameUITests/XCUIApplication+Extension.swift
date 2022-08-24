//
//  XCUIApplication+Extension.swift
//  iOS Example FrameUITests
//
//  Created by Alex Ioja-Yang on 24/08/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import XCTest

extension XCUIApplication {

    func tapButton(name: String) {
        let predicate = NSPredicate(format: "label LIKE %@", name)
        let button = buttons.element(matching: predicate)
        button.tap()
    }

}

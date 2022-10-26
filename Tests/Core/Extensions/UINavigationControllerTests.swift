//
//  UINavigationControllerTests.swift
//  
//
//  Created by Ehab Alsharkawy on 25/10/2022.
//

import XCTest
@testable import Frames

final class UINavigationControllerTests: XCTestCase {

    func testCopyStyle(){
            
        let viewController1 = UIViewController()
        let mainNavigationController = UINavigationController(rootViewController: viewController1)
        mainNavigationController.customizeNavigationBarAppearance(backgroundColor: .green, foregroundColor: .black)

        let viewController2 = UIViewController()
        let currentNavigationController = UINavigationController(rootViewController: viewController2)
        currentNavigationController.copyStyle(from: mainNavigationController)

        XCTAssertEqual(mainNavigationController.viewControllers.first, viewController1)
        XCTAssertEqual(currentNavigationController.viewControllers.first, viewController2)

        if #available(iOS 13.0, *) {
            XCTAssertEqual(currentNavigationController.navigationBar.standardAppearance, mainNavigationController.navigationBar.standardAppearance)
            XCTAssertEqual(currentNavigationController.navigationBar.compactAppearance, mainNavigationController.navigationBar.compactAppearance)
            XCTAssertEqual(currentNavigationController.navigationBar.scrollEdgeAppearance, mainNavigationController.navigationBar.scrollEdgeAppearance)
        } else {
            XCTAssertEqual(currentNavigationController.navigationBar.backgroundColor, mainNavigationController.navigationBar.backgroundColor)
            XCTAssertEqual(currentNavigationController.navigationBar.barTintColor, mainNavigationController.navigationBar.barTintColor)
            XCTAssertEqual(currentNavigationController.navigationBar.shadowImage, mainNavigationController.navigationBar.shadowImage)
            let currentNavigationBarForegroundColor = (currentNavigationController.navigationBar.titleTextAttributes?.first { $0.key == .foregroundColor }?.value) as? UIColor
            let mainNavigationBarForegroundColor = (mainNavigationController.navigationBar.titleTextAttributes?.first { $0.key == .foregroundColor }?.value) as? UIColor
            XCTAssertEqual(currentNavigationBarForegroundColor, mainNavigationBarForegroundColor)
            XCTAssertTrue(currentNavigationController.navigationBar.isTranslucent)
        }
    }
}

private extension UINavigationController {
    func customizeNavigationBarAppearance(backgroundColor: UIColor, foregroundColor: UIColor) {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = backgroundColor
            appearance.shadowColor = backgroundColor
            appearance.titleTextAttributes = [.foregroundColor: foregroundColor]
            appearance.shadowImage = UIImage()
            navigationBar.tintColor = foregroundColor
            navigationBar.standardAppearance = appearance
            navigationBar.compactAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationBar.backgroundColor = backgroundColor
            navigationBar.barTintColor = backgroundColor
            navigationBar.shadowImage = UIImage()
            navigationBar.titleTextAttributes = [.foregroundColor: foregroundColor]
            navigationBar.isTranslucent = true
        }
    }

}

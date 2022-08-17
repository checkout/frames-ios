//
//  UIViewControllerExtension.swift
//  iOS Example Frame
//
//  Created by Ehab Alsharkawy.
//  Copyright © 2022 Checkout. All rights reserved.
//

import UIKit

extension UIViewController {
  func customizeNavigationBarAppearance() {
    if #available(iOS 15.0, *) {
      let appearance = UINavigationBarAppearance()
      appearance.configureWithDefaultBackground()
      appearance.backgroundColor = .white
      appearance.shadowColor = .white
      appearance.shadowImage = UIImage()
      navigationController?.navigationBar.standardAppearance = appearance
      navigationController?.navigationBar.compactAppearance = appearance
      navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    navigationController?.setNeedsStatusBarAppearanceUpdate()
  }

}

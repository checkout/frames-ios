//
//  UIViewControllerExtension.swift
//  iOS Example Frame
//
//  Created by Ehab Alsharkawy.
//  Copyright © 2022 Checkout. All rights reserved.
//

import UIKit

extension UIViewController {
  func customizeNavigationBarAppearance(backgroundColor: UIColor, foregroundColor: UIColor) {
      navigationController?.navigationBar.tintColor = foregroundColor
      navigationController?.navigationBar.backgroundColor = backgroundColor
      navigationController?.navigationBar.barTintColor = backgroundColor
      navigationController?.navigationBar.shadowImage = UIImage()
      navigationController?.navigationBar.titleTextAttributes = [ .foregroundColor: foregroundColor]
      navigationController?.navigationBar.isTranslucent = true
    if #available(iOS 13.0, *) {
      let appearance = UINavigationBarAppearance()
      appearance.configureWithTransparentBackground()
      appearance.backgroundColor = backgroundColor
      appearance.shadowColor = backgroundColor
      appearance.titleTextAttributes = [.foregroundColor: foregroundColor]
      appearance.shadowImage = UIImage()
      navigationController?.navigationBar.standardAppearance = appearance
      navigationController?.navigationBar.compactAppearance = appearance
      navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    navigationController?.setNeedsStatusBarAppearanceUpdate()
  }

  func registerKeyboardHandlers(notificationCenter: NotificationCenter,
                                keyboardWillShow: Selector,
                                keyboardWillHide: Selector) {
      notificationCenter.addObserver(self,
                                     selector: keyboardWillShow,
                                     name: UIResponder.keyboardWillShowNotification,
                                     object: nil)
      notificationCenter.addObserver(self,
                                     selector: keyboardWillHide,
                                     name: UIResponder.keyboardWillHideNotification,
                                     object: nil)
  }

  func deregisterKeyboardHandlers(notificationCenter: NotificationCenter) {
      notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
      notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }
}

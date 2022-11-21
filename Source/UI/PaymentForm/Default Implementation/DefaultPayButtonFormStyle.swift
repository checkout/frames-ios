//
//  File.swift
//  
//
//  Created by Ehab Alsharkawy on 03/08/2022.
//

import UIKit

public struct DefaultPayButtonFormStyle: ElementButtonStyle {
  public var textAlignment: NSTextAlignment = .center
  public var image: UIImage?
  public var text = Constants.LocalizationKeys.PaymentForm.PayButton.title
  public var font = FramesUIStyle.Font.actionLarge
  public var disabledTextColor: UIColor = FramesUIStyle.Color.textDisabled
  public var disabledTintColor: UIColor = FramesUIStyle.Color.actionDisabled
  public var activeTintColor: UIColor = FramesUIStyle.Color.actionPrimary
  public var backgroundColor: UIColor = FramesUIStyle.Color.actionPrimary
  public var textColor: UIColor = FramesUIStyle.Color.textActionPrimary
  public var imageTintColor: UIColor = .clear
  public var isHidden = false
  public var isEnabled = false
  public var height: Double = 56
  public var width: Double = 0
  public var borderWidth: CGFloat = 0
  public var textLeading: CGFloat = 0
  public var borderStyle: ElementBorderStyle = DefaultBorderStyle(borderWidth: 0,
                                                                 normalColor: .clear,
                                                                 focusColor: .clear,
                                                                 errorColor: .clear)
}

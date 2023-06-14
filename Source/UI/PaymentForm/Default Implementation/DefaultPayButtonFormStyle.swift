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
  public var textLeading: CGFloat = 0

    @available(*, deprecated, renamed: "borderStyle.cornerRadius")
    public var cornerRadius: CGFloat {
        get { _cornerRadius }
        set { _cornerRadius = newValue }
    }

    @available(*, deprecated, renamed: "borderStyle.borderWidth")
    public var borderWidth: CGFloat {
        get { _borderWidth }
        set { _borderWidth = newValue }
    }

    @available(*, deprecated, renamed: "borderStyle.normalColor")
    public var normalBorderColor: UIColor {
        get { _normalBorderColor }
        set { _normalBorderColor = newValue }
    }

    @available(*, deprecated, renamed: "borderStyle.focusColor")
    public var focusBorderColor: UIColor {
        get { _focusBorderColor }
        set { _focusBorderColor = newValue }
    }

    @available(*, deprecated, renamed: "borderStyle.errorColor")
    public var errorBorderColor: UIColor {
        get { _errorBorderColor }
        set { _errorBorderColor = newValue }
    }

    internal var _cornerRadius: CGFloat = Constants.Style.BorderStyle.cornerRadius
    internal var _borderWidth: CGFloat = 0
    internal var _normalBorderColor: UIColor = .clear
    internal var _focusBorderColor: UIColor = .clear
    internal var _errorBorderColor: UIColor = .clear

    public lazy var borderStyle: ElementBorderStyle = {
        DefaultBorderStyle(cornerRadius: _cornerRadius,
                           borderWidth: _borderWidth,
                           normalColor: _normalBorderColor,
                           focusColor: _focusBorderColor,
                           errorColor: _errorBorderColor)
    }()
}

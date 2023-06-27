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
        get { borderStyle.cornerRadius }
        set { borderStyle.cornerRadius = newValue }
    }

    @available(*, deprecated, renamed: "borderStyle.borderWidth")
    public var borderWidth: CGFloat {
        get { borderStyle.borderWidth }
        set { borderStyle.borderWidth = newValue }
    }

    @available(*, deprecated, renamed: "borderStyle.normalColor")
    public var normalBorderColor: UIColor {
        get { borderStyle.normalColor }
        set { borderStyle.normalColor = newValue }
    }

    @available(*, deprecated, renamed: "borderStyle.focusColor")
    public var focusBorderColor: UIColor {
        get { borderStyle.focusColor }
        set { borderStyle.focusColor = newValue }
    }

    @available(*, deprecated, renamed: "borderStyle.errorColor")
    public var errorBorderColor: UIColor {
        get { borderStyle.errorColor }
        set { borderStyle.errorColor = newValue }
    }

    public var borderStyle: ElementBorderStyle = DefaultBorderStyle(cornerRadius: Constants.Style.BorderStyle.cornerRadius,
                                                                    borderWidth: 0,
                                                                    normalColor: .clear,
                                                                    focusColor: .clear,
                                                                    errorColor: .clear)
}

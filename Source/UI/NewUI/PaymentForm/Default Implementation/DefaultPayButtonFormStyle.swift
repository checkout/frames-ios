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
  public var text: String = Constants.LocalizationKeys.PaymentForm.PayButton.title
  public var font: UIFont = UIFont(graphikStyle: .medium, size: Constants.Style.PaymentForm.PayButton.fontSize.rawValue)
  public var disabledTextColor: UIColor = .white
  public var disabledTintColor: UIColor = .doveGray
  public var activeTintColor: UIColor = .brandeisBlue
  public var backgroundColor: UIColor = .brandeisBlue
  public var textColor: UIColor = .white
  public var normalBorderColor: UIColor = .clear
  public var focusBorderColor: UIColor = .clear
  public var errorBorderColor: UIColor = .clear
  public var imageTintColor: UIColor = .clear
  public var isHidden = false
  public var isEnabled = false
  public var height: Double = 56
  public var width: Double = 0
  public var cornerRadius: CGFloat = 10
  public var borderWidth: CGFloat = 0
  public var textLeading: CGFloat = 0
}

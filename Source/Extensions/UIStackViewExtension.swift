//
//  File.swift
//  
//
//  Created by Ehab Alsharkawy on 03/08/2022.
//

import UIKit

extension UIStackView {

  func addArrangedSubviews(_ views: [UIView]) {
    for element in views {
      addArrangedSubview(element)
    }
  }
}

//
//  PaymentHeaderView.swift
//  Frames
//
//  Created by Ehab Alsharkawy
//  Copyright © 2022 Checkout. All rights reserved.
//

import UIKit

public final class PaymentHeaderView: UIView {
  private var style: PaymentHeaderCellStyle?

  private var stackView: UIStackView = {
    let view = UIStackView().disabledAutoresizingIntoConstraints()
    view.axis = .vertical
    view.spacing = 10
    return view
  }()

  private lazy var headerLabel: LabelView = {
    LabelView()
  }()

  private lazy var subtitleLabel: LabelView = {
    LabelView()
  }()

  private(set) lazy var iconsViewContainer: UIView = {
    UIView()
  }()

  private(set) lazy var iconsStackView: UIStackView = {
    let view = UIStackView().disabledAutoresizingIntoConstraints()
    view.axis = .horizontal
    view.alignment = .leading
    view.distribution = .fillEqually
    view.spacing = Constants.Padding.xs.rawValue
    return view
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViewsInOrder()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func update(style: PaymentHeaderCellStyle?) {
    guard let style = style else { return }
    self.style = style

    backgroundColor = style.backgroundColor
    headerLabel.isHidden = style.headerLabel == nil
    subtitleLabel.isHidden = style.subtitleLabel == nil

    if let headerStyle = style.headerLabel {
      headerLabel.update(with: headerStyle)
    }
    if let subtitleStyle = style.subtitleLabel {
      subtitleLabel.update(with: subtitleStyle)
    }

    updateIconsStack()
  }

  private func updateIconsStack() {
    guard let icons = style?.schemaIcons else {
      iconsStackView.isHidden = true
      return
    }
    iconsStackView.isHidden = false
    for image in icons where image != nil {
      let imageView = UIImageView().disabledAutoresizingIntoConstraints()
      imageView.image = image?.withRenderingMode(.alwaysOriginal)
      imageView.contentMode = .scaleAspectFit
      imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
      imageView.widthAnchor.constraint(equalToConstant: 33).isActive = true
      iconsStackView.addArrangedSubview(imageView)
    }
  }
}

extension PaymentHeaderView {

  private func setupViewsInOrder() {
    setupMainStackView()
    setupIconStackView()
    addArrangedSubview()
  }

  private func addArrangedSubview() {
    stackView.addArrangedSubview(headerLabel)
    stackView.addArrangedSubview(subtitleLabel)
    stackView.addArrangedSubview(iconsViewContainer)
  }

  private func setupMainStackView() {
    addSubview(stackView)
    stackView.setupConstraintEqualTo(view: self)
  }

  private func setupIconStackView() {
    iconsViewContainer.addSubview(iconsStackView)
    NSLayoutConstraint.activate([
      iconsStackView.topAnchor.constraint(equalTo: iconsViewContainer.topAnchor),
      iconsStackView.leadingAnchor.constraint(equalTo: iconsViewContainer.safeLeadingAnchor),
      iconsStackView.trailingAnchor.constraint(lessThanOrEqualTo: iconsViewContainer.safeTrailingAnchor),
      iconsStackView.bottomAnchor.constraint(equalTo: iconsViewContainer.bottomAnchor, constant: -Constants.Padding.l.rawValue)
    ])
  }
}

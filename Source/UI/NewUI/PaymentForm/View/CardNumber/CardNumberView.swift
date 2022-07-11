//
//  CardNumberView.swift
//  Frames
//
//  Created by Harry Brown on 05/07/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import UIKit

protocol CardNumberViewProtocol: AnyObject {
  var schemeIcon: Constants.Bundle.SchemeIcon { get set }
}

final class CardNumberView: UIView, CardNumberViewProtocol {
  private let viewModel: CardNumberViewModelProtocol

  var schemeIcon = Constants.Bundle.SchemeIcon.blank {
    didSet {
      if schemeIcon != oldValue {
        updateIcon()
      }
    }
  }

  private lazy var cardNumberInputView: InputView = {
    let view = InputView().disabledAutoresizingIntoConstraints()
    view.delegate = viewModel
    return view
  }()

  init(viewModel: CardNumberViewModelProtocol) {
    self.viewModel = viewModel

    super.init(frame: .zero)
    setupView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func update(style: CellTextFieldStyle?) {
    cardNumberInputView.update(style: style, image: image(for: schemeIcon))
  }

  private func setupView() {
    addSubview(cardNumberInputView)
    cardNumberInputView.setupConstraintEqualTo(view: self)
  }

  private func updateIcon() {
    cardNumberInputView.update(image: image(for: schemeIcon), withAnimation: true)
  }

  private func image(for schemeIcon: Constants.Bundle.SchemeIcon) -> UIImage? {
    return schemeIcon.rawValue.image(forClass: Self.self)
  }
}

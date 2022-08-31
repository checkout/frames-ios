//
//  CardholderView.swift
//  
//
//  Created by Alex Ioja-Yang on 16/08/2022.
//

import UIKit

final class CardholderView: UIView {

    private enum Constants {
        static let inputAllowedCharacterSet = CharacterSet.letters.union([" ", "-", "'"])
    }

    private var style: CellTextFieldStyle?
    private let viewModel: CardholderViewModel

    private lazy var cardholderInputView: InputView = {
        let view = InputView().disabledAutoresizingIntoConstraints()
        view.delegate = self
        view.textFieldView.textField.textContentType = .name
        view.textFieldView.textField.keyboardType = .alphabet
        view.textFieldView.textField.autocapitalizationType = .words
        return view
    }()

    init(viewModel: CardholderViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)

        addSubview(cardholderInputView)
        cardholderInputView.setupConstraintEqualTo(view: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(style: CellTextFieldStyle, text: String?) {
        self.style = style
        cardholderInputView.update(style: style, textFieldValue: text)
    }

    private func updateErrorViewStyle(isHidden: Bool, textfieldText: String?) {
        style?.error?.isHidden = isHidden
        cardholderInputView.update(style: style)
    }

}

extension CardholderView: TextFieldViewDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) {}
    func textFieldShouldReturn() -> Bool { true }
    func textFieldShouldEndEditing(textField: UITextField, replacementString: String) -> Bool { true }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        Constants.inputAllowedCharacterSet
            .isSuperset(of: CharacterSet(charactersIn: string))
    }

    func textFieldShouldChangeCharactersIn(textField: UITextField, replacementString string: String) {
        viewModel.inputUpdated(to: textField.text ?? "")
    }

}

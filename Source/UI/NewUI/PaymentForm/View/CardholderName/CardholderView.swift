//
//  CardholderView.swift
//  
//
//  Created by Alex Ioja-Yang on 16/08/2022.
//

import UIKit

final class CardholderView: UIView {

    private var style: CellTextFieldStyle?
    private let viewModel: CardholderViewModel

    private lazy var cardholderInputView: InputView = {
        let view = InputView().disabledAutoresizingIntoConstraints()
        view.delegate = self
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

    func update(style: CellTextFieldStyle) {
        self.style = style
        //      viewModel.updateInput(to: self.style?.textfield.text)
        //      self.style?.textfield.text = viewModel.isInputValid ? viewModel.cvv : ""
        cardholderInputView.update(style: style)
    }

    private func updateErrorViewStyle(isHidden: Bool, textfieldText: String?) {
        style?.error?.isHidden = isHidden
        //      style?.textfield.text = viewModel.cvv
        cardholderInputView.update(style: style)
    }

}

extension CardholderView: TextFieldViewDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) { }
    func textFieldShouldReturn() -> Bool { true }
    func textFieldShouldEndEditing(textField: UITextField, replacementString: String) -> Bool { true }
    func textFieldShouldChangeCharactersIn(textField: UITextField, replacementString string: String) { }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { true }

    /*
     
     private let viewModel: SecurityCodeViewModel
     
     init(viewModel: SecurityCodeViewModel) {
     self.viewModel = viewModel
     super.init(frame: .zero)
     
     viewModel.delegate = self
     // setup security code view
     addSubview(codeInputView)
     codeInputView.setupConstraintEqualTo(view: self)
     }
     
     func update(style: CellTextFieldStyle?) {
     self.style = style
     self.style?.textfield.isSupportingNumericKeyboard = true
     viewModel.updateInput(to: self.style?.textfield.text)
     self.style?.textfield.text = viewModel.isInputValid ? viewModel.cvv : ""
     codeInputView.update(style: self.style)
     }
     
     func updateCardScheme(cardScheme: Card.Scheme) {
     viewModel.updateScheme(to: cardScheme)
     }
     
     private func updateErrorViewStyle(isHidden: Bool, textfieldText: String?) {
     style?.error?.isHidden = isHidden
     style?.textfield.text = viewModel.cvv
     codeInputView.update(style: style)
     }
     
     */
}

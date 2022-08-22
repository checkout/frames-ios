//
//  File.swift
//  
//
//  Created by Ehab Alsharkawy on 22/08/2022.
//

import UIKit
import Checkout

extension PaymentViewController: SelectionButtonViewDelegate {
    func selectionButtonIsPressed() {
        delegate?.addBillingButtonIsPressed(sender: navigationController)
    }
}

extension PaymentViewController: BillingFormSummaryViewDelegate {
    func summaryButtonIsPressed() {
        delegate?.editBillingButtonIsPressed(sender: navigationController)
    }
}

extension PaymentViewController: ExpiryDateViewDelegate {
    func update(result: Result<ExpiryDate, ExpiryDateError>) {
        delegate?.expiryDateIsUpdated(result: result)
    }
}

extension PaymentViewController: CardholderDelegate {
    func cardholderUpdated(to cardholderInput: String) {
        delegate?.cardholderIsUpdated(value: cardholderInput)
    }
}

extension PaymentViewController: SecurityCodeViewDelegate {
    func update(result: Result<String, SecurityCodeError>) {
        delegate?.securityCodeIsUpdated(result: result)
    }
}

extension PaymentViewController: ButtonViewDelegate {
    func selectionButtonIsPressed(sender: UIView) {
        delegate?.payButtonIsPressed()
    }
}

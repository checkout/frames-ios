//
//  PhoneExtensions.swift
//  
//
//  Created by Alex Ioja-Yang on 24/11/2022.
//

import Foundation

extension Phone {

    init?(string: String) {
        let validatorFormatted = PhoneNumberValidator.shared.formatForDisplay(text: string)
        // Formatting for display adds an international prefix, which makes it easy to separate country code reliably
        let validatorFormattedArray = validatorFormatted.components(separatedBy: " ")
        guard validatorFormattedArray.count > 1 else {
            return nil
        }
        self = Phone(number: validatorFormattedArray.dropFirst().joined(),
                     country: Country(dialingCode: validatorFormattedArray[0]))
    }

    func displayFormatted() -> String {
        if number?.starts(with: "+") == true {
            return PhoneNumberValidator.shared.formatForDisplay(text: number ?? "")
        } else {
            return PhoneNumberValidator.shared.formatForDisplay(text: "+\(country?.dialingCode ?? "")\(number ?? "")")
        }
    }

}

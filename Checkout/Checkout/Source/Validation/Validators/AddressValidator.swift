//
//  AddressValidator.swift
//  
//
//  Created by Daven.Gomes on 18/11/2021.
//

import Foundation

protocol AddressValidating {
  func validate(_ address: Address) -> ValidationResult<ValidationError.Address>
}

final class AddressValidator: AddressValidating {
  func validate(_ address: Address) -> ValidationResult<ValidationError.Address> {
    if let addressLine1 = address.addressLine1, addressLine1.count > Constants.Address.addressLine1Length {
      return .failure(.addressLine1IncorrectLength)
    }

    if let addressLine2 = address.addressLine2, addressLine2.count > Constants.Address.addressLine2Length {
      return .failure(.addressLine2IncorrectLength)
    }

    if let city = address.city, city.count > Constants.Address.cityLength {
      return .failure(.invalidCityLength)
    }

    if let state = address.state, state.count > Constants.Address.stateLength {
      return .failure(.invalidStateLength)
    }

    if let zip = address.zip, zip.count > Constants.Address.zipLength {
      return .failure(.invalidZipLength)
    }

    return .success
  }
}

@testable import Frames

extension CkoCardTokenResponse {
    
    init(token: String = "",
         scheme: String? = nil) {
        
        self.init(
            type: "",
            token: token,
            expiresOn: "",
            expiryMonth: 0,
            expiryYear: 0,
            name: "",
            scheme: scheme,
            last4: "",
            bin: "",
            cardType: nil,
            cardCategory: nil,
            issuer: nil,
            issuerCountry: nil,
            productId: nil,
            productType: nil,
            billingAddress: nil,
            phone: nil)
    }
    
}

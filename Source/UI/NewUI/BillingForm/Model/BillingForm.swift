import Checkout

public struct BillingForm {
    public let address: Address
    public let phone: Phone

    public init(address: Address, phone: Phone) {
        self.address = address
        self.phone = phone
    }
}

extension BillingForm: Equatable {}

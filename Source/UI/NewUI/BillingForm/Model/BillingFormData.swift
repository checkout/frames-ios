import Checkout

public struct BillingFormData {
    public let address: Address
    public let phone: Phone

    public init(address: Address, phone: Phone) {
        self.address = address
        self.phone = phone
    }
}

extension BillingFormData: Equatable {}

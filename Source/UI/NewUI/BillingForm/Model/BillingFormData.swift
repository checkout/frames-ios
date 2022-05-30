import Checkout

public struct BillingFormData {
    public let name: String
    public let address: Address
    public let phone: Phone

    public init(name: String, address: Address, phone: Phone) {
        self.name = name
        self.address = address
        self.phone = phone
    }
}

extension BillingFormData: Equatable {}

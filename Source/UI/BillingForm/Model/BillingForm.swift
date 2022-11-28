import Checkout

public struct BillingForm: Equatable {
    public let name: String?
    public let address: Address?
    public let phone: Phone?

    public init(name: String?, address: Address?, phone: Phone?) {
        self.name = name
        self.address = address
        self.phone = phone
    }
}

extension Phone {
    func displayFormatted() -> String {
        let nationalNumber = String(number ?? "")
        let dialingCode = String(country?.dialingCode ?? "")
        return "+\(dialingCode) \(nationalNumber)"
    }
}

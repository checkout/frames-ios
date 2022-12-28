import UIKit

public protocol BillingFormStyle {
    var mainBackground: UIColor { get }
    var header: BillingFormHeaderCellStyle { get set }
    var cells: [BillingFormCell] { get set }
}

extension BillingFormStyle {
    func summaryFrom(form: BillingForm?) -> String {
        guard let form = form else { return "" }
        var summaryValues = [String?]()
        cells.forEach {
            switch $0 {
            case .fullName: summaryValues.append(form.name)
            case .addressLine1: summaryValues.append(form.address?.addressLine1)
            case .addressLine2: summaryValues.append(form.address?.addressLine2)
            case .state: summaryValues.append(form.address?.state)
            case .country: summaryValues.append(form.address?.country?.name)
            case .city: summaryValues.append(form.address?.city)
            case .postcode: summaryValues.append(form.address?.zip)
            case .phoneNumber:
                guard let phoneString = form.phone?.displayFormatted(), !phoneString.isEmpty else { return }
                summaryValues.append(phoneString)
            }
        }
        let summary = summaryValues
            .compactMap { $0?.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .joined(separator: "\n\n")
        return summary
    }
}

import UIKit

public struct PaymentFormFactory {

    public static func getBillingFormButtonView(style: BillingSummaryViewStyle, delegate: SelectionButtonViewDelegate?) -> UIView {
        let view = BillingFormSummaryView()
        view.delegate = delegate
        view.update(style: style)
        return view
    }

    public static func getButton(style: CellButtonStyle, delegate: SelectionButtonViewDelegate?) ->  UIView {
        let view = SelectionButtonView()
        view.delegate = delegate
        view.update(style: style)
        return view
    }
}

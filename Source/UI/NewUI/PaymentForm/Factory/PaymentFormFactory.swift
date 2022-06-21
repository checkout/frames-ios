import UIKit

public struct PaymentFormFactory {

    public static func getBillingFormButtonView(style: SummaryViewStyle, delegate: SelectionButtonViewDelegate?) -> (view: UIView, delegate: SelectionButtonViewDelegate?)  {
        let view = BillingFormSummaryView()
        view.delegate = delegate
        view.update(style: style)
        return (view, view.delegate)
    }

    public static func getButton(style: CellButtonStyle, delegate: SelectionButtonViewDelegate?) -> (view: UIView, delegate: SelectionButtonViewDelegate?)  {
        let view = SelectionButtonView()
        view.delegate = delegate
        view.update(style: style)
        return view
    }
}

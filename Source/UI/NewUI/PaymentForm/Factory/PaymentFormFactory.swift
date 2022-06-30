import UIKit

public struct PaymentFormFactory {
    
    public static func getPaymentFormViewController(billingFormData: BillingForm?,
                                                    paymentFormStyle: PaymentFormStyle?,
                                                    billingFormStyle: BillingFormStyle?) -> UIViewController {
        
      let viewModel = DefaultPaymentViewModel(environment: .live ,
                                              billingFormData: billingFormData,
                                                paymentFormStyle: paymentFormStyle,
                                                billingFormStyle: billingFormStyle)
        let viewController =  PaymentViewController(viewModel: viewModel)
        
        if #available(iOS 13.0, *) {
            viewController.isModalInPresentation  = true
        }
        return viewController
    }

    static func getButton(style: CellButtonStyle, delegate: SelectionButtonViewDelegate?) ->  UIView {
        let view = SelectionButtonView()
        view.delegate = delegate
        view.update(style: style)
        return view
    }
}

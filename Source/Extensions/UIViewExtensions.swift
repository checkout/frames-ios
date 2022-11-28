import Foundation
import UIKit

extension UIView {
    func setupConstraintEqualTo(view: UIView, constant: CGFloat = 0) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: constant),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constant),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -constant)
        ])
    }
}

extension UIView {
    func disabledAutoresizingIntoConstraints() -> Self {
          translatesAutoresizingMaskIntoConstraints = false
          return self
    }

    func removeSubviews() {
      subviews.forEach { $0.removeFromSuperview() }
    }
}

extension UIView {

  static var keyboardDismissTapGesture: UITapGestureRecognizer {
    let gesture = UITapGestureRecognizer(target: UIView.self, action: #selector(hideKeyboard(gestureRecognizer:)))
    gesture.cancelsTouchesInView = false
    return gesture
  }

  @objc private static func hideKeyboard(gestureRecognizer: UITapGestureRecognizer) {
    let view = gestureRecognizer.view
    let location = gestureRecognizer.location(in: view)
    let subview = view?.hitTest(location, with: nil)
    guard !(subview is SecureDisplayView) else { return }
    UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
  }

}

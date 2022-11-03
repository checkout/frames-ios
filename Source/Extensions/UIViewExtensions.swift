import Foundation
import UIKit

extension UIView {

    func addScrollViewContraints(scrollView: UIScrollView, contentView: UIView) -> NSLayoutConstraint {
        // Content View Constraints
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0).isActive = true
        let contentViewHeightConstraint = contentView.heightAnchor.constraint(equalTo: heightAnchor,
                                                                              multiplier: 1.0)
        contentViewHeightConstraint.priority = .defaultLow
        contentViewHeightConstraint.isActive = true
        // Scroll View Constraints
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true

        let scrollViewBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 20)
        scrollViewBottomConstraint.isActive = true
        // return scrollView bottom anchor constraint, used to manage the keyboard
        return scrollViewBottomConstraint
    }

}

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

extension UIView {

    func addBorder(with list: [UIRectEdge], thickness: Double, color: UIColor) {
        list.forEach {
            addBorder(side: $0, thickness: thickness, color: color)
        }
    }

    private func addBorder(side: UIRectEdge, thickness: Double, color: UIColor) {
        let edgeView = UIView().disabledAutoresizingIntoConstraints()
        edgeView.backgroundColor = color
        addSubview(edgeView)

        switch side {
            case .left:
                NSLayoutConstraint.activate([
                    edgeView.topAnchor.constraint(equalTo: topAnchor),
                    edgeView.leftAnchor.constraint(equalTo: leftAnchor),
                    edgeView.bottomAnchor.constraint(equalTo: bottomAnchor),
                    edgeView.widthAnchor.constraint(equalToConstant: thickness)
                ])

            case .right:
                NSLayoutConstraint.activate([
                    edgeView.topAnchor.constraint(equalTo: topAnchor),
                    edgeView.rightAnchor.constraint(equalTo: rightAnchor),
                    edgeView.bottomAnchor.constraint(equalTo: bottomAnchor),
                    edgeView.widthAnchor.constraint(equalToConstant: thickness)
                ])
            case .top:
                NSLayoutConstraint.activate([
                    edgeView.topAnchor.constraint(equalTo: topAnchor),
                    edgeView.rightAnchor.constraint(equalTo: rightAnchor),
                    edgeView.leftAnchor.constraint(equalTo: leftAnchor),
                    edgeView.heightAnchor.constraint(equalToConstant: thickness)
                ])

            case .bottom:
                NSLayoutConstraint.activate([
                    edgeView.bottomAnchor.constraint(equalTo: bottomAnchor),
                    edgeView.rightAnchor.constraint(equalTo: rightAnchor),
                    edgeView.leftAnchor.constraint(equalTo: leftAnchor),
                    edgeView.heightAnchor.constraint(equalToConstant: thickness)
                ])
            case .all:
                addBorder(with: [.left, .right, .top, .bottom], thickness: thickness, color: color)

            default: break
        }

    }
}

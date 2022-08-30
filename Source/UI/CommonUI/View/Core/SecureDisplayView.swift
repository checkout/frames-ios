//
//  SecureDisplayView.swift
//  Frames
//
//  Created by Alex Ioja-Yang 
//  Copyright © 2022 Checkout. All rights reserved.
//

import UIKit

/**
Secure display view preventing leaking of content
 */
public final class SecureDisplayView: UIView {

    /**
     Will protect the provided view.
     */
    public static func secure(_ view: UIView, acceptsInput: Bool = false) -> SecureDisplayView {
        SecureDisplayView(secure: view, acceptsInput: acceptsInput)
    }

    // MARK: Protect content from leaking
    public override var subviews: [UIView] { [] }
    public override var inputView: UIView? { nil }
    public override var inputViewController: UIInputViewController? { nil }
    public override var textInputMode: UITextInputMode? { nil }
    public override var accessibilityLabel: String? {
        get { nil }
        set { }
    }
    public override var accessibilityValue: String? {
        get { nil }
        set { }
    }
    public override var accessibilityHint: String? {
        get { nil }
        set { }
    }
    public override var isAccessibilityElement: Bool {
        get { false }
        set { }
    }

    // MARK: Protect methods that may be used to trick view into leaking content
    public override func reloadInputViews() { }
    public override func insertSubview(_ view: UIView, at index: Int) { }
    public override func exchangeSubview(at index1: Int, withSubviewAt index2: Int) { }
    public override func addSubview(_ view: UIView) { }
    public override func insertSubview(_ view: UIView, belowSubview siblingSubview: UIView) { }
    public override func insertSubview(_ view: UIView, aboveSubview siblingSubview: UIView) { }
    public override func bringSubviewToFront(_ view: UIView) { }
    public override func sendSubviewToBack(_ view: UIView) { }
    public override func didAddSubview(_ subview: UIView) { }
    public override func willRemoveSubview(_ subview: UIView) { }

    public override func layoutSubviews() {
        super.layoutSubviews()

        super.subviews.first?.frame = bounds
    }

    public override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        super.subviews.first?.systemLayoutSizeFitting(targetSize) ?? .zero
    }

    public override func systemLayoutSizeFitting(_ targetSize: CGSize,
                                                 withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
                                                 verticalFittingPriority: UILayoutPriority) -> CGSize {
        super.subviews.first?.systemLayoutSizeFitting(targetSize,
                                                      withHorizontalFittingPriority: horizontalFittingPriority,
                                                      verticalFittingPriority: verticalFittingPriority) ?? .zero
    }

    // MARK: Protect views

    /// Create SecureDisplayView protecting the provided view.
    public convenience init(secure subview: UIView, acceptsInput: Bool = false) {
        self.init(frame: .zero)

        backgroundColor = .clear
        super.addSubview(subview)

        if acceptsInput {
            addGestureToView()
        }
    }

    private func addGestureToView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewWasTapped))
        addGestureRecognizer(tapGesture)
    }

    @objc private func viewWasTapped() {
        guard let secured = super.subviews.first,
              secured.isUserInteractionEnabled,
              secured.canBecomeFirstResponder else {
            return
        }
        secured.becomeFirstResponder()
    }
}

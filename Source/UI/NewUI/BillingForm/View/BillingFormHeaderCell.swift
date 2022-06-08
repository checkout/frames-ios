import UIKit

protocol BillingFormHeaderCellDelegate: AnyObject {
    func doneButtonIsPressed()
    func cancelButtonIsPressed()
}

final class BillingFormHeaderCell: UIView {
    weak var delegate: BillingFormHeaderCellDelegate?
    private var style: BillingFormHeaderCellStyle?

    private lazy var cancelButton: UIButton? = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return view
    }()

    private lazy var doneButton: UIButton? = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        return view
    }()

    private lazy var headerLabel: UILabel? = {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    init(style: BillingFormHeaderCellStyle, delegate: BillingFormHeaderCellDelegate?) {
        self.style = style
        self.delegate = delegate
        super.init(frame: .zero)
        setupViewsInOrder()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(style: BillingFormHeaderCellStyle?) {
        self.style = style

        /// Cancel Button style?
        cancelButton?.setTitle(style?.cancelButton.text, for: .normal)
        cancelButton?.titleLabel?.font = style?.cancelButton.font
        cancelButton?.setTitleColor(style?.cancelButton.activeTitleColor, for: .normal)
        cancelButton?.setTitleColor(style?.cancelButton.disabledTitleColor, for: .disabled)
        cancelButton?.tintColor = (cancelButton?.isEnabled ?? false) ? style?.cancelButton.activeTintColor : style?.cancelButton.disabledTintColor
        cancelButton?.backgroundColor = style?.cancelButton.backgroundColor

        /// Done Button style?
        doneButton?.isEnabled = style?.doneButton.isEnabled ?? true
        doneButton?.setTitle(style?.doneButton.text, for: .normal)
        doneButton?.titleLabel?.font = style?.doneButton.font
        doneButton?.setTitleColor(style?.doneButton.activeTitleColor, for: .normal)
        doneButton?.setTitleColor(style?.doneButton.disabledTitleColor, for: .disabled)
        doneButton?.tintColor = (doneButton?.isEnabled ?? false ) ? style?.doneButton.activeTintColor : style?.doneButton.disabledTintColor
        doneButton?.backgroundColor = style?.doneButton.backgroundColor

        headerLabel?.text = style?.headerLabel.text
        headerLabel?.font = style?.headerLabel.font
        headerLabel?.textColor = style?.headerLabel.textColor
    }

    @objc private func doneAction() {
        delegate?.doneButtonIsPressed()
    }

    @objc private func cancelAction() {
        delegate?.cancelButtonIsPressed()
    }

    private func shouldEnableDoneButton(flag: Bool) {
        doneButton?.isEnabled = flag
    }
}

extension BillingFormHeaderCell {

    private func setupViewsInOrder() {
        backgroundColor = style?.backgroundColor
        setupCancelButton()
        setupDoneButton()
        setupHeaderLabel()
    }

    private func setupCancelButton() {
        guard let cancelButton = cancelButton else { return }
        addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(
                equalTo: safeTopAnchor),
            cancelButton.leadingAnchor.constraint(
                equalTo: safeLeadingAnchor),
            cancelButton.heightAnchor.constraint(
                equalToConstant: style?.cancelButton.height ?? Constants.Style.BillingForm.CancelButton.height.rawValue),
            cancelButton.widthAnchor.constraint(
                equalToConstant: style?.cancelButton.width ?? Constants.Style.BillingForm.CancelButton.width.rawValue)
        ])
    }

    private func setupDoneButton() {
        guard let doneButton = doneButton else { return }
        addSubview(doneButton)
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(
                equalTo: safeTopAnchor),
            doneButton.trailingAnchor.constraint(
                equalTo: safeTrailingAnchor),
            doneButton.heightAnchor.constraint(
                equalToConstant: style?.doneButton.height ?? Constants.Style.BillingForm.DoneButton.height.rawValue),
            doneButton.widthAnchor.constraint(
                equalToConstant: style?.doneButton.width ?? Constants.Style.BillingForm.DoneButton.width.rawValue)
        ])
    }

    private func setupHeaderLabel() {
        guard let headerLabel = headerLabel else { return }
        addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(
                equalTo: safeTopAnchor,
                constant: 58),
            headerLabel.leadingAnchor.constraint(
                equalTo: safeLeadingAnchor),
            headerLabel.trailingAnchor.constraint(
                equalTo: safeTrailingAnchor),
            headerLabel.bottomAnchor.constraint(
                equalTo: safeBottomAnchor,
                constant: -40)
        ])
    }
}

extension BillingFormHeaderCell: BillingFormViewModelEditingDelegate {
    func didFinishEditingBillingForm(successfully: Bool) {
        shouldEnableDoneButton(flag: successfully)
    }
}

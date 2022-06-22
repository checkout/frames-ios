import UIKit

protocol BillingFormHeaderCellDelegate: AnyObject {
    func doneButtonIsPressed()
    func cancelButtonIsPressed()
}

final class BillingFormHeaderCell: UIView {
    weak var delegate: BillingFormHeaderCellDelegate?
    private var style: BillingFormHeaderCellStyle?

    private lazy var cancelButton: ButtonView? = {
        let view = ButtonView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()

    private lazy var doneButton: ButtonView? = {
        let view = ButtonView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()

    private lazy var headerLabel: LabelView? = {
        LabelView().disabledAutoresizingIntoConstraints()
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
        guard let style = style else { return }
        self.style = style

        doneButton?.update(with: style.doneButton)
        cancelButton?.update(with: style.cancelButton)
        headerLabel?.update(with: style.headerLabel)
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
                equalTo: leadingAnchor, constant: 20),
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
                equalTo: trailingAnchor, constant: 0),
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
                equalTo: leadingAnchor, constant: 20),
            headerLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor, constant: -20),
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

extension BillingFormHeaderCell: ButtonViewDelegate {
    func buttonIsPressed(sender: UIView) {
        switch sender {
            case doneButton:
                delegate?.doneButtonIsPressed()
                break
            case cancelButton:
                delegate?.cancelButtonIsPressed()
                break
            default: break
        }
    }
}

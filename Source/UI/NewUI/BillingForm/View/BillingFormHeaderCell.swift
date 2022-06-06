import UIKit

protocol BillingFormHeaderCellDelegate: AnyObject {
    func doneButtonIsPressed()
    func cancelButtonIsPressed()
}

final class BillingFormHeaderCell: UIView {
    private var style: BillingFormHeaderCellStyle
    private weak var delegate: BillingFormHeaderCellDelegate?

    private lazy var cancelButton: UIButton = {
        let view = UIButton()
        view.setTitle(style.cancelButton.text, for: .normal)
        view.titleLabel?.font = style.cancelButton.font
        view.setTitleColor(style.cancelButton.activeTitleColor, for: .normal)
        view.setTitleColor(style.cancelButton.disabledTitleColor, for: .disabled)
        view.tintColor = view.isEnabled ? style.cancelButton.activeTintColor : style.cancelButton.disabledTintColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = style.cancelButton.backgroundColor
        view.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return view
    }()

    private lazy var done: UIButton = {
        let view = UIButton()
        view.isEnabled = style.doneButton.isEnabled
        view.setTitle(style.doneButton.text, for: .normal)
        view.titleLabel?.font = style.doneButton.font
        view.setTitleColor(style.doneButton.activeTitleColor, for: .normal)
        view.setTitleColor(style.doneButton.disabledTitleColor, for: .disabled)
        view.tintColor = view.isEnabled ? style.doneButton.activeTintColor : style.doneButton.disabledTintColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = style.doneButton.backgroundColor
        view.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        return view
    }()

    private lazy var headerLabel: UILabel = {
        let view = UILabel()
        view.text = style.headerLabel.text
        view.font = style.headerLabel.font
        view.textColor = style.headerLabel.textColor
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    init(style: BillingFormHeaderCellStyle, delegate: BillingFormHeaderCellDelegate?) {
        self.style = style
        super.init(frame: .zero)
        self.delegate = delegate
        setupViewsInOrder()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func doneAction() {
        delegate?.doneButtonIsPressed()
    }

    @objc private func cancelAction() {
        delegate?.cancelButtonIsPressed()
    }

    private func shouldEnableDoneButton(flag: Bool) {
        done.isEnabled = flag
    }
}

extension BillingFormHeaderCell {

    private func setupViewsInOrder() {
        backgroundColor = style.backgroundColor
        setupCancelButton()
        setupDoneButton()
        setupHeaderLabel()
    }

    private func setupCancelButton() {
       addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(
                equalTo: safeTopAnchor),
            cancelButton.leadingAnchor.constraint(
                equalTo: safeLeadingAnchor),
            cancelButton.heightAnchor.constraint(
                equalToConstant: style.cancelButton.height),
            cancelButton.widthAnchor.constraint(
                equalToConstant: style.cancelButton.width)
        ])
    }

    private func setupDoneButton() {
        addSubview(done)
        NSLayoutConstraint.activate([
            done.topAnchor.constraint(
                equalTo: safeTopAnchor),
            done.trailingAnchor.constraint(
                equalTo: safeTrailingAnchor),
            done.heightAnchor.constraint(
                equalToConstant: style.doneButton.height),
            done.widthAnchor.constraint(
                equalToConstant: style.doneButton.width)
        ])
    }

    private func setupHeaderLabel() {
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

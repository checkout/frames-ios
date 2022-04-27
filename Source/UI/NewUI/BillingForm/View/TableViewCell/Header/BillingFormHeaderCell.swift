import UIKit

protocol BillingFormHeaderCellDelegate: AnyObject {
    func doneButtonIsPressed()
    func cancelButtonIsPressed()
}

final class BillingFormHeaderCell: UITableViewCell {
    private var style: BillingFormHeaderCellStyle
    private weak var delegate: BillingFormHeaderCellDelegate?
    
    private lazy var cancel: UIButton = {
        let view = UIButton()
        view.setTitle(style.cancelButton.text, for: .normal)
        view.titleLabel?.font = style.cancelButton.font
        view.setTitleColor(style.cancelButton.activeTitleColor, for: .normal)
        view.setTitleColor(style.cancelButton.inActiveTitleColor, for: .disabled)
        view.tintColor = view.isEnabled ? style.cancelButton.activeTintColor : style.cancelButton.inActiveTintColor
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
        view.setTitleColor(style.doneButton.inActiveTitleColor, for: .disabled)
        view.tintColor = view.isEnabled ? style.doneButton.activeTintColor : style.doneButton.inActiveTintColor
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
    
    init(style: BillingFormHeaderCellStyle , delegate: BillingFormHeaderCellDelegate?) {
        self.style = style
        super.init(style: .default, reuseIdentifier: nil)
        self.delegate = delegate
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func doneAction(){
        delegate?.doneButtonIsPressed()
    }
    
    @objc private func cancelAction(){
        delegate?.cancelButtonIsPressed()
    }
    
    private func shouldEnableDoneButton(flag: Bool) {
        done.isEnabled = flag
    }
}

// setup views
extension BillingFormHeaderCell {
    
    private func setupViews() {
        setupCancelButton()
        setupDoneButton()
        setupHeaderLabel()
    }
    
    private func setupCancelButton() {
        contentView.addSubview(cancel)
        NSLayoutConstraint.activate([
            cancel.topAnchor.constraint(
                equalTo: safeTopAnchor,
                constant: 0),
            cancel.leadingAnchor.constraint(
                equalTo: contentView.safeLeadingAnchor,
                constant: 20),
            cancel.heightAnchor.constraint(
                equalToConstant: style.cancelButton.height),
            cancel.widthAnchor.constraint(
                equalToConstant: style.cancelButton.width)
        ])
    }
    
    private func setupDoneButton() {
        contentView.addSubview(done)
        NSLayoutConstraint.activate([
            done.topAnchor.constraint(
                equalTo: safeTopAnchor,
                constant: 0),
            done.trailingAnchor.constraint(
                equalTo: contentView.safeTrailingAnchor,
                constant: -20),
            done.heightAnchor.constraint(
                equalToConstant: style.doneButton.height),
            done.widthAnchor.constraint(
                equalToConstant: style.doneButton.width)
        ])
    }
    
    private func setupHeaderLabel() {
        contentView.addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(
                equalTo: contentView.safeTopAnchor,
                constant: 58),
            headerLabel.leadingAnchor.constraint(
                equalTo: contentView.safeLeadingAnchor,
                constant: 20),
            headerLabel.trailingAnchor.constraint(
                equalTo: contentView.safeTrailingAnchor,
                constant: -20),
            headerLabel.bottomAnchor.constraint(
                equalTo: contentView.safeBottomAnchor,
                constant: -40)
        ])
    }   
}

extension BillingFormHeaderCell: BillingFormViewModelEditingDelegate {
    func didFinishEditingBillingForm(successfully: Bool) {
        shouldEnableDoneButton(flag: successfully)
    }
}

import UIKit

class InputView: UIView {

    // MARK: - Properties

    weak var delegate: TextFieldViewDelegate?
    private(set) var style: CellTextFieldStyle?
    private(set) lazy var textFieldContainerBottomAnchor = textFieldContainer?.bottomAnchor.constraint(equalTo: bottomAnchor)

    // MARK: - UI elements

    private(set) lazy var headerLabel: LabelView? = {
        LabelView().disabledAutoresizingIntoConstraints()
    }()

    private(set) lazy var mandatoryLabel: LabelView? = {
        LabelView().disabledAutoresizingIntoConstraints()
    }()

    private(set) lazy var hintLabel: LabelView? = {
        LabelView().disabledAutoresizingIntoConstraints()
    }()

    private(set) lazy var textFieldContainer: UIView? = {
        let view = UIView().disabledAutoresizingIntoConstraints()
        view.backgroundColor = .clear
        return view
    }()

    private(set) lazy var textFieldView: TextFieldView? = {
        let view = TextFieldView().disabledAutoresizingIntoConstraints()
        view.delegate = self
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewsInOrder()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func textFieldEditingChanged(textField: UITextField) {
        delegate?.textFieldShouldChangeCharactersIn(textField: textField, replacementString: "")
    }

    private(set) lazy var errorView: SimpleErrorView? = {
        SimpleErrorView().disabledAutoresizingIntoConstraints()
    }()

    // MARK: - Update subviews style

    func update(style: CellTextFieldStyle?, textFieldValue: String? = nil) {
        guard let style = style else { return }
        self.style = style
        backgroundColor = style.backgroundColor
        mandatoryLabel?.isHidden = style.isMandatory

        headerLabel?.update(with: style.title)
        mandatoryLabel?.update(with: style.mandatory)
        hintLabel?.update(with: style.hint)
        updateTextFieldContainer(style: style)
        textFieldView?.update(with: style.textfield)
        updateErrorView(style: style)
    }

    private func updateTextFieldContainer(style: CellTextFieldStyle) {
        let borderColor = !(style.error?.isHidden ?? true) ?
        style.textfield.errorBorderColor.cgColor :
        style.textfield.normalBorderColor.cgColor

        textFieldContainer?.layer.borderColor = borderColor
        textFieldContainer?.layer.cornerRadius = style.textfield.cornerRadius
        textFieldContainer?.layer.borderWidth = style.textfield.borderWidth
        textFieldContainer?.backgroundColor = style.textfield.backgroundColor
    }

    private func updateErrorView(style: CellTextFieldStyle) {
        errorView?.update(style: style.error)
        let shouldHideErrorView = style.error?.isHidden ?? false
        let expectedErrorViewHeight = style.error?.height ?? 0
        errorView?.isHidden = shouldHideErrorView
        textFieldContainerBottomAnchor?.constant = -(shouldHideErrorView ? 0 : expectedErrorViewHeight)
    }
}

// MARK: - Views Layout Constraint

extension InputView {

    private func setupViewsInOrder(){
        backgroundColor = style?.backgroundColor
        setupHeaderLabel()
        setupMandatoryLabel()
        setupHintLabel()
        setupTextFieldContainer()
        setupTextField()
        setupErrorView()
    }

    private func setupHeaderLabel() {
        guard let headerLabel = headerLabel else { return }
        addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }

    private func setupMandatoryLabel() {
        guard let mandatoryLabel = mandatoryLabel else { return }
        guard let headerLabel = headerLabel else { return }
        addSubview(mandatoryLabel)
        NSLayoutConstraint.activate([
            mandatoryLabel.topAnchor.constraint(equalTo: topAnchor),
            mandatoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            mandatoryLabel.leadingAnchor.constraint(greaterThanOrEqualTo: headerLabel.trailingAnchor)
        ])
    }

    private func setupHintLabel() {
        guard let hintLabel = hintLabel else { return }
        guard let headerLabel = headerLabel else { return }
        addSubview(hintLabel)
        NSLayoutConstraint.activate([
            hintLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor,
                                           constant: Constants.Padding.s.rawValue),
            hintLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            hintLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func setupTextFieldContainer() {
        guard let textFieldContainer = textFieldContainer else { return }
        guard let hintLabel = hintLabel else { return }
        textFieldContainer.setContentHuggingPriority(.required, for: .vertical)
        addSubview(textFieldContainer)
        NSLayoutConstraint.activate([
            textFieldContainer.topAnchor.constraint(equalTo: hintLabel.bottomAnchor,
                                                    constant: Constants.Padding.m.rawValue),
            textFieldContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            textFieldContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            textFieldContainerBottomAnchor ?? textFieldContainer.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupTextField() {
        guard let textFieldContainer = textFieldContainer else { return }
        guard let textFieldView = textFieldView else { return }
        let heightStyle = style?.textfield.height ?? Constants.Style.BillingForm.InputTextField.height.rawValue
        textFieldContainer.addSubview(textFieldView)
        NSLayoutConstraint.activate([
            textFieldView.topAnchor.constraint(equalTo: textFieldContainer.topAnchor),
            textFieldView.leadingAnchor.constraint(equalTo: textFieldContainer.leadingAnchor,
                                                   constant: Constants.Padding.l.rawValue),
            textFieldView.trailingAnchor.constraint(equalTo: textFieldContainer.trailingAnchor,
                                                    constant: -Constants.Padding.l.rawValue),
            textFieldView.bottomAnchor.constraint(equalTo: textFieldContainer.bottomAnchor),
            textFieldView.heightAnchor.constraint(equalToConstant: heightStyle)
        ])
    }

    private func setupErrorView() {
        guard let errorView = errorView else { return }
        guard let textFieldContainer = textFieldContainer else { return }

        addSubview(errorView)

        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: textFieldContainer.bottomAnchor,
                                           constant: Constants.Padding.m.rawValue),
            errorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: - Text Field Delegate

extension InputView: TextFieldViewDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) {
        delegate?.textFieldShouldBeginEditing(textField: textField)
            textFieldContainer?.layer.borderColor = style?.textfield.focusBorderColor.cgColor
    }

    func textFieldShouldReturn() -> Bool {
         delegate?.textFieldShouldReturn() ?? false
    }

    func textFieldShouldEndEditing(textField: UITextField, replacementString: String) -> Bool {
        delegate?.textFieldShouldEndEditing(textField: textField, replacementString: replacementString) ?? true
    }

    func textFieldShouldChangeCharactersIn(textField: UITextField, replacementString string: String) {
        delegate?.textFieldShouldChangeCharactersIn(textField: textField, replacementString: string)
    }
}

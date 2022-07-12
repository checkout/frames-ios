import UIKit

protocol SelectionButtonViewDelegate: AnyObject {
    func selectionButtonIsPressed()
}

class SelectionButtonView: UIView {
    weak var delegate: SelectionButtonViewDelegate?
    private var style: CellButtonStyle?

    private(set) lazy var titleLabel: LabelView? = {
        LabelView().disabledAutoresizingIntoConstraints()
    }()

    private(set) lazy var hintLabel: LabelView? = {
        LabelView().disabledAutoresizingIntoConstraints()
    }()

    private(set) lazy var image: ImageContainerView? = {
        ImageContainerView().disabledAutoresizingIntoConstraints()
    }()

    private(set) lazy var buttonView: ButtonView? = {
        let view = ButtonView().disabledAutoresizingIntoConstraints()
        view.delegate = self
        return view
    }()

    private(set) lazy var errorView: SimpleErrorView? = {
        SimpleErrorView().disabledAutoresizingIntoConstraints()
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewsInOrder()
    }

    func update(style: CellButtonStyle) {
        self.style = style

        titleLabel?.update(with: style.title)
        hintLabel?.update(with: style.hint)
        buttonView?.update(with: style.button)
        errorView?.update(style: style.error)
        image?.update(with: style.button.image, tintColor: style.button.imageTintColor)
        errorView?.isHidden = style.error?.isHidden ?? true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SelectionButtonView {

    private func setupViewsInOrder() {
        setupTitleLabel()
        setupHintLabel()
        setupErrorView()
        setupButton()
        setupImageView()
    }

    private func setupTitleLabel() {
        guard let titleLabel = titleLabel else { return }
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func setupHintLabel() {
        guard let hintLabel = hintLabel else { return }
        guard let titleLabel = titleLabel else { return }
        addSubview(hintLabel)
        NSLayoutConstraint.activate([
            hintLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                           constant: Constants.Padding.xxs.rawValue),
            hintLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            hintLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func setupButton() {
        guard let button = buttonView else { return }
        guard let hintLabel = hintLabel else { return }
        addSubview(button)
        let heightStyle = style?.button.height ?? Constants.Style.BillingForm.InputCountryButton.height.rawValue

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: hintLabel.bottomAnchor,
                                        constant: Constants.Padding.s.rawValue),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.heightAnchor.constraint(equalToConstant: heightStyle)
        ])
    }
    private func setupImageView() {
        guard let image = image else { return }
        guard let button = buttonView else { return }
        addSubview(image)
        NSLayoutConstraint.activate([
            image.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor,
                                            constant: -Constants.Padding.l.rawValue),
            image.widthAnchor.constraint(equalToConstant: 15),
            image.heightAnchor.constraint(equalToConstant: 15)
        ])
    }

    private func setupErrorView() {
        guard let errorView = errorView else { return }
        addSubview(errorView)
        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: bottomAnchor),
            errorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

}

extension SelectionButtonView: ButtonViewDelegate {
    func selectionButtonIsPressed(sender: UIView) {
        delegate?.selectionButtonIsPressed()
    }
}

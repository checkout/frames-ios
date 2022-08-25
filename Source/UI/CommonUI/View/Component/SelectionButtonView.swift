import UIKit

protocol SelectionButtonViewDelegate: AnyObject {
    func selectionButtonIsPressed()
}

class SelectionButtonView: UIView {
    weak var delegate: SelectionButtonViewDelegate?
    private(set) var style: CellButtonStyle?

    private(set) lazy var titleLabel: LabelView = {
        LabelView().disabledAutoresizingIntoConstraints()
    }()

    private(set) lazy var hintLabel: LabelView = {
        LabelView().disabledAutoresizingIntoConstraints()
    }()

    private(set) lazy var imageContainerView: ImageContainerView = {
        ImageContainerView().disabledAutoresizingIntoConstraints()
    }()

    private(set) lazy var buttonView: ButtonView = {
        let view = ButtonView().disabledAutoresizingIntoConstraints()
        view.delegate = self
        return view
    }()

    private(set) lazy var errorView: SimpleErrorView = {
        SimpleErrorView().disabledAutoresizingIntoConstraints()
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewsInOrder()
    }

    func update(style: CellButtonStyle) {
        self.style = style

        titleLabel.update(with: style.title)
        hintLabel.update(with: style.hint)
        buttonView.update(with: style.button)
        errorView.update(style: style.error)
        imageContainerView.update(with: style.button.image, tintColor: style.button.imageTintColor)
        errorView.isHidden = style.error?.isHidden ?? true
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
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func setupHintLabel() {
        addSubview(hintLabel)
        NSLayoutConstraint.activate([
            hintLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                           constant: Constants.Padding.xxs.rawValue),
            hintLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            hintLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func setupButton() {
        addSubview(buttonView)
        let heightStyle = style?.button.height ?? Constants.Style.BillingForm.InputCountryButton.height.rawValue

        NSLayoutConstraint.activate([
          buttonView.topAnchor.constraint(equalTo: hintLabel.bottomAnchor,
                                          constant: Constants.Padding.s.rawValue),
          buttonView.bottomAnchor.constraint(equalTo: bottomAnchor),
          buttonView.leadingAnchor.constraint(equalTo: leadingAnchor),
          buttonView.trailingAnchor.constraint(equalTo: trailingAnchor),
          buttonView.heightAnchor.constraint(equalToConstant: heightStyle)
        ])
    }
    private func setupImageView() {
        addSubview(imageContainerView)
        sendSubviewToBack(imageContainerView)
        NSLayoutConstraint.activate([
          imageContainerView.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor),
          imageContainerView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                            constant: -Constants.Padding.l.rawValue),
          imageContainerView.widthAnchor.constraint(equalToConstant: 15),
          imageContainerView.heightAnchor.constraint(equalToConstant: 15)
        ])
    }

    private func setupErrorView() {
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

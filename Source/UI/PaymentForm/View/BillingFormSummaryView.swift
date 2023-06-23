import UIKit

protocol BillingFormSummaryViewDelegate: AnyObject {
    func summaryButtonIsPressed()
}

class BillingFormSummaryView: UIView {
    weak var delegate: BillingFormSummaryViewDelegate?
    private(set) var style: BillingSummaryViewStyle?

    private(set) lazy var titleLabel: LabelView = {
        LabelView().disabledAutoresizingIntoConstraints()
    }()

    private(set) lazy var hintLabel: LabelView = {
        let view = LabelView().disabledAutoresizingIntoConstraints()
        view.backgroundColor = .clear
        return view
    }()

    private(set) lazy var summaryLabel: LabelView = {
        LabelView().disabledAutoresizingIntoConstraints()
    }()

    private(set) lazy var summarySeparatorLineView: UIView = {
        UIView().disabledAutoresizingIntoConstraints()
    }()

    private(set) lazy var summaryContainerView: BorderView = {
        BorderView().disabledAutoresizingIntoConstraints()
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

    func update(style: BillingSummaryViewStyle) {
        self.style = style

        summaryContainerView.update(with: style.borderStyle)
        summaryContainerView.updateBorderColor(to: style.borderStyle.normalColor)
        summaryContainerView.backgroundColor = style.backgroundColor
        summarySeparatorLineView.backgroundColor = style.separatorLineColor

        titleLabel.update(with: style.title)
        hintLabel.update(with: style.hint)
        buttonView.update(with: style.button)
        imageContainerView.update(with: style.button.image, tintColor: style.button.imageTintColor)
        errorView.update(style: style.error)
        summaryLabel.update(with: style.summary)
        errorView.isHidden = style.error?.isHidden ?? true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension BillingFormSummaryView {

     func setupViewsInOrder() {
        setupTitleLabel()
        setupHintLabel()
        setupSummaryLabel()
        setupSummarySeparatorLineView()
        setupButton()
        setupSummaryContainerView()
        setupImageView()
        setupErrorView()
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
                                           constant: 6),
            hintLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            hintLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func setupSummaryLabel() {
        addSubview(summaryLabel)

        NSLayoutConstraint.activate([
            summaryLabel.topAnchor.constraint(equalTo: hintLabel.bottomAnchor,
                                              constant: Constants.Padding.xxl.rawValue),
            summaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                  constant: Constants.Padding.l.rawValue),
            summaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                   constant: -Constants.Padding.l.rawValue)
        ])
    }

    private func setupSummarySeparatorLineView() {
        addSubview(summarySeparatorLineView)

        NSLayoutConstraint.activate([
            summarySeparatorLineView.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor,
                                                          constant: Constants.Padding.m.rawValue),
            summarySeparatorLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            summarySeparatorLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            summarySeparatorLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    private func setupButton() {
        addSubview(buttonView)
        NSLayoutConstraint.activate([
          buttonView.topAnchor.constraint(equalTo: summarySeparatorLineView.bottomAnchor),
          buttonView.bottomAnchor.constraint(equalTo: bottomAnchor),
          buttonView.leadingAnchor.constraint(equalTo: leadingAnchor),
          buttonView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func setupSummaryContainerView() {
        addSubview(summaryContainerView)
        NSLayoutConstraint.activate([
            summaryContainerView.topAnchor.constraint(equalTo: hintLabel.bottomAnchor,
                                                      constant: 12),
            summaryContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            summaryContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            summaryContainerView.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor)
        ])
        sendSubviewToBack(summaryContainerView)
        bringSubviewToFront(buttonView)
    }

    private func setupImageView() {
        addSubview(imageContainerView)
        sendSubviewToBack(imageContainerView)
        NSLayoutConstraint.activate([
          imageContainerView.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor),
          imageContainerView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                            constant: -Constants.Padding.l.rawValue),
          imageContainerView.widthAnchor.constraint(equalToConstant: 11),
          imageContainerView.heightAnchor.constraint(equalToConstant: 13)
        ])
    }

    private func setupErrorView() {
        addSubview(errorView)
        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: summaryContainerView.bottomAnchor),
            errorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

}

extension BillingFormSummaryView: ButtonViewDelegate {
    func selectionButtonIsPressed(sender: UIView) {
        delegate?.summaryButtonIsPressed()
    }
}

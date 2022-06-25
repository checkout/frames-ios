import UIKit

protocol BillingFormSummaryViewDelegate: AnyObject {
    func buttonIsPressed()
}

class BillingFormSummaryView: UIView {
    weak var delegate: SelectionButtonViewDelegate?
    private var style: BillingSummaryViewStyle?
    
    private(set) lazy var titleLabel: LabelView? = {
        LabelView().disabledAutoresizingIntoConstraints()
    }()

    private(set) lazy var hintLabel: LabelView? = {
        LabelView().disabledAutoresizingIntoConstraints()
    }()

    private(set) lazy var summaryLabel: LabelView? = {
        LabelView().disabledAutoresizingIntoConstraints()
    }()

    private(set) lazy var summarySeparatorLineView: UIView? = {
        UIView().disabledAutoresizingIntoConstraints()
    }()

    private(set) lazy var summaryContainerView: UIView? = {
        UIView().disabledAutoresizingIntoConstraints()
    }()

    private(set) lazy var imageContainerView: ImageContainerView? = {
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

    func update(style: BillingSummaryViewStyle) {
        self.style = style
        summaryContainerView?.clipsToBounds = true
        summaryContainerView?.layer.borderWidth = style.borderWidth
        summaryContainerView?.layer.cornerRadius = style.cornerRadius
        summaryContainerView?.layer.borderColor = style.borderColor.cgColor
        summaryContainerView?.backgroundColor = .clear

        summarySeparatorLineView?.backgroundColor = style.separatorLineColor

        titleLabel?.update(with: style.title)
        hintLabel?.update(with: style.hint)
        summaryLabel?.update(with: style.hint)
        buttonView?.update(with: style.button)
        imageContainerView?.update(with: style.button.image, tintColor: style.button.imageTintColor)
        errorView?.update(style: style.error)
        summaryLabel?.update(with: style.summary)
        errorView?.isHidden = style.error?.isHidden ?? true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension BillingFormSummaryView {

     func setupViewsInOrder(){
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
            hintLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            hintLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            hintLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func setupSummaryLabel() {
        guard let summaryLabel = summaryLabel else { return }
        guard let hintLabel = hintLabel else { return }
        addSubview(summaryLabel)

        NSLayoutConstraint.activate([
            summaryLabel.topAnchor.constraint(equalTo: hintLabel.bottomAnchor, constant: 40),
            summaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            summaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func setupSummarySeparatorLineView() {
        guard let summarySeparatorLineView = summarySeparatorLineView else { return }
        guard let summaryLabel = summaryLabel else { return }
        addSubview(summarySeparatorLineView)

        NSLayoutConstraint.activate([
            summarySeparatorLineView.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 16),
            summarySeparatorLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            summarySeparatorLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            summarySeparatorLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    private func setupButton() {
        guard let button = buttonView else { return }
        guard let summarySeparatorLineView = summarySeparatorLineView else { return }
        addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: summarySeparatorLineView.bottomAnchor, constant: 10),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    private func setupSummaryContainerView(){
        guard let summaryContainerView = summaryContainerView else { return }
        guard let hintLabel = hintLabel else { return }
        guard let button = buttonView else { return }

        addSubview(summaryContainerView)
        NSLayoutConstraint.activate([
            summaryContainerView.topAnchor.constraint(equalTo: hintLabel.bottomAnchor, constant: 20),
            summaryContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            summaryContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            summaryContainerView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 10)
        ])
        bringSubviewToFront(button)
    }

    private func setupImageView() {
        guard let image = imageContainerView else { return }
        guard let button = buttonView else { return }
        addSubview(image)
        NSLayoutConstraint.activate([
            image.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            image.widthAnchor.constraint(equalToConstant: 11),
            image.heightAnchor.constraint(equalToConstant: 13)
        ])
    }

    private func setupErrorView() {
        guard let errorView = errorView else { return }
        guard let summaryContainerView = summaryContainerView else { return }
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
        delegate?.selectionButtonIsPressed()
    }
}

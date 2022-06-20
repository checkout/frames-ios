import UIKit

public protocol BillingFormSummaryViewDelegate: AnyObject {
    func buttonIsPressed()
}

extension UIView {
    func disabledAutoresizingIntoConstraints<V: UIView>() -> V? {
        translatesAutoresizingMaskIntoConstraints = false
        return self as? V
    }
}

class BillingFormSummaryView: UIView {
    weak var delegate: SelectionButtonViewDelegate?
    private var style: SummaryCellButtonStyle?
    
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

    private(set) lazy var image: ImageContainerView? = {
        ImageContainerView().disabledAutoresizingIntoConstraints()
    }()

    private(set) lazy var button: ButtonView? = {
        let view = ButtonView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private(set) lazy var errorView: SimpleErrorView? = {
        SimpleErrorView().disabledAutoresizingIntoConstraints()
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewsInOrder()
    }

    func update(style: SummaryCellButtonStyle) {
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
        button?.update(with: style.button)
        image?.update(with: style.button.image, tintColor: style.button.imageTintColor)
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
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }

    private func setupHintLabel() {
        guard let hintLabel = hintLabel else { return }
        guard let titleLabel = titleLabel else { return }
        addSubview(hintLabel)
        NSLayoutConstraint.activate([
            hintLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            hintLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            hintLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }

    private func setupSummaryLabel() {
        guard let summaryLabel = summaryLabel else { return }
        guard let hintLabel = hintLabel else { return }
        addSubview(summaryLabel)

        NSLayoutConstraint.activate([
            summaryLabel.topAnchor.constraint(equalTo: hintLabel.bottomAnchor, constant: 40),
            summaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            summaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }

    private func setupSummarySeparatorLineView() {
        guard let summarySeparatorLineView = summarySeparatorLineView else { return }
        guard let summaryLabel = summaryLabel else { return }
        addSubview(summarySeparatorLineView)

        NSLayoutConstraint.activate([
            summarySeparatorLineView.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 16),
            summarySeparatorLineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            summarySeparatorLineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            summarySeparatorLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    private func setupButton() {
        guard let button = button else { return }
        guard let summarySeparatorLineView = summarySeparatorLineView else { return }
        addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: summarySeparatorLineView.bottomAnchor, constant: 10),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }

    private func setupSummaryContainerView(){
        guard let summaryContainerView = summaryContainerView else { return }
        guard let hintLabel = hintLabel else { return }
        guard let button = button else { return }

        addSubview(summaryContainerView)
        NSLayoutConstraint.activate([
            summaryContainerView.topAnchor.constraint(equalTo: hintLabel.bottomAnchor, constant: 20),
            summaryContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            summaryContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            summaryContainerView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 10)
        ])
        bringSubviewToFront(button)
    }

    private func setupImageView() {
        guard let image = image else { return }
        guard let button = button else { return }
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
    func buttonIsPressed(sender: UIView) {
        delegate?.buttonIsPressed()
    }
}

extension UILabel {

    func addLineSpacing(spacingValue: CGFloat = 2) {
        guard let textString = text else { return }

        let attributedString = NSMutableAttributedString(string: textString)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacingValue
        if let font = font {
            attributedString.addAttribute(
                .font,
                value: font,
                range: NSRange(location: 0, length: attributedString.length)
            )
        }
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length)
        )
        attributedText = attributedString
    }
}

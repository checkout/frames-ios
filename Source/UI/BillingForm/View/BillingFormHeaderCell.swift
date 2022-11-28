import UIKit

final class BillingFormHeaderView: UIView {
    private var style: BillingFormHeaderCellStyle?

    private lazy var headerLabel: LabelView = {
        LabelView().disabledAutoresizingIntoConstraints()
    }()

    init(style: BillingFormHeaderCellStyle) {
        self.style = style
        super.init(frame: .zero)
        setupViewsInOrder()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(style: BillingFormHeaderCellStyle?) {
        guard let style = style else { return }
        self.style = style
        headerLabel.update(with: style.headerLabel)
    }
}

extension BillingFormHeaderView {

    private func setupViewsInOrder() {
        backgroundColor = style?.backgroundColor
        setupHeaderLabel()
    }

    private func setupHeaderLabel() {
        addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: Constants.Padding.s.rawValue),
            headerLabel.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor),
            headerLabel.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor),
            headerLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -Constants.Padding.s.rawValue)
        ])
    }
}

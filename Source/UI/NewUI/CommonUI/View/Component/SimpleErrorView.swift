import UIKit

final class SimpleErrorView: UIView {

    lazy var headerLabel: LabelView? = {
        LabelView().disabledAutoresizingIntoConstraints()
    }()

    lazy var imageContainerView: ImageContainerView? = {
        ImageContainerView().disabledAutoresizingIntoConstraints()
    }()

    init() {
        super.init(frame: .zero)
        setupViewsInOrder()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(style: ElementErrorViewStyle?) {
        guard let style = style else { return }
        backgroundColor = style.backgroundColor
        let headerLabelStyle = DefaultTitleLabelStyle(backgroundColor: .clear,
                                                      isHidden: false,
                                                      text: style.text,
                                                      font: style.font,
                                                      textColor: style.textColor)
        headerLabel?.update(with: headerLabelStyle)
        imageContainerView?.update(with: style.image, tintColor: style.tintColor)
    }
}

extension SimpleErrorView {

    private func setupViewsInOrder() {
        setupHeaderLabel()
        setupImageView()
    }

    private func setupHeaderLabel() {
        guard let headerLabel = headerLabel else { return }
        addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func setupImageView() {
        guard let headerLabel = headerLabel, let image = imageContainerView else { return }
        addSubview(image)
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor),
            image.bottomAnchor.constraint(equalTo: bottomAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.trailingAnchor.constraint(equalTo: headerLabel.leadingAnchor,
                                            constant: -CheckoutTheme.Padding.s.rawValue),
            image.widthAnchor.constraint(equalToConstant: 15)
        ])
    }
}

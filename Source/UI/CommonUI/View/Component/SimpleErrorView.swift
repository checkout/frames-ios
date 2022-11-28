import UIKit

final class SimpleErrorView: UIView {

    lazy var headerLabel: LabelView = {
        LabelView().disabledAutoresizingIntoConstraints()
    }()

    lazy var imageContainerView: ImageContainerView = {
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
        let headerLabelStyle = DefaultTitleLabelStyle(textAlignment: style.textAlignment,
                                                      backgroundColor: .clear,
                                                      isHidden: false,
                                                      text: style.text,
                                                      font: style.font,
                                                      textColor: style.textColor)
        headerLabel.update(with: headerLabelStyle)
        imageContainerView.update(with: style.image, tintColor: style.tintColor)
    }
}

extension SimpleErrorView {

    private func setupViewsInOrder() {
        setupHeaderLabel()
        setupImageView()
    }

    private func setupHeaderLabel() {
        addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func setupImageView() {
        addSubview(imageContainerView)
        NSLayoutConstraint.activate([
          imageContainerView.topAnchor.constraint(equalTo: topAnchor),
          imageContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
          imageContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
          imageContainerView.trailingAnchor.constraint(equalTo: headerLabel.leadingAnchor,
                                            constant: -Constants.Padding.s.rawValue),
          imageContainerView.widthAnchor.constraint(equalToConstant: 15)
        ])
    }
}

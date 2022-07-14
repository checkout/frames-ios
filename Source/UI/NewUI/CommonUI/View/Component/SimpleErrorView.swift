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

    func update(style: ElementErrorViewStyle) {
        backgroundColor = style.backgroundColor
        let headerLabelStyle = DefaultTitleLabelStyle(backgroundColor: .clear,
                                                      isHidden: false,
                                                      text: "",
                                                      font: style.font,
                                                      textColor: style.textColor)
        headerLabel.update(with: headerLabelStyle)

        let imageContainerViewUpdate = ImageContainerView.StateUpdate(
          image: style.image,
          tintColor: tintColor,
          isHidden: false,
          animated: false
        )

        imageContainerView.update(state: imageContainerViewUpdate)
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

extension SimpleErrorView: Stateful {
    struct StateUpdate {
        let isHidden: Bool?
        let labelText: String?
    }

    func update(state update: StateUpdate) {
        if let isHidden = update.isHidden {
            self.isHidden = isHidden
        }

        if let labelText = update.labelText {
            let labelUpdate = LabelView.StateUpdate(labelText: labelText, isHidden: nil, textColor: nil)
            headerLabel.update(state: labelUpdate)
        }
    }
}

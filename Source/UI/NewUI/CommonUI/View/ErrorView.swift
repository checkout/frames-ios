import UIKit

final class ErrorView: UIView {

    lazy var headerLabel: UILabel? = {
        let view = UILabel()
        view.textAlignment = .justified
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    lazy var image: UIImageView? = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    init() {
        super.init(frame: .zero)
        setupViewsInOrder()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(style: ElementErrorViewStyle?) {
        backgroundColor = style?.backgroundColor

        headerLabel?.text = style?.text
        headerLabel?.font = style?.font
        headerLabel?.textColor = style?.textColor
        image?.image = style?.image
        image?.tintColor = style?.tintColor
    }
}

extension ErrorView {

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
        guard let headerLabel = headerLabel, let image = image else { return }
        addSubview(image)
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor),
            image.bottomAnchor.constraint(equalTo: bottomAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.trailingAnchor.constraint(equalTo: headerLabel.leadingAnchor, constant: -10),
            image.widthAnchor.constraint(equalToConstant: 15)
        ])
    }
}

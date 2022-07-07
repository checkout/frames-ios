import UIKit

class ImageContainerView: UIView {
    private static let animationLength: TimeInterval = 0.25

    private(set) lazy var imageView: UIImageView = {
        let view = UIImageView().disabledAutoresizingIntoConstraints()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .clear
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupConstraintsInOrder()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateWithAnimation(with image: UIImage?, tintColor: UIColor? = nil) {
        UIView.transition(
            with: imageView,
            duration: Self.animationLength,
            options: .transitionCrossDissolve
        ) { [weak self] in
            self?.update(with: image, tintColor: tintColor)
        }
    }

    func update(with image: UIImage?, tintColor: UIColor? = nil) {
      imageView.image = image?.withRenderingMode(tintColor == nil ? .alwaysOriginal : .alwaysTemplate)
      imageView.tintColor = tintColor
    }

    private func setupConstraintsInOrder() {
        addSubview(imageView)
        imageView.setupConstraintEqualTo(view: self)
    }
}


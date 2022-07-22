import UIKit

class ImageContainerView: UIView {
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

    func update(with image: UIImage?, tintColor: UIColor? = nil, animated: Bool = false) {
      let updateBlock = { [weak self] in
        self?.imageView.image = image?.withRenderingMode(tintColor == nil ? .alwaysOriginal : .automatic )
        self?.imageView.tintColor = tintColor
      }

      if animated {
        UIView.transition(
            with: imageView,
            duration: Constants.Style.animationLength,
            options: .transitionCrossDissolve,
            animations: updateBlock
        )
      } else {
        updateBlock()
      }
    }

    private func setupConstraintsInOrder() {
        addSubview(imageView)
        imageView.setupConstraintEqualTo(view: self)
    }
}

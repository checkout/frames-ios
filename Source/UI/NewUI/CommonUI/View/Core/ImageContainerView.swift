import UIKit

class ImageContainerView: UIView {
    private var state = State(image: nil, tintColor: nil)

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

    private func update(with image: UIImage?, tintColor: UIColor?, animated: Bool) {
      let updateBlock = { [weak self] in
        self?.imageView.image = image?.withRenderingMode(tintColor == nil ? .alwaysOriginal : .alwaysTemplate)
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

extension ImageContainerView: Stateful {
    struct State {
        var image: UIImage?
        var tintColor: UIColor?
    }

    struct StateUpdate {
        let image: UIImage??
        let tintColor: UIColor??
        let isHidden: Bool?
        let animated: Bool
    }

    func update(state stateUpdate: StateUpdate) {
        let image = stateUpdate.image ?? state.image
        let tintColor = stateUpdate.tintColor ?? state.tintColor

        update(with: image, tintColor: tintColor, animated: stateUpdate.animated)

        if let isHidden = stateUpdate.isHidden {
            self.isHidden = isHidden
        }
    }
}

import UIKit

final class LabelView: UIView {

    private(set) lazy var label: UILabel = {
        let view = UILabel().disabledAutoresizingIntoConstraints()
        view.backgroundColor = .clear
        view.numberOfLines = 0
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

    func update(with style: ElementStyle?) {
        label.font = style?.font
        label.textColor = style?.textColor
        label.backgroundColor = style?.backgroundColor
    }

    private func setupConstraintsInOrder() {
        addSubview(label)
        label.setupConstraintEqualTo(view: self)
    }
}

extension LabelView: Stateful {
    struct StateUpdate {
        let labelText: String?
        let isHidden: Bool?
        let textColor: UIColor?
    }

    func update(state update: StateUpdate) {
        if let labelText = update.labelText {
            label.text = labelText
        }

        if let isHidden = update.isHidden {
            self.isHidden = isHidden
        }

        if let textColor = update.textColor {
            label.textColor = textColor
        }
    }
}

import UIKit

class LabelView: UIView {

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
        label.text = style?.text
        label.font = style?.font
        label.textColor = style?.textColor
        label.textAlignment = style?.textAlignment ?? .natural
        label.backgroundColor = style?.backgroundColor
    }

    private func setupConstraintsInOrder() {
        addSubview(label)
        label.setupConstraintEqualTo(view: self)
    }
}

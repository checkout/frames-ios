import UIKit

class LabelView: UIView {

    private(set) lazy var label: UILabel? = {
        let view = UILabel()
        view.backgroundColor = .clear
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
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
        label?.text = style?.text
        label?.font = style?.font
        label?.textColor = style?.textColor
        label?.backgroundColor = style?.backgroundColor
    }

    private func setupConstraintsInOrder() {
        guard let label = label else { return }
        addSubview(label)
        label.setupConstraintEqualTo(view: self)
    }
}

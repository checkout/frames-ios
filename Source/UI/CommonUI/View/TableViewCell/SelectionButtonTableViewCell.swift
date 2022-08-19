import UIKit

protocol SelectionButtonTableViewCellDelegate: AnyObject {
    func selectionButtonIsPressed(tag: Int)
}

final class SelectionButtonTableViewCell: UITableViewCell {
    weak var delegate: SelectionButtonTableViewCellDelegate?

    private lazy var mainView: SelectionButtonView = {
        let view = SelectionButtonView().disabledAutoresizingIntoConstraints()
        view.delegate = self
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        self.setupViewsInOrder()
    }

    func update(style: CellButtonStyle, tag: Int) {
        self.tag = tag
        mainView.update(style: style)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SelectionButtonTableViewCell {

    private func setupViewsInOrder() {
        contentView.addSubview(mainView)
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constants.Padding.l.rawValue),
            mainView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor),
            mainView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor),
            mainView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor)
        ])
    }
}

extension SelectionButtonTableViewCell: SelectionButtonViewDelegate {
    func selectionButtonIsPressed() {
        delegate?.selectionButtonIsPressed(tag: tag)
    }
}

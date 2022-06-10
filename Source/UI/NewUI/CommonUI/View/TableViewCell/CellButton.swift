import UIKit

protocol CellButtonDelegate: AnyObject {
    func buttonIsPressed(tag: Int)
}
// TODO: This is unfinished work. it will be finished in the Country selection ticket.
final class CellButton: UITableViewCell {
    weak var delegate: CellButtonDelegate?
    var type: BillingFormCell?
    var style: CellButtonStyle?

    private lazy var mainView: SelectionButtonView? = {
        let view = SelectionButtonView(style: style, type: type)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        self.setupViewsInOrder()
    }

    func update(type: BillingFormCell?, style: CellButtonStyle?, tag: Int) {
        self.type = type
        self.style = style
        self.tag = tag
        mainView?.update(style: style, type: type)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CellButton {

    private func setupViewsInOrder() {
        guard let mainView = mainView else { return }
        contentView.addSubview(mainView)
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(
                equalTo: contentView.topAnchor),
            mainView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor),
            mainView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor),
            mainView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -24)
        ])
    }
}

extension CellButton: SelectionButtonViewDelegate {
    func buttonIsPressed() {
        delegate?.buttonIsPressed(tag: tag)
    }
}

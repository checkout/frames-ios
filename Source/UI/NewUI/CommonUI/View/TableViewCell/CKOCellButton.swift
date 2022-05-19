import UIKit

protocol CKOCellButtonDelegate: AnyObject {
    func buttonIsPressed()
}

final class CKOCellButton: UITableViewCell {
    weak var delegate: CKOCellButtonDelegate?

    private var mainView: UIView
    
    init(mainView: UIView) {
        self.mainView = mainView
        super.init(style: .default, reuseIdentifier: nil)
        self.setupViewsInOrder()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CKOCellButton {

    private func setupViewsInOrder() {
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




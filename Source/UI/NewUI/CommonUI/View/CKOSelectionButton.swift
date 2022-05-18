import UIKit

class CKOSelectionButton: UIView {
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        return view
    }()

    private(set) lazy var imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

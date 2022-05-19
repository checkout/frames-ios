import UIKit

//TODO: Should be completed in another ticket.
class CKOSelectionButton: UIView {
    private var style: CKOElementButtonStyle

    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = style.text
        view.font = style.font
        view.textColor = style.textColor
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    private(set) lazy var image: UIImageView = {
        let view = UIImageView()
        view.image = "warning".vectorPDFImage(forClass: CKOSelectionButton.self)
        view.tintColor = style.activeTintColor
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    init(style: CKOElementButtonStyle) {
        self.style = style
        super.init(frame: .zero)
       setupViewsInOrder()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CKOSelectionButton {

    private func setupViewsInOrder(){
        clipsToBounds = true
        layer.cornerRadius = 2.0
        layer.borderColor = style.textColor.cgColor
        layer.borderWidth = 1.0
        backgroundColor = style.backgroundColor
        setupHeaderLabel()
        setupImageView()
    }

    private func setupHeaderLabel() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func setupImageView() {
        addSubview(image)
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor),
            image.bottomAnchor.constraint(equalTo: bottomAnchor),
            image.trailingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            image.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 8),
            image.widthAnchor.constraint(equalToConstant: 15)
        ])
    }

}

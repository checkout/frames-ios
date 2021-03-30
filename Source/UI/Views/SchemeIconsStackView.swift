import UIKit

class SchemeIconsStackView: UIStackView {

    var shouldSetupConstraints = true

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        translatesAutoresizingMaskIntoConstraints = false
    }

    func addSchemeIcon(scheme: CardScheme) {
        let imageView = UIImageView()
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        let image = "icon-\(scheme.rawValue)".image(forClass: SchemeIconsStackView.self)
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false

        addArrangedSubview(imageView)
        imageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }

    public func setIcons(schemes: [CardScheme]) {
        schemes.forEach { scheme in
            addSchemeIcon(scheme: scheme)
        }
        addFillerView()
    }

    private func addFillerView() {
        let fillerView = UIView()
        fillerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        fillerView.backgroundColor = .clear
        fillerView.translatesAutoresizingMaskIntoConstraints = false
        addArrangedSubview(fillerView)
    }
}

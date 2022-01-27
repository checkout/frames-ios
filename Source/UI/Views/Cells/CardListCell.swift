import UIKit

/// Table View Cell adapted to display a card.
public class CardListCell: UITableViewCell {

    // MARK: - Properties

    let stackView = UIStackView()

    /// Scheme Image View
    public let schemeImageView = UIImageView()

    /// Selected Cell Image View
    public let selectedImageView = UIImageView()

    /// Card Information Label
    public let cardInfoLabel = UILabel()

    // MARK: - Initialization

    /// Initializes a table cell with a style and a reuse identifier and returns it to the caller.
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    /// Returns an object initialized from data in a given unarchiver.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        stackView.addArrangedSubview(cardInfoLabel)
        addSubview(stackView)
        addSubview(schemeImageView)
        addSubview(selectedImageView)
        stackView.axis = .vertical
        stackView.spacing = 16
        addConstraints()
    }

    private func addConstraints() {
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        // constraints
        stackView.translatesAutoresizingMaskIntoConstraints = false
        schemeImageView.translatesAutoresizingMaskIntoConstraints = false
        selectedImageView.translatesAutoresizingMaskIntoConstraints = false
        // setup
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 8).isActive = true
        schemeImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        schemeImageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        schemeImageView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        layoutMarginsGuide.trailingAnchor.constraint(equalTo: selectedImageView.trailingAnchor, constant: 8)
            .isActive = true
        selectedImageView.leadingAnchor.constraint(equalTo: schemeImageView.trailingAnchor, constant: 8).isActive = true
        selectedImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        selectedImageView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        selectedImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
    }

    // MARK: - Methods

    /// Sets the selected state of the cell, optionally animating the transition between states.
    override public func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            let image = "checkmark".image(forClass: CardListCell.self)
            selectedImageView.image = image
        } else {
            selectedImageView.image = nil
        }
    }

    /// Set the scheme icon of the card cell.
    ///
    /// - parameter scheme: Scheme (e.g. CardScheme.visa)
    public func setSchemeIcon(scheme: CardScheme) {
        let image = "schemes/icon-\(scheme.rawValue)".image(forClass: CardListCell.self)
        schemeImageView.image = image
    }

}

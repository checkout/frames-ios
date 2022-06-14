import UIKit

protocol SelectionButtonViewDelegate: AnyObject {
    func buttonIsPressed()
}

class SelectionButtonView: UIView {
    weak var delegate: SelectionButtonViewDelegate?

    private var style: CellButtonStyle?
    private var type: BillingFormCell?

    private(set) lazy var titleLabel: UILabel? = {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private(set) lazy var countryLabel: UILabel? = {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private(set) lazy var image: UIImageView? = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    private(set) lazy var button: UIButton? = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(buttonIsPressed), for: .touchUpInside)
        return view
    }()

    private(set) lazy var errorView: ErrorView? = {
        let view = ErrorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(style: CellButtonStyle?, type: BillingFormCell?) {
        self.style = style
        self.type = type
        super.init(frame: .zero)
        setupViewsInOrder()
    }

    func update(style: CellButtonStyle?, type: BillingFormCell?) {
        guard let type = type, let style = style else { return }
        self.type = type
        self.style = style

        /// title label style
        titleLabel?.text = style.title?.text
        titleLabel?.font = style.title?.font
        titleLabel?.textColor = style.title?.textColor
        titleLabel?.backgroundColor = style.title?.backgroundColor

        /// title label style
        countryLabel?.text = style.button.text
        countryLabel?.font = style.button.font
        countryLabel?.textColor = style.title?.textColor

        /// image view style
        image?.image = style.button.image
        image?.tintColor = style.button.disabledTintColor

        /// select Button style
        button?.isEnabled = style.button.isEnabled
        button?.tintColor = .clear
        button?.backgroundColor = style.button.backgroundColor
        button?.clipsToBounds = true
        button?.layer.borderColor = style.button.normalBorderColor.cgColor
        button?.layer.cornerRadius = style.button.cornerRadius
        button?.layer.borderWidth = style.button.borderWidth

        updateErrorView(style: style)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func buttonIsPressed(){
        delegate?.buttonIsPressed()
    }

    private func updateErrorView(style: CellButtonStyle) {
        errorView?.update(style: style.error)
        errorView?.isHidden = style.error?.isHidden ?? true
    }
}

extension SelectionButtonView {

    private func setupViewsInOrder(){
        setupTitleLabel()
        setupButton()
        setupCountryLabel()
        setupImageView()
        setupErrorView()
    }

    private func setupTitleLabel() {
        guard let titleLabel = titleLabel else { return }
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func setupCountryLabel() {
        guard let countryLabel = countryLabel else { return }
        guard let titleLabel = titleLabel else { return }
        addSubview(countryLabel)
        let heightStyle = style?.button.height ?? Constants.Style.BillingForm.InputCountryButton.height.rawValue

        NSLayoutConstraint.activate([
            countryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            countryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            countryLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            countryLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            countryLabel.heightAnchor.constraint(equalToConstant: heightStyle)
        ])
    }

    private func setupImageView() {
        guard let image = image else { return }
        guard let countryLabel = countryLabel else { return }
        addSubview(image)
        NSLayoutConstraint.activate([
            image.centerYAnchor.constraint(equalTo: countryLabel.centerYAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            image.widthAnchor.constraint(equalToConstant: 15),
            image.heightAnchor.constraint(equalToConstant: 15)
        ])
    }

    private func setupButton() {
        guard let button = button else { return }
        guard let titleLabel = titleLabel else { return }
        addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),

        ])
    }

    private func setupErrorView() {
        guard let errorView = errorView else { return }
        guard let countryLabel = countryLabel else { return }
        addSubview(errorView)
        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: countryLabel.bottomAnchor),
            errorView.leadingAnchor.constraint(equalTo: countryLabel.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: countryLabel.trailingAnchor),
            errorView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

}

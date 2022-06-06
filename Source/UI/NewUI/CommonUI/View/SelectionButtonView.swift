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
        view.backgroundColor = .white
        return view
    }()

    private(set) lazy var image: UIImageView? = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
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

        /// view style
        clipsToBounds = true
        backgroundColor = style.button.backgroundColor
        layer.borderColor = style.button.normalBorderColor.cgColor
        layer.cornerRadius = 10.0
        layer.borderWidth = 1.0

        /// title label style
        titleLabel?.text = style.button.text
        titleLabel?.font = style.button.font
        titleLabel?.textColor = style.title?.textColor

        /// image view style
        image?.image = style.button.image
        image?.tintColor = style.button.disabledTintColor

        /// select Button style
        button?.isEnabled = style.button.isEnabled
        button?.tintColor = .clear
        button?.backgroundColor = .clear
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
        errorView?.isHidden = style.error.isHidden
    }
}

extension SelectionButtonView {

    private func setupViewsInOrder(){
        setupTitleLabel()
        setupImageView()
        setupButton()
        setupErrorView()
    }

    private func setupTitleLabel() {
        guard let titleLabel = titleLabel else { return }
        addSubview(titleLabel)
        let heightStyle = style?.button.height ?? Constants.Style.BillingForm.InputCountryButton.height.rawValue

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: heightStyle)
        ])
    }

    private func setupImageView() {
        guard let image = image else { return }
        guard let titleLabel = titleLabel else { return }
        addSubview(image)
        NSLayoutConstraint.activate([
            image.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
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
            button.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            button.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),

        ])
    }

    private func setupErrorView() {
        guard let errorView = errorView else { return }
        guard let titleLabel = titleLabel else { return }
        addSubview(errorView)
        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            errorView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            errorView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

}

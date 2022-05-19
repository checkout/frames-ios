import UIKit

final class ErrorView: UIView {
    private var style: ElementErrorViewStyle = DefaultErrorInputLabelStyle()
    
    lazy var headerLabel: UILabel = {
        let view = UILabel()
        view.text = style.text
        view.font = style.font
        view.textColor = style.textColor
        view.textAlignment = .justified
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var image: UIImageView = {
        let view = UIImageView()
        view.image = "warning".vectorPDFImage(forClass: ErrorView.self)
        view.tintColor = style.tintColor
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    init(style: ElementErrorViewStyle) {
        super.init(frame: .zero)
        self.style = style
        setupViewsInOrder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ErrorView {

    private func setupViewsInOrder(){
        backgroundColor = style.backgroundColor
        setupHeaderLabel()
        setupImageView()
    }
    
    private func setupHeaderLabel() {
        addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func setupImageView() {
        addSubview(image)
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor),
            image.bottomAnchor.constraint(equalTo: bottomAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.trailingAnchor.constraint(equalTo: headerLabel.leadingAnchor, constant: -10),
            image.widthAnchor.constraint(equalToConstant: 15)
            
        ])
    }
    
}

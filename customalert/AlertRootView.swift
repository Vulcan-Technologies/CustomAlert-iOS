//
//  AlertRootView.swift
//  customalert
//
//  Created by Mikael Mukhsikaroyan on 8/6/20.
//

import UIKit

class VulcanButton: UIButton {
    var completion: (()->Void)?
}

class AlertRootView: UIView {

    struct Model {
        let title: String?
        let message: String?
    }

    // MARK: Properties

    let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: blurEffect)

        return view
    }()

    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8

        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textColor = .black
        label.textAlignment = .center

        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .black
        label.textAlignment = .center

        return label
    }()

    private let buttonsStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 4
        view.axis = .vertical
        view.distribution = .fill

        return view
    }()

    private let textFieldsStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 4
        view.axis = .vertical
        view.distribution = .fill

        return view
    }()

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureView()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Configuration

    func configureView() {
        backgroundColor = .clear

        addSubview(blurView)
        addSubview(container)
        container.addSubview(titleLabel)
        container.addSubview(messageLabel)
        container.addSubview(buttonsStackView)
        container.addSubview(textFieldsStackView)
    }

    func configureConstraints() {
        blurView.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        let containerPadding: CGFloat = 20
        container.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: containerPadding),
            trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: containerPadding),
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            container.heightAnchor.constraint(greaterThanOrEqualToConstant: 10)
        ])

        let labelPadding: CGFloat = 8
        titleLabel.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: labelPadding),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: labelPadding),
            container.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: labelPadding)
        ])

        messageLabel.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])

        let stackViewPadding: CGFloat = 8
        textFieldsStackView.activate([
            textFieldsStackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: stackViewPadding),
            textFieldsStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: stackViewPadding),
            container.trailingAnchor.constraint(equalTo: textFieldsStackView.trailingAnchor, constant: stackViewPadding)
        ])

        buttonsStackView.activate([
            container.bottomAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: stackViewPadding),
            buttonsStackView.leadingAnchor.constraint(equalTo: textFieldsStackView.leadingAnchor),
            buttonsStackView.trailingAnchor.constraint(equalTo: textFieldsStackView.trailingAnchor),
            buttonsStackView.topAnchor.constraint(equalTo: textFieldsStackView.bottomAnchor, constant: stackViewPadding)
        ])
    }

    // MARK: Helpers

    func addTextField() -> UITextField {
        let field = UITextField()
        field.layer.cornerRadius = 4
        field.backgroundColor = .systemGray5
        field.font = UIFont.preferredFont(forTextStyle: .body)
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        field.leftViewMode = .always
        field.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        field.rightViewMode = .always

        field.activate([
            field.heightAnchor.constraint(equalToConstant: 30)
        ])

        textFieldsStackView.addArrangedSubview(field)

        return field
    }

    func addButton(_ action: VulcanAction) -> VulcanButton {
        let button = VulcanButton(type: .system)
        button.layer.cornerRadius = 4
        button.setTitle(action.title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)

        switch action.style {
        case .cancel:
            button.backgroundColor = .systemGray4
            button.setTitleColor(.systemBlue, for: .normal)
        case .default:
            button.backgroundColor = .systemBlue
        case .destructive:
            button.backgroundColor = .systemRed
        }

        buttonsStackView.addArrangedSubview(button)

        return button
    }

    // MARK: Populate

    func populate(using model: Model) {
        titleLabel.text = model.title
        messageLabel.text = model.message
    }

    // MARK: Animations

    func animateIn(completion: @escaping ()->Void) {
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeIn, animations: nil)

        blurView.alpha = 0
        container.alpha = 0
        container.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        animator.addAnimations {
            self.container.alpha = 1
            self.blurView.alpha = 1
            self.container.transform = .identity
        }

        animator.addCompletion { _ in
            completion()
        }

        animator.startAnimation()
    }

    func animteOut(completion: @escaping ()->Void) {
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeIn, animations: nil)

        animator.addAnimations {
            self.blurView.alpha = 0
            self.container.alpha = 0
            self.container.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }

        animator.addCompletion { _ in
            completion()
        }

        animator.startAnimation()
    }
}

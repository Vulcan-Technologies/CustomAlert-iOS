//
//  ViewController.swift
//  customalert
//
//  Created by Mikael Mukhsikaroyan on 8/1/20.
//

import UIKit

extension UIView {
    func activate(_ constraints: [NSLayoutConstraint]) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }
}

class ViewController: UIViewController {

    lazy var button1: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Show iOS Alert", for: .normal)
        view.backgroundColor = .systemBlue
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        view.addTarget(self, action: #selector(didTapButton1(_:)), for: .touchUpInside)

        return view
    }()

    lazy var button2: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Show Vulcan Alert", for: .normal)
        view.backgroundColor = .systemBlue
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        view.addTarget(self, action: #selector(didTapButton2(_:)), for: .touchUpInside)

        return view
    }()

    let buttonsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 6

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemRed

        view.addSubview(buttonsStackView)
        buttonsStackView.activate([
            view.bottomAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 50),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        buttonsStackView.addArrangedSubview(button1)
        buttonsStackView.addArrangedSubview(button2)
    }

    @objc func didTapButton1(_ sender: UIButton) {
        let alert = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            print("Cancel tapped")
        }))

        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            print("Delete tapped")
        }))

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            print("Ok tapped")
        }))

        alert.addTextField { field in
            field.backgroundColor = .systemPink
        }

        present(alert, animated: true, completion: nil)
    }

    @objc func didTapButton2(_ sender: UIButton) {
        let alert = VulcanAlert(title: "Title", message: "This is the message")

        alert.addAction(VulcanAction(title: "Cancel", style: .cancel, completion: {
            print("Cancel tapped")
        }))

        alert.addAction(VulcanAction(title: "Ok", style: .default, completion: {
            print("Ok tapped")
        }))

        alert.addAction(VulcanAction(title: "Delete", style: .destructive, completion: {
            print("Delete tapped")
        }))

        alert.addTextField { field in
            field.placeholder = "Enter username"
        }

        alert.addTextField { field in
            field.placeholder = "Enter password"
        }

        present(alert, animated: false, completion: nil)
    }

}


//
//  VulcanAlert.swift
//  customalert
//
//  Created by Mikael Mukhsikaroyan on 8/2/20.
//

import UIKit

class VulcanAlert: UIViewController {

    private let rootView = AlertRootView()
    private(set) var textFields = [UITextField]()
    private(set) var actions = [VulcanAction]()
    private let alertTitle: String?
    private let message: String?

    // MARK: Lifecycle

    override func loadView() {
        view = rootView
    }

    init(title: String?, message: String?) {
        self.alertTitle = title
        self.message = message
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapBackground(_:)))
        rootView.blurView.addGestureRecognizer(tap)

        rootView.populate(using: AlertRootView.Model(title: self.alertTitle, message: self.message))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        rootView.animateIn {
            // do stuff
        }
    }

    // MARK: Actions

    @objc private func didTapBackground(_ sender: UITapGestureRecognizer) {
        rootView.animteOut {
            self.dismiss(animated: false, completion: nil)
        }
    }

    @objc private func didTapButton(_ sender: VulcanButton) {
        rootView.animteOut {
            sender.completion?()
            self.dismiss(animated: false, completion: nil)
        }
    }

    func addAction(_ action: VulcanAction) {
        self.actions.append(action)

        let button = rootView.addButton(action)
        button.completion = action.completion
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    }

    func addTextField(_ completion: (_ field: UITextField)->Void) {
        let field = rootView.addTextField()
        self.textFields.append(field)

        completion(field)
    }
}

class VulcanAction {
    enum Style {
        case `default`
        case cancel
        case destructive
    }

    let style: Style
    let title: String
    let completion: (()->Void)?

    init(title: String, style: Style, completion: (()->Void)?) {
        self.title = title
        self.style = style
        self.completion = completion
    }
}

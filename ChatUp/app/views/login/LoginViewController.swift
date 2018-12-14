//
//  LoginViewController.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/11/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, CreatedFromNib {

	deinit {
		let typeName = String(describing: self)
		print("\(typeName) instance was deallocated.")
	}

	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!

	weak var coordinator: LoginCoordinator?
	var loginService: LoginServicing?

	override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		initViews()
    }

	private func initViews() {
		initTextFields()
	}

	private func initTextFields() {
		#if DEBUG
		self.emailTextField.text = "jimuelpalaca@gmail.com"
		self.passwordTextField.text = "hello123"
		#endif
	}

	// MARK: - Actions
	@IBAction func didTapLogin(_ sender: UIButton) {
		guard let email = validateAndGetEmail() else {
			showAlert(withType: .error, andMessage: "Invalid Email")
			return
		}
		guard let password = validateAndGetPassword() else {
			showAlert(withType: .error, andMessage: "Invalid Password")
			return
		}
		loginService?.login(withEmail: email, andPassword: password)
	}

	@IBAction func didTapRegister(_ sender: Any) {
		coordinator?.loginGoToRegistration()
	}

	private func validateAndGetEmail() -> String? {
		guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return nil }
		guard email != "" else { return nil  }
		return email
	}

	private func validateAndGetPassword() -> String? {
		guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return nil }
		guard password != "" else { return nil }
		return password
	}

}

extension LoginViewController: LoginServiceable {

	func loginSuccess() {
		coordinator?.loginGoToChat()
	}

	func loginFailed(withError message: String) {
		showAlert(withType: .error, andMessage: "Login Error - \(message)")
	}

}

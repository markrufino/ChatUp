//
//  RegistrationViewController.swift
//  ChatUp
//
//  Created by Mark D. Rufino on 12/14/2018.
//  Copyright © 2018 markrufino. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController, CreatedFromNib {

	deinit {
		let typeName = String(describing: self)
		print("\(typeName) instance was deallocated.")
	}
	
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var confirmPasswordTextField: UITextField!

	weak var coordinator: RegistrationCoordinator?
	var registrationService: RegistrationServicing?

    override func viewDidLoad() {
        super.viewDidLoad()
		initViews()
	}

	private func initViews() {
		initTextFields()
	}

	private func initTextFields() {
	}

	// MARK: - Actions
	
	@IBAction func didTapRegister(_ sender: Any) {
		guard let name = nameTextField.getTrimmedText() else {
			showAlert(withType: .error, andMessage: "All fields are required.")
			return
		}
		guard let email = emailTextField.getTrimmedText() else {
			showAlert(withType: .error, andMessage: "All fields are required.")
			return
		}
		guard let password = passwordTextField.getTrimmedText() else {
			showAlert(withType: .error, andMessage: "All fields are required.")
			return
		}
		guard let confirmPassword = confirmPasswordTextField.getTrimmedText() else {
			showAlert(withType: .error, andMessage: "All fields are required.")
			return
		}
		guard password == confirmPassword else {
			showAlert(withType: .error, andMessage: "Passwords didn't match.")
			return
		}

		showHUD()
		registrationService?.registerUser(withName: name, email: email, andPassword: password)
	}

	@IBAction func didTapBackToLogin(_ sender: Any) {
		coordinator?.registrationGoBackToLogin()
	}

}

extension RegistrationViewController: RegistrationServiceable {
	
	func registrationSuccess() {
		hideHUD()
		coordinator?.registrationGoToChat()
	}

	func registrationFailed(withError message: String) {
		hideHUD()
		showAlert(withType: .error, andMessage: message)
	}

}

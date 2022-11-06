//
//  AuthViewController.swift
//  Nanameue
//
//  Created by Stanley Lim on 25/10/2022.
//

import UIKit
import FirebaseAuth

class AuthViewController: UIViewController {
    
    var rootView: AuthView {
        return view as! AuthView
    }
    
    override func loadView() {
        view = AuthView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        rootView.signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        rootView.signInButton.addTarget(self, action: #selector(signInButtonPressed), for: .touchUpInside)
    }
    
    @objc private func signUpButtonPressed() {
      signUp()
    }
    
    @objc private func signInButtonPressed() {
      signIn()
    }
    
    private func showErrorAlert(message: String) {
        let alertController = UIAlertController(
            title: nil,
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Alert.OK.Button.Title".localized(), style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    private func signUp() {
        //      AppSettings.displayName = name
        Auth.auth().createUser(withEmail: rootView.emailTextField.text ?? "", password: rootView.passwordTextField.text ?? "") { [weak self] _, error in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.showErrorAlert(message: error.localizedDescription)
                return
            }
        }
    }
    
    private func signIn() {
        //      AppSettings.displayName = name
        Auth.auth().signIn(withEmail: rootView.emailTextField.text ?? "", password: rootView.passwordTextField.text ?? "") { [weak self] _, error in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.showErrorAlert(message: error.localizedDescription)
                return
            }
        }
    }
    
    // MARK: - Actions
    @IBAction private func actionButtonPressed() {
        signIn()
    }
    
}

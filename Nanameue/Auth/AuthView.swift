//
//  AuthView.swift
//  Nanameue
//
//  Created by Stanley Lim on 25/10/2022.
//

import UIKit

class AuthView: UIView {
    lazy var titleContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.required, for: .vertical)
        return view
    }()
    lazy var titleImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Logo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        imageView.setContentHuggingPriority(.required, for: .vertical)
        return imageView
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        label.text = "Home.Title.AppName".localized()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    lazy var emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.keyboardType = .emailAddress
        emailTextField.textContentType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.adjustsFontSizeToFitWidth = false
        emailTextField.placeholder = "Home.Email.Placeholder".localized()
        emailTextField.clipsToBounds = true
        emailTextField.borderStyle = .roundedRect
        emailTextField.overrideUserInterfaceStyle = .light
        return emailTextField
    }()
    
    lazy var passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.textContentType = .password
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocapitalizationType = .none
        passwordTextField.placeholder = "Home.Password.Placeholder".localized()
        passwordTextField.adjustsFontSizeToFitWidth = false
        passwordTextField.clipsToBounds = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.overrideUserInterfaceStyle = .light
        return passwordTextField
    }()
    
    lazy var signUpButton: UIButton = {
        let newButton = UIButton(type: .roundedRect)
        newButton.translatesAutoresizingMaskIntoConstraints = false
        newButton.layer.cornerRadius = 22.0
        newButton.setTitle("Home.SignUp.Button.Title".localized(), for: .normal)
        newButton.backgroundColor = .systemCyan
        newButton.clipsToBounds = true
        newButton.setTitleColor(.systemBackground, for: .normal)
        return newButton
    }()
    
    lazy var orLabel: UILabel = {
        let orLabel = UILabel()
        orLabel.translatesAutoresizingMaskIntoConstraints = false
        orLabel.font = UIFont.preferredFont(forTextStyle: .body)
        orLabel.textColor = .label
        orLabel.text = "Home.Or.Label.Separator".localized()
        return orLabel
    }()
    
    lazy var signInButton: UIButton = {
        let newButton = UIButton(type: .roundedRect)
        newButton.translatesAutoresizingMaskIntoConstraints = false
        newButton.layer.cornerRadius = 22.0
        newButton.setTitle("Home.SignIn.Button.Title".localized(), for: .normal)
        newButton.backgroundColor = .systemCyan
        newButton.clipsToBounds = true
        newButton.setTitleColor(.systemBackground, for: .normal)
        return newButton
    }()
    
    // MARK: - Initializer and Lifecycle Methods -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    convenience init(frame: CGRect, layout: UICollectionViewLayout) {
        self.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupSubviews() {
        backgroundColor = .systemMint
        addSubview(titleContainer)
        titleContainer.addSubview(titleImage)
        titleContainer.addSubview(titleLabel)
        
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(signUpButton)
        addSubview(orLabel)
        addSubview(signInButton)
        
        NSLayoutConstraint.activate([
            titleContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 32),
            titleContainer.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleContainer.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            titleImage.topAnchor.constraint(equalTo: titleContainer.topAnchor),
            titleImage.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor),
            titleImage.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: titleImage.bottomAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: titleContainer.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: titleContainer.bottomAnchor),
            
            emailTextField.topAnchor.constraint(greaterThanOrEqualTo: titleContainer.bottomAnchor, constant: 16),
            emailTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40),
            signUpButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            signUpButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            signUpButton.heightAnchor.constraint(equalToConstant: 44),
            
            orLabel.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 40),
            orLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            
            signInButton.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 40),
            signInButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            signInButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            signInButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -32),
            signInButton.heightAnchor.constraint(equalToConstant: 44)
            
            
        ])
        
    }
}

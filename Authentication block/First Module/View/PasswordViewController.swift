//
//  PasswordViewController.swift
//  Authentication block
//
//  Created by Алексей Коваленко on 13.10.2022.
//

import UIKit
import BottomSheet

protocol PasswordViewProtocol: AnyObject {
    //MVP Protocol
    var rootViewContoroller: SignInViewProtocol! {get set}
    var presenter: StartHerePresenterProtocol! {get set}
    init(rootViewContoroller: SignInViewProtocol, initialHeight: CGFloat, presenter: StartHerePresenterProtocol)
    // View protocol
    var currentViewHeight: CGFloat! {get set}
    // Methods
    func dismissThisVC()
}


class PasswordViewController: UIViewController, PasswordViewProtocol {
    //MARK: MVP protocol
    weak var rootViewContoroller: SignInViewProtocol!
    weak var presenter: StartHerePresenterProtocol!
    //MARK: View protocol
    var currentViewHeight: CGFloat!
    //MARK: INIT
    required init(rootViewContoroller: SignInViewProtocol, initialHeight: CGFloat, presenter: StartHerePresenterProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.rootViewContoroller = rootViewContoroller
        self.presenter = presenter
        preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: initialHeight)
        currentViewHeight = initialHeight
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: OUTLETS
    var passwordLabel: UILabel!
    var passwordTextField: UITextField!
    var createAccountButton: UIButton!
    var tryToLoginButton: UIButton!
    var noSuchUserLabel: UILabel!
    var registerButton: UIButton!
    var tryAgainButton: UIButton!
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    //MARK: METHODS
    func setupViews() {
        //mark@view
        view.backgroundColor = .white

        //setup@passwordLabel
        passwordLabel = UILabel()
        view.addSubview(passwordLabel)
        passwordLabel.textColor = .black
        passwordLabel.text = "PASSWORD"
        passwordLabel.font = Appearance.titlesFont
        //constraints@passwordLabel
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 3).isActive = true
        passwordLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        passwordLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        passwordLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        //setup@passwordTextField
        passwordTextField = UITextField()
        view.addSubview(passwordTextField)
        passwordTextField.placeholder = "password"
        passwordTextField.font = Appearance.smallCursiveFont
        let bottomLine = CALayer()
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        passwordTextField.borderStyle = UITextField.BorderStyle.none
        passwordTextField.layer.addSublayer(bottomLine)
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        //constraints@passwordTextField
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 10).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: passwordLabel.widthAnchor).isActive = true
        let passwordTextfieldHeighConstraint: CGFloat = 20
        passwordTextField.heightAnchor.constraint(equalToConstant: passwordTextfieldHeighConstraint).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: passwordLabel.leftAnchor, constant: 0).isActive = true
        bottomLine.frame = CGRect(x: 0.0, y: passwordTextfieldHeighConstraint, width: view.frame.width - 50, height: 1.0)
        
        //setup@tryToLoginButton
        tryToLoginButton = UIButton()
        view.addSubview(tryToLoginButton)
        tryToLoginButton.setTitle("log in", for: .normal)
        tryToLoginButton.backgroundColor = .white
        tryToLoginButton.titleLabel?.font = Appearance.buttomsFont
        tryToLoginButton.setTitleColor(.orange, for: .normal)
        tryToLoginButton.isHidden = true
        tryToLoginButton.layer.cornerRadius = 15
        tryToLoginButton.addTarget(self, action: #selector(tryToLogin), for: .touchUpInside)
        //constraints@tryToLoginButton
        tryToLoginButton.translatesAutoresizingMaskIntoConstraints = false
        tryToLoginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10).isActive = true
        tryToLoginButton.leftAnchor.constraint(equalTo: passwordTextField.leftAnchor, constant: 0).isActive = true
        tryToLoginButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        tryToLoginButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
        
        //setup@createAccountButton
        createAccountButton = UIButton()
        view.addSubview(createAccountButton)
        createAccountButton.setTitle("create account", for: .normal)
        createAccountButton.backgroundColor = .orange
        createAccountButton.titleLabel?.font = Appearance.buttomsFont
        createAccountButton.titleLabel?.textAlignment = .left
        createAccountButton.layer.cornerRadius = 15
        createAccountButton.addTarget(self, action: #selector(countinueToRegistration), for: .touchUpInside)
        //constraints@createAccountButton
        createAccountButton.translatesAutoresizingMaskIntoConstraints = false
        createAccountButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10).isActive = true
        createAccountButton.leftAnchor.constraint(equalTo: tryToLoginButton.rightAnchor).isActive = true
        createAccountButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        createAccountButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
    }
    //MARK: NAVIGATION
    @objc func tryToLogin() {
        //TODO: ALERT LOGIN SHOULD HAVE AT LEAST 5 SYMBOLS
        // если успешно, то показать залогиненный вьюконтроллер
        // если логина и пароля такого нет, то ниже высплывают остальные элементы — noSuchUserLabel, registerButton, tryAgainButton
        //TODO: настроить
    }
    @objc func countinueToRegistration() {
        preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: currentViewHeight)
        let viewControllerToPresent = RegistrationViewController(rootViewContoroller: self, initialHeight: 300, presenter: self.presenter)
        presenter.password = self.passwordTextField.text ?? ""
        presentBottomSheetInsideNavigationController(
            viewController: viewControllerToPresent,
            configuration:.init(cornerRadius: 15, pullBarConfiguration: .visible(.init(height: -5)), shadowConfiguration: .default))
    }
    //MARK: Deinit
    func dismissThisVC() {
        self.dismiss(animated: true)
    }
    deinit {
        print("PasswordViewController was deinited")
    }
}

//MARK: UITextFieldDelegate
extension PasswordViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        tryToLoginButton.isHidden = false
        preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: currentViewHeight + 260)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: currentViewHeight)
        if textField == self.passwordTextField {
            if self.passwordTextField.text?.count == 0 || self.passwordTextField.text == nil {
                tryToLoginButton.isHidden = true
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.passwordTextField {
            textField.resignFirstResponder()
            tryToLogin()
        }
        return true
    }
}

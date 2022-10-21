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
    var keyboardHeight: CGFloat! {get set}
    // Methods
    func dismissThisVC()
}


class PasswordViewController: UIViewController, PasswordViewProtocol {
    //MARK: MVP protocol
    weak var rootViewContoroller: SignInViewProtocol!
    weak var presenter: StartHerePresenterProtocol!
    //MARK: View protocol
    var currentViewHeight: CGFloat!
    var keyboardHeight: CGFloat!
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
    var errorLabel: UILabel? = nil
    var forgotPasswordButton: UIButton? = nil
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupKeyBoardNotification()
    }
    //MARK: METHODS
    //MARK: View methods
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
        passwordTextField.font = Appearance.buttomsFont
        let bottomLine = CALayer()
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        passwordTextField.borderStyle = UITextField.BorderStyle.none
        passwordTextField.layer.addSublayer(bottomLine)
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocorrectionType = .no
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
        createAccountButton.addTarget(self, action: #selector(tryToRegister), for: .touchUpInside)
        //constraints@createAccountButton
        createAccountButton.translatesAutoresizingMaskIntoConstraints = false
        createAccountButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10).isActive = true
        createAccountButton.leftAnchor.constraint(equalTo: tryToLoginButton.rightAnchor).isActive = true
        createAccountButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        createAccountButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
    }
    func showPasswordError() {
        self.passwordTextField.layer.sublayers?.first?.backgroundColor = UIColor.red.cgColor
        passwordTextField.text = ""
        passwordTextField.placeholder = "Your password must be longer than 6 characters"
    }
    func showLoginError() {
        //setup@errorLabel
        errorLabel = UILabel()
        self.view.addSubview(errorLabel ?? UILabel())
        errorLabel?.numberOfLines = 0
        errorLabel?.textColor = .red
        errorLabel?.textAlignment = .left
        errorLabel?.text = "check the Internet connection and the correctness of the entered data"
        errorLabel?.font = Appearance.buttomsFont
        //constraints@errorLabel
        errorLabel?.translatesAutoresizingMaskIntoConstraints = false
        errorLabel?.topAnchor.constraint(equalTo: self.createAccountButton.bottomAnchor, constant: 5).isActive = true
        errorLabel?.leftAnchor.constraint(equalTo: self.tryToLoginButton.leftAnchor, constant: 10).isActive = true
        errorLabel?.widthAnchor.constraint(equalToConstant: 250).isActive = true
        errorLabel?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //setup@forgotPasswordButton
        forgotPasswordButton = UIButton()
        self.view.addSubview(forgotPasswordButton ?? UIButton())
        forgotPasswordButton?.setTitle("I forgot password", for: .normal)
        forgotPasswordButton?.backgroundColor = .white
        forgotPasswordButton?.titleLabel?.font = Appearance.buttomsFont
        forgotPasswordButton?.setTitleColor(.orange, for: .normal)
        forgotPasswordButton?.addTarget(self, action: #selector(restorePassword), for: .touchUpInside)
        //constraints@tryToLoginButton
        forgotPasswordButton?.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton?.topAnchor.constraint(equalTo: errorLabel?.bottomAnchor ?? self.createAccountButton.bottomAnchor, constant: 10).isActive = true
        forgotPasswordButton?.leftAnchor.constraint(equalTo: errorLabel?.leftAnchor ?? self.tryToLoginButton.leftAnchor, constant: 0).isActive = true
        forgotPasswordButton?.heightAnchor.constraint(equalToConstant: 35).isActive = true
        forgotPasswordButton?.widthAnchor.constraint(equalToConstant: 160).isActive = true

        
    }
    func showAlert(_ trueOrNot: Bool) {
        var alert = UIAlertController()
        if trueOrNot {
            alert = UIAlertController(title: "Check your email", message: "there you can reset your pass", preferredStyle: .alert)
        } else {
            alert = UIAlertController(title: "Can't reset the password", message: "there you can reset your pass", preferredStyle: .alert)
        }
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)

        
    }
    // MARK: Button methods
    func animateButton(button: UIButton) {
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            button.transform = .init(scaleX: 1.25, y: 1.25)
        }) { (finished: Bool) -> Void in
            button.isHidden = false
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                button.transform = .identity
            })
        }
    }
    //MARK: Keyboard methods
    func setupKeyBoardNotification() {
        //Notification keyboardWillShow
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        //Notification UIKeyboardWillHide
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        print("keyboardWillShow ", Thread.current)
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: currentViewHeight + keyboardHeight)
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: currentViewHeight )
        }
    }
    //MARK: Button methods
    @objc func tryToLogin() {
        animateButton(button: tryToLoginButton)
        if checkPasswordTextFeild() {
            presenter.password = self.passwordTextField.text ?? ""
            continueToLogginedInViewController()
        } else {
            return
        }
    }
    @objc func tryToRegister() {
        animateButton(button: createAccountButton)
        if checkPasswordTextFeild() {
            presenter.password = self.passwordTextField.text ?? ""
            continueToRegistrationViewController()
        } else {
            return
        }
    }
    func checkPasswordTextFeild() -> Bool {
        guard let passwordString = self.passwordTextField.text else {
            showPasswordError()
            return false
        }
        if passwordString.count >= 6 {
            passwordTextField.resignFirstResponder()
            return true
        } else {
            showPasswordError()
            return false
        }
    }
    @objc func restorePassword() {
        presenter.restorePassword() { result in
            switch result {
            case .success(_):
                self.showAlert(true)
            case .failure(_):
                self.showAlert(false)
            }
            
        }
    }
    //MARK: NAVIGATION
    func continueToRegistrationViewController() {
        //change view vize to normal
        preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: currentViewHeight)
        //show next modal view
        let viewControllerToPresent = RegistrationViewController(rootViewContoroller: self, initialHeight: 200, presenter: self.presenter)
        presentBottomSheetInsideNavigationController(
            viewController: viewControllerToPresent,
            configuration:.init(cornerRadius: 15, pullBarConfiguration: .visible(.init(height: -5)), shadowConfiguration: .default))
    }
    func continueToLogginedInViewController() {
        presenter.tryToLogin { result in
            switch result {
            case .success(_):
                print("ok")
            case .failure(let error):
                print(error.localizedDescription)
                self.showLoginError()
            }
        }
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
    //textFieldDidEndEditing
    func textFieldDidEndEditing(_ textField: UITextField) {
        preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: currentViewHeight)
    }
    //textFieldShouldReturn
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.passwordTextField {
            textField.resignFirstResponder()
            tryToLogin()
        }
        return true
    }
}

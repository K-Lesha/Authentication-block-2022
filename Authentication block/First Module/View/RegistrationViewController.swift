//
//  RegistrationViewController.swift
//  Authentication block
//
//  Created by Алексей Коваленко on 13.10.2022.
//

import UIKit

protocol RegistrationViewProtocol: AnyObject {
    //MVP Protocol
    var rootViewContoroller: PasswordViewProtocol! {get set}
    var presenter: StartHerePresenterProtocol! {get set}
    init(rootViewContoroller: PasswordViewProtocol, initialHeight: CGFloat, presenter: StartHerePresenterProtocol)
    // View protocol
    var currentViewHeight: CGFloat! {get set}
    // Methods
//    func dismissAllRootViews()
}


class RegistrationViewController: UIViewController, RegistrationViewProtocol {
    //MARK: MVP protocol
    weak var rootViewContoroller: PasswordViewProtocol!
    weak var presenter: StartHerePresenterProtocol!
    //MARK: View protocol
    var currentViewHeight: CGFloat!
    //MARK: INIT
    required init(rootViewContoroller: PasswordViewProtocol, initialHeight: CGFloat, presenter: StartHerePresenterProtocol) {
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
    var registerLabel: UILabel!
    var emailTextfield: UITextField!
    var passwordTextfield: UITextField!
    var userNameTextfield: UITextField!
    var registerButton: UIButton!
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK: METHODS
    func setupViews() {
        //mark@view
        view.backgroundColor = .white
        
        //setup@registerLabel
        registerLabel = UILabel()
        view.addSubview(registerLabel)
        registerLabel.textColor = .black
        registerLabel.text = "ONE MORE STEP"
        registerLabel.font = Appearance.titlesFont
        //constraints@registerLabel
        registerLabel.translatesAutoresizingMaskIntoConstraints = false
        registerLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 3).isActive = true
        registerLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        registerLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        registerLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        //setup@emailTextfield
        emailTextfield = UITextField()
        view.addSubview(emailTextfield)
        emailTextfield.placeholder = "email"
        emailTextfield.text = presenter.email
        emailTextfield.font = Appearance.smallCursiveFont
        let bottomLineLogin = CALayer()
        bottomLineLogin.backgroundColor = UIColor.lightGray.cgColor
        emailTextfield.borderStyle = UITextField.BorderStyle.none
        emailTextfield.layer.addSublayer(bottomLineLogin)
        emailTextfield.delegate = self
        //constraints@emailTextfield
        emailTextfield.translatesAutoresizingMaskIntoConstraints = false
        emailTextfield.topAnchor.constraint(equalTo: registerLabel.bottomAnchor, constant: 10).isActive = true
        emailTextfield.widthAnchor.constraint(equalTo: registerLabel.widthAnchor).isActive = true
        let textfieldsHeighConstraint: CGFloat = 20
        emailTextfield.heightAnchor.constraint(equalToConstant: textfieldsHeighConstraint).isActive = true
        emailTextfield.leftAnchor.constraint(equalTo: registerLabel.leftAnchor, constant: 0).isActive = true
        bottomLineLogin.frame = CGRect(x: 0.0, y: textfieldsHeighConstraint, width: view.frame.width - 50, height: 1.0)
        
        //setup@passwordTextfield
        passwordTextfield = UITextField()
        view.addSubview(passwordTextfield)
        passwordTextfield.placeholder = "password"
        if presenter.password.count > 0 {
            passwordTextfield.text = self.presenter.password
        }
        passwordTextfield.isSecureTextEntry = true
        passwordTextfield.font = Appearance.smallCursiveFont
        passwordTextfield.borderStyle = UITextField.BorderStyle.none
        let bottomLinePassword = CALayer()
        bottomLinePassword.backgroundColor = UIColor.lightGray.cgColor
        passwordTextfield.layer.addSublayer(bottomLinePassword)
        passwordTextfield.delegate = self
        //constraints@passwordTextfield
        passwordTextfield.translatesAutoresizingMaskIntoConstraints = false
        passwordTextfield.topAnchor.constraint(equalTo: emailTextfield.bottomAnchor, constant: 10).isActive = true
        passwordTextfield.widthAnchor.constraint(equalTo: emailTextfield.widthAnchor).isActive = true
        passwordTextfield.heightAnchor.constraint(equalToConstant: textfieldsHeighConstraint).isActive = true
        passwordTextfield.leftAnchor.constraint(equalTo: emailTextfield.leftAnchor, constant: 0).isActive = true
        bottomLinePassword.frame = CGRect(x: 0.0, y: textfieldsHeighConstraint, width: view.frame.width - 50, height: 1.0)

        //setup@userNameTextfield
        userNameTextfield = UITextField()
        view.addSubview(userNameTextfield)
        userNameTextfield.placeholder = "username"
        userNameTextfield.font = Appearance.smallCursiveFont
        userNameTextfield.borderStyle = UITextField.BorderStyle.none
        let bottomLineLoginEmail = CALayer()
        bottomLineLoginEmail.backgroundColor = UIColor.lightGray.cgColor
        userNameTextfield.layer.addSublayer(bottomLineLoginEmail)
        userNameTextfield.delegate = self
        //constraints@userNameTextfield
        userNameTextfield.translatesAutoresizingMaskIntoConstraints = false
        userNameTextfield.topAnchor.constraint(equalTo: passwordTextfield.bottomAnchor, constant: 10).isActive = true
        userNameTextfield.widthAnchor.constraint(equalTo: passwordTextfield.widthAnchor).isActive = true
        userNameTextfield.heightAnchor.constraint(equalToConstant: textfieldsHeighConstraint).isActive = true
        userNameTextfield.leftAnchor.constraint(equalTo: passwordTextfield.leftAnchor, constant: 0).isActive = true
        bottomLineLoginEmail.frame = CGRect(x: 0.0, y: textfieldsHeighConstraint, width: view.frame.width - 50, height: 1.0)

        //setup@nextButton
        registerButton = UIButton()
        view.addSubview(registerButton)
        registerButton.setTitle("register", for: .normal)
        registerButton.titleLabel?.font = Appearance.buttomsFont
        registerButton.backgroundColor = .orange
        registerButton.layer.cornerRadius = 15
        registerButton.addTarget(self, action: #selector(tryToRegister), for: .touchUpInside)
        //constraints@nextButton
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.topAnchor.constraint(equalTo: userNameTextfield.bottomAnchor, constant: 5).isActive = true
        registerButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        registerButton.leftAnchor.constraint(equalTo: userNameTextfield.leftAnchor, constant: 0).isActive = true
        
    }


    @objc func tryToRegister() {
        emailTextfield.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
        userNameTextfield.resignFirstResponder()
        //Checking textfield
        if self.emailTextfield.text == nil || (self.emailTextfield.text?.count ?? 0) == 0 {
            emailTextfield.layer.sublayers?.first?.backgroundColor = UIColor.red.cgColor
            return
        }
        if self.passwordTextfield.text == nil || (self.passwordTextfield.text?.count ?? 0) == 0 {
            passwordTextfield.layer.sublayers?.first?.backgroundColor = UIColor.red.cgColor
            return
        }
        if self.userNameTextfield.text == nil || (self.userNameTextfield.text?.count ?? 0) == 0 {
            userNameTextfield.layer.sublayers?.first?.backgroundColor = UIColor.red.cgColor
            return
        }
        //turn view size back to normal
        preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: currentViewHeight)
        
        //TODO: CHECK: LOGIN SHOULD HAVE AT LEAST 5 SYMBOLS
        
        // sending to presenter all the parameters
        presenter.userName = self.userNameTextfield.text!
        presenter.password = self.passwordTextfield.text!
        presenter.email = self.emailTextfield.text!
        // try to registrer
        presenter.tryToRegister() { result in
            print("RegistrationViewController: tryToRegister()", Thread.current)
            
            switch result {
                //if success -> show next VC
            case .success(let userUID):
                print(userUID)
                print("RegistrationViewController: tryToRegister() case .success", Thread.current)
//                self.dismissAllRootViews()
            case.failure(let error):
                //if error —> error handeling
                print(error.localizedDescription)
                if error.localizedDescription == "1" {
                    // если ошибка, то показать соответсвующую ошибку: проверка на успешность регистрации файрбэйз
                } else if error.localizedDescription == "2" {
                    // если ошибка, то показать соответсвующую ошибку: проверка на успешность регистрации файрбэйз
                }
            }
        }
    }
    
//    func dismissAllRootViews() {
//        //dismiss RigistrationVC
//        self.dismiss(animated: true)
//        //dismiss PasswordVC
//        self.rootViewContoroller.dismissThisVC()
//        //dismiss SignInVC
//        self.rootViewContoroller.rootViewContoroller.dismissThisVC()
//        // dismiss StarHereVC
//        self.rootViewContoroller.rootViewContoroller.rootViewController.dismissThisVC()
//    }
    
    @objc func cansel() {
        // скрыть этот вью контроллер
    }
    //MARK: Deinit
    deinit {
        print("RegistrationViewController was deinited")
    }
}

//MARK: UITextFieldDelegate
extension RegistrationViewController: UITextFieldDelegate {
    //MARK: textFieldShouldBeginEditing
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: currentViewHeight + 160)
        return true
    }
    //MARK: textFieldDidEndEditing
    func textFieldDidEndEditing(_ textField: UITextField) {
        //loginTextField
        if textField == self.emailTextfield {
            preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: currentViewHeight + 160)
        }
        if self.emailTextfield.text != nil || (self.emailTextfield.text?.count ?? 0) > 0 {
            emailTextfield.layer.sublayers?.first?.backgroundColor = UIColor.lightGray.cgColor
        }
        // passwordTextfield
        if textField == self.passwordTextfield {
            preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: currentViewHeight + 160)
        }
        if self.passwordTextfield.text != nil || (self.passwordTextfield.text?.count ?? 0) > 0 {
            passwordTextfield.layer.sublayers?.first?.backgroundColor = UIColor.lightGray.cgColor
        }
        // emailTextfield
        if textField == self.userNameTextfield {
            preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: currentViewHeight + 160)
            userNameTextfield.resignFirstResponder()
        }
        if self.userNameTextfield.text != nil || (self.userNameTextfield.text?.count ?? 0) > 0 {
            userNameTextfield.layer.sublayers?.first?.backgroundColor = UIColor.lightGray.cgColor
        }
    }
    //MARK: textFieldShouldReturn
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextfield {
            passwordTextfield.becomeFirstResponder()
            preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: currentViewHeight + 160)
        }
        if textField == self.passwordTextfield {
            preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: currentViewHeight + 160)
            userNameTextfield.becomeFirstResponder()
        }
        if textField == self.userNameTextfield {
            tryToRegister()
        }
        return true
    }
}

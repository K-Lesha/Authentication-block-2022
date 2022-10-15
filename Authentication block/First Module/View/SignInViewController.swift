//
//  SignInViewController.swift
//  Authentication block
//
//  Created by Алексей Коваленко on 11.10.2022.
//

import UIKit
import BottomSheet

protocol SignInViewProtocol: AnyObject {
    //MVP Protocol
    var rootViewController: StartHereViewProtocol! {get set}
    var presenter: StartHerePresenterProtocol! {get set}
    init(rootViewController: StartHereViewProtocol, initialHeight: CGFloat, presenter: StartHerePresenterProtocol)
    // View protocol
    var currentViewHeight: CGFloat! {get set}
    var keyboardHeight: CGFloat! {get set}
    func dismissThisVC()
}

class SignInViewController: UIViewController, SignInViewProtocol {

    //MARK: MVP protocol
    weak var rootViewController: StartHereViewProtocol!
    weak var presenter: StartHerePresenterProtocol!

    //MARK: View protocol
    var currentViewHeight: CGFloat!
    var keyboardHeight: CGFloat! = 0
    
    //MARK: INIT
    required init(rootViewController: StartHereViewProtocol, initialHeight: CGFloat, presenter: StartHerePresenterProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.rootViewController = rootViewController
        self.presenter = presenter
        preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: initialHeight)
        currentViewHeight = initialHeight
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: OUTLETS
    var signInLabel: UILabel!
    var subSignInLabel: UILabel!
    var emailTextField: UITextField!
    var facebookLoginButton: UIButton!
    var appleIdLoginButton: UIButton!
    var legalsLabel: UILabel!
    var nextButton: UIButton!
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupKeyBoardNotification()
    }
    
    //MARK: METHODS
    //MARK: View methods
    private func setupViews() {
        //mark@view
        view.backgroundColor = .white

        //setup@signInLabel
        signInLabel = UILabel()
        view.addSubview(signInLabel)
        signInLabel.textColor = .black
        signInLabel.text = "SIGN IN / REGISTER"
        signInLabel.font = Appearance.titlesFont
        //constraints@signInLabel
        signInLabel.translatesAutoresizingMaskIntoConstraints = false
        signInLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 3).isActive = true
        signInLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        signInLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        signInLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        //setup@subSignInLabel
        subSignInLabel = UILabel()
        view.addSubview(subSignInLabel)
        subSignInLabel.textColor = .darkGray
        subSignInLabel.numberOfLines = 2
        subSignInLabel.text = """
                            We need to keep your login to verify your account
                            and keep your information secure
                            """
        subSignInLabel.font = Appearance.smallCursiveFont
        //constraints@subSignInLabel
        subSignInLabel.translatesAutoresizingMaskIntoConstraints = false
        subSignInLabel.topAnchor.constraint(equalTo: signInLabel.bottomAnchor, constant: 5).isActive = true
        subSignInLabel.widthAnchor.constraint(equalTo: signInLabel.widthAnchor).isActive = true
        subSignInLabel.leftAnchor.constraint(equalTo: signInLabel.leftAnchor, constant: 0).isActive = true
        subSignInLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //setup@loginTextfield
        emailTextField = UITextField()
        view.addSubview(emailTextField)
        emailTextField.placeholder = "email"
        let bottomLine = CALayer()
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        emailTextField.borderStyle = UITextField.BorderStyle.none
        emailTextField.font = Appearance.buttomsFont
        emailTextField.layer.addSublayer(bottomLine)
        emailTextField.delegate = self
        //constraints@loginTextfield
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.topAnchor.constraint(equalTo: subSignInLabel.bottomAnchor, constant: 10).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: signInLabel.widthAnchor).isActive = true
        let loginTextfieldHeighConstraint: CGFloat = 20
        emailTextField.heightAnchor.constraint(equalToConstant: loginTextfieldHeighConstraint).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: signInLabel.leftAnchor, constant: 0).isActive = true
        bottomLine.frame = CGRect(x: 0.0, y: loginTextfieldHeighConstraint, width: view.frame.width - 50, height: 1.0)

        //TODO: FACEBOOK & APPLE SIGN IN BUTTON
//        //setup@facebookLoginButton
//        facebookLoginButton = UIButton()
//        view.addSubview(facebookLoginButton)
//        facebookLoginButton.layer.cornerRadius = 15
//        facebookLoginButton.backgroundColor = .blue
//        facebookLoginButton.setTitle("Log in with Facebook", for: .normal)
//        //constraints@facebookLoginButton
//        facebookLoginButton.translatesAutoresizingMaskIntoConstraints = false
//        facebookLoginButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10).isActive = true
//        facebookLoginButton.leftAnchor.constraint(equalTo: signInLabel.leftAnchor).isActive = true
//        facebookLoginButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
//        facebookLoginButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
//
//        //setup@appleIdLoginButton
//        appleIdLoginButton = UIButton()
//        view.addSubview(appleIdLoginButton)
//        appleIdLoginButton.layer.cornerRadius = 15
//        appleIdLoginButton.backgroundColor = .black
//        appleIdLoginButton.setTitle("Log in with Apple", for: .normal)
//        //constraints@appleIdLoginButton
//        appleIdLoginButton.translatesAutoresizingMaskIntoConstraints = false
//        appleIdLoginButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10).isActive = true
//        appleIdLoginButton.leftAnchor.constraint(equalTo: facebookLoginButton.rightAnchor, constant: 10).isActive = true
//        appleIdLoginButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
//        appleIdLoginButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
        
        //setup@legalsLabel
        legalsLabel = UILabel()
        view.addSubview(legalsLabel)
        legalsLabel.textColor = .darkGray
        legalsLabel.numberOfLines = 0
        legalsLabel.text = "Continuing you accept our Terms of Use and Privacy Policy"
        legalsLabel.font = Appearance.smallCursiveFont
        //constraints@legalsLabel
        legalsLabel.translatesAutoresizingMaskIntoConstraints = false
        legalsLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 1).isActive = true
        legalsLabel.widthAnchor.constraint(equalTo: signInLabel.widthAnchor).isActive = true
        legalsLabel.heightAnchor.constraint(equalTo: subSignInLabel.heightAnchor).isActive = true
        legalsLabel.leftAnchor.constraint(equalTo: signInLabel.leftAnchor, constant: 0).isActive = true
        
        //setup@nextButton
        nextButton = UIButton()
        view.addSubview(nextButton)
        nextButton.setTitle("next", for: .normal)
        nextButton.backgroundColor = .orange
        nextButton.titleLabel?.font = Appearance.buttomsFont
        nextButton.isHidden = true
        nextButton.layer.cornerRadius = 15
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        //constraints@nextButton
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.topAnchor.constraint(equalTo: legalsLabel.bottomAnchor, constant: 5).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        nextButton.leftAnchor.constraint(equalTo: signInLabel.leftAnchor, constant: 0).isActive = true
    }
    func showError() {
        self.emailTextField.layer.sublayers?.first?.backgroundColor = UIColor.red.cgColor
        emailTextField.text = ""
        emailTextField.placeholder = "email should be correct"
    }
    //MARK: Button methods
    func animateButton(button: UIButton) {
        //button animation
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            button.transform = .init(scaleX: 1.25, y: 1.25)
        }) { (finished: Bool) -> Void in
            button.isHidden = false
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                button.transform = .identity
            })
        }
    }
    func setNextButtonToView() {
        //button animation
        nextButton.isHidden = false
        animateButton(button: self.nextButton)
    }
    @objc func nextButtonTapped() {
        animateButton(button: self.nextButton)
        checkUserDataAndContinue()
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
    //MARK: Other methods
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    func checkUserDataAndContinue() {
        guard let emailString = self.emailTextField.text else {
            showError()
            return
        }
        if emailString.count >= 5, self.isValidEmail(email: emailString) {
            emailTextField.resignFirstResponder()
            presenter.email = emailString
            countinueToPasswordViewController()
        } else {
            showError()
            return
        }
    }
    //MARK: NAVIGATION
        func countinueToPasswordViewController() {
        let viewControllerToPresent = PasswordViewController(rootViewContoroller: self, initialHeight: 200, presenter: self.presenter)
        presentBottomSheetInsideNavigationController(
            viewController: viewControllerToPresent,
            configuration:.init(cornerRadius: 15, pullBarConfiguration: .visible(.init(height: -5)), shadowConfiguration: .default))
    }
    //MARK: Deinit
    func dismissThisVC() {
        self.dismiss(animated: true)
    }
    deinit {
        print("SignInViewController was deinited")
    }
}

//MARK: UITextFieldDelegate
extension SignInViewController: UITextFieldDelegate {
    //textFieldShouldBeginEditing
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        setNextButtonToView()
        return true
    }
    //textFieldDidEndEditing
    func textFieldDidEndEditing(_ textField: UITextField) {
        preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: currentViewHeight)
        if self.emailTextField.text?.count == 0 || self.emailTextField.text == nil {
            self.nextButton.isHidden = true
        }
    }
    //textFieldShouldReturn
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            textField.resignFirstResponder()
            checkUserDataAndContinue()
        }
        return true
    }
}

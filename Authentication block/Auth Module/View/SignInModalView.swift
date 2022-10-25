//
//  SignInViewController.swift
//  Authentication block
//
//  Created by Алексей Коваленко on 11.10.2022.
//

import UIKit
import BottomSheet

protocol SignInViewProtocol: AnyObject {
    //VIPER protocol
    var presenter: AuthPresenterProtocol! {get set}
    init(initialHeight: CGFloat, presenter: AuthPresenterProtocol)
    // View propertis
    var currentViewHeight: CGFloat! {get set}
    var keyboardHeight: CGFloat! {get set}
}

class SignInModalViewController: UIViewController, SignInViewProtocol {

    //MARK: VIPER protocol
    weak internal var presenter: AuthPresenterProtocol!

    //MARK: View properties
    internal var currentViewHeight: CGFloat!
    internal var keyboardHeight: CGFloat! = 0
    
    //MARK: INIT
    required init(initialHeight: CGFloat, presenter: AuthPresenterProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
        preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: initialHeight)
        currentViewHeight = initialHeight
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: OUTLETS
    private var signInLabel: UILabel!
    private var subSignInLabel: UILabel!
    private var emailTextField: UITextField!
    private var facebookLoginButton: UIButton!
    private var appleIdLoginButton: UIButton!
    private var googleLoginButton: UIButton!
    private var legalsLabel: UILabel!
    private var nextButton: UIButton!
    
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
        emailTextField.autocorrectionType = .no
        emailTextField.delegate = self
        //constraints@loginTextfield
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.topAnchor.constraint(equalTo: subSignInLabel.bottomAnchor, constant: 10).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: signInLabel.widthAnchor).isActive = true
        let loginTextfieldHeighConstraint: CGFloat = 20
        emailTextField.heightAnchor.constraint(equalToConstant: loginTextfieldHeighConstraint).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: signInLabel.leftAnchor, constant: 0).isActive = true
        bottomLine.frame = CGRect(x: 0.0, y: loginTextfieldHeighConstraint, width: view.frame.width - 50, height: 1.0)
        
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
        nextButton.backgroundColor = #colorLiteral(red: 1, green: 0.5025838017, blue: 0, alpha: 0.5)
        nextButton.titleLabel?.font = Appearance.buttomsFont
        nextButton.layer.cornerRadius = 15
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        //constraints@nextButton
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.topAnchor.constraint(equalTo: legalsLabel.bottomAnchor, constant: 5).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        nextButton.leftAnchor.constraint(equalTo: signInLabel.leftAnchor, constant: 0).isActive = true
        
        //setup@facebookLoginButton
        facebookLoginButton = UIButton()
//        facebookLoginButton = FBLoginButton()
        view.addSubview(facebookLoginButton)
        facebookLoginButton.layer.cornerRadius = 15
        facebookLoginButton.setImage(Appearance.facebookLogo, for: .normal)
        facebookLoginButton.addTarget(self, action: #selector(facebookButtonTapped), for: .touchUpInside)
        //constraints@facebookLoginButton
        facebookLoginButton.translatesAutoresizingMaskIntoConstraints = false
        facebookLoginButton.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor, constant: 0).isActive = true
        facebookLoginButton.leftAnchor.constraint(equalTo: nextButton.rightAnchor, constant: 10).isActive = true
        facebookLoginButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        facebookLoginButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        //setup@googleLoginButton
        googleLoginButton = UIButton()
        view.addSubview(googleLoginButton)
        googleLoginButton.setImage(Appearance.googleLogo, for: .normal)
        googleLoginButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
        //constraints@googleLoginButton
        googleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        googleLoginButton.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor, constant: 0).isActive = true
        googleLoginButton.leftAnchor.constraint(equalTo: facebookLoginButton.rightAnchor, constant: 5).isActive = true
        googleLoginButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        googleLoginButton.heightAnchor.constraint(equalToConstant: 30).isActive = true


// TODO: реализовать кнопку https://www.youtube.com/watch?v=MY5xLrsnUVo
        
//        //setup@appleIdLoginButton
//        appleIdLoginButton = UIButton()
//        view.addSubview(appleIdLoginButton)
//        appleIdLoginButton.layer.cornerRadius = 15
//        appleIdLoginButton.setImage(Appearance.appleLogo, for: .normal)
//        //constraints@appleIdLoginButton
//        appleIdLoginButton.translatesAutoresizingMaskIntoConstraints = false
//        appleIdLoginButton.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor, constant: 0).isActive = true
//        appleIdLoginButton.leftAnchor.constraint(equalTo: facebookLoginButton.rightAnchor, constant: 5).isActive = true
//        appleIdLoginButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        appleIdLoginButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    private func showError() {
        self.emailTextField.layer.sublayers?.first?.backgroundColor = UIColor.red.cgColor
        emailTextField.text = ""
        emailTextField.placeholder = "email should be correct"
    }
    private func animateButton(button: UIButton) {
        //button animation
        if button == self.nextButton {
            nextButton.backgroundColor = .orange
        }
        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            button.transform = .init(scaleX: 1.25, y: 1.25)
        }) { (finished: Bool) -> Void in
            button.isHidden = false
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                button.transform = .identity
            })
        }
    }
    //MARK: Button methods
    @objc private func nextButtonTapped() {
        animateButton(button: self.nextButton)
        checkUserDataAndContinue()
    }
    @objc private func facebookButtonTapped() {
        presenter.tryToLoginWithFacebook(viewController: self) { result in
            switch result {
            case .success(_):
                print("facebook signIn succesfull")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    @objc func googleButtonTapped() {
        presenter.tryToLoginWithGoogle(viewController: self) { result in
            switch result {
            case .success(_):
                print("google signIn succesfull")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    //MARK: Keyboard methods
    private func setupKeyBoardNotification() {
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
    @objc private func keyboardWillShow(_ notification: Notification) {
        print("keyboardWillShow ", Thread.current)
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: currentViewHeight + keyboardHeight)
        }
    }
    @objc private func keyboardWillHide(_ notification: Notification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: currentViewHeight )
        }
    }
    //MARK: Other methods
    private func checkUserDataAndContinue() {
        guard let emailString = self.emailTextField.text else {
            showError()
            return
        }
        if emailString.count >= 5, self.isValidEmail(email: emailString) {
            emailTextField.resignFirstResponder()
            presenter.email = emailString
            let viewControllerToPresent = PasswordModalViewController(initialHeight: 200, presenter: self.presenter)
            presentBottomSheetInsideNavigationController(
                viewController: viewControllerToPresent,
                configuration:.init(cornerRadius: 15, pullBarConfiguration: .visible(.init(height: -5)), shadowConfiguration: .default))
        } else {
            showError()
            return
        }
    }
    private func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    //MARK: Deinit
    deinit {
        print("SignInModalViewController was deinited")
    }
}

//MARK: UITextFieldDelegate
extension SignInModalViewController: UITextFieldDelegate {
    //textFieldShouldBeginEditing
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        animateButton(button: self.nextButton)
        return true
    }
    //textFieldDidEndEditing
    func textFieldDidEndEditing(_ textField: UITextField) {
        preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: currentViewHeight)
        if self.emailTextField.text?.count == 0 || self.emailTextField.text == nil {
            nextButton.backgroundColor = #colorLiteral(red: 1, green: 0.5025838017, blue: 0, alpha: 0.5)
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

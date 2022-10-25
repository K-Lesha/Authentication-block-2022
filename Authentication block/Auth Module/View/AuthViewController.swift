//
//  ViewController.swift
//  Authentication block
//
//  Created by Алексей Коваленко on 11.10.2022.
//

import UIKit

// MARK: Protocol
protocol AuthViewProtocol: AnyObject {
    //VIPER protocol
    var presenter: AuthPresenterProtocol! {get set}
}

//MARK: View
class AuthViewController: UIViewController, AuthViewProtocol {
    
    //MARK: VIPER protocol
    internal var presenter: AuthPresenterProtocol!
    
    //MARK: OUTLETS
    private var backgroundImageView: UIImageView!
    private var signInButton: UIButton!
    private var textLabel: UILabel!
    private var errorLabel: UILabel? = nil
    private var errorButton: UIButton? = nil
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        checkInternetConnectionAndSetupViews()
        
    }
    //MARK: METHODS
    //MARK: View methods
    private func checkInternetConnectionAndSetupViews() {
        if presenter.checkInternetConnection() {
            setupViews()
        } else {
            setupErrorViews()
        }
    }
    private func setupViews() {
        self.view.backgroundColor = .black
        // setup@backgroundImage
        self.backgroundImageView = UIImageView(frame: self.view.frame)
        let imageWidth = self.view.frame.width, imageHeight = self.view.frame.height
        // Download image and handle the result
        DispatchQueue.global().async {
            self.presenter.setBackgroundImage(width: imageWidth, height: imageHeight) { result in
                switch result {
                case .success(let imageData):
                    self.handleBackgroundImage(imageData, nil)
                case .failure(_):
                    print("image wasn't downloaded")
                }
            }
        }
        AuthenticationSemaphore.shared.wait()
        self.view.addSubview(self.backgroundImageView)
        //Other interface elements are waiting for the background image to load
        // setup@signInButton
        self.signInButton = UIButton()
        self.view.addSubview(signInButton)
        self.signInButton.layer.cornerRadius = 15
        self.signInButton.backgroundColor = .orange
        self.signInButton.isHidden = true
        self.signInButton.setTitle("SIGN IN / REGISTER", for: .normal)
        self.signInButton.titleLabel?.font = Appearance.buttomsFont
        self.signInButton.titleLabel?.textAlignment = .center
        self.signInButton.titleLabel?.textColor = .white
        self.signInButton.addTarget(self, action: #selector(self.signInButtonPushed), for: .touchUpInside)
        animateButton(button: signInButton)
        // constraints@signInButton
        self.signInButton.translatesAutoresizingMaskIntoConstraints = false
        self.signInButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        self.signInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.signInButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.signInButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        
        // setup@textLabel
        self.textLabel = UILabel()
        self.view.addSubview(self.textLabel)
        self.textLabel.numberOfLines = 2
        self.textLabel.text = """
                            AUTHENTICATION
                            IS EASY
                            """
        self.textLabel.textColor = .white
        self.textLabel.font = Appearance.titlesFont
        self.textLabel.textAlignment = .center
        // constraints@textLabel
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel.bottomAnchor.constraint(equalTo: self.signInButton.bottomAnchor, constant: -10).isActive = true
        self.textLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.textLabel.heightAnchor.constraint(equalTo: self.signInButton.heightAnchor, multiplier: 6).isActive = true
        self.textLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true

    }
    private func handleBackgroundImage(_ imageData: Data?, _ error: NetworkError?) {
        DispatchQueue.main.async() {
            guard let imageData, let image = UIImage(data: imageData) else {
                self.backgroundImageView.backgroundColor = .darkGray
                return
            }
            self.backgroundImageView.image = image
        }
    }
    private func setupErrorViews() {
        DispatchQueue.main.async() {
            // setup@errorLabel
            self.errorLabel = UILabel()
            self.view.addSubview(self.errorLabel ?? UILabel())
            self.errorLabel?.textColor = .lightGray
            self.errorLabel?.font = Appearance.titlesFont
            self.errorLabel?.numberOfLines = 0
            self.errorLabel?.text = "Check your  connection and push the"
            self.errorLabel?.textAlignment = .center
            // constraints@errorLabel
            self.errorLabel?.translatesAutoresizingMaskIntoConstraints = false
            self.errorLabel?.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            self.errorLabel?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.errorLabel?.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -10).isActive = true
            self.errorLabel?.heightAnchor.constraint(equalToConstant: 160).isActive = true
            
            //setup@errorButton
            self.errorButton = UIButton()
            self.view.addSubview(self.errorButton ?? UIButton())
            self.animateButton(button: self.errorButton ?? UIButton())
            self.errorButton?.setTitle("button", for: .normal)
            self.errorButton?.setTitleColor(.black, for: .normal)
            self.errorButton?.backgroundColor = .lightGray
            self.errorButton?.layer.cornerRadius = 15
            self.errorButton?.addTarget(self, action: #selector(self.errorButtonPushed), for: .touchUpInside)
            //constraints@errorButton
            self.errorButton?.translatesAutoresizingMaskIntoConstraints = false
            self.errorButton?.topAnchor.constraint(equalTo: self.errorLabel?.bottomAnchor ?? self.view.centerYAnchor, constant: 5).isActive = true
            self.errorButton?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.errorButton?.heightAnchor.constraint(equalToConstant: 30).isActive = true
            self.errorButton?.widthAnchor.constraint(equalToConstant: 130).isActive = true
        }
    }
    private func animateButton(button: UIButton) {
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

    //MARK: Button methods
    @objc private func errorButtonPushed() {
        animateButton(button: errorButton ?? UIButton())
        errorButton?.removeFromSuperview()
        errorButton = nil
        errorLabel?.removeFromSuperview()
        errorLabel = nil
        self.checkInternetConnectionAndSetupViews()
    }
    @objc private func signInButtonPushed() {
        animateButton(button: signInButton)
        let viewControllerToPresent = SignInModalViewController(initialHeight: 200, presenter: self.presenter)
        presentBottomSheetInsideNavigationController(
            viewController: viewControllerToPresent,
            configuration:.init(cornerRadius: 15, pullBarConfiguration: .visible(.init(height: -5)), shadowConfiguration: .default))
    }
        
    //MARK: Deinit
    deinit {
        print("AuthViewController was deinited")
    }
}





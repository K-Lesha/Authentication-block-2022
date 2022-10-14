//
//  ViewController.swift
//  Authentication block
//
//  Created by Алексей Коваленко on 11.10.2022.
//

import UIKit

// MARK: Protocol
protocol StartHereViewProtocol: AnyObject {
    //MVP protocol
    var presenter: StartHerePresenterProtocol! {get set}
    //View protocol
    
    //NAVIGATION
    func signInButtonPushed()
    func dismissThisVC()
}

//MARK: View
class StartHereViewController: UIViewController, StartHereViewProtocol {
    
    //MARK: MVP protocol
    var presenter: StartHerePresenterProtocol!
    
    //MARK: OUTLETS
    var backgroundImageView: UIImageView!
    var signInButton: UIButton!
    var buttonLabel: UILabel!
    var textLabel: UILabel!
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK: METHODS
    func setupViews() {
        // setup@backgroundImage
        self.backgroundImageView = UIImageView(frame: self.view.frame)
        let imageWidth = self.view.frame.width, imageHeight = self.view.frame.height
        // Download image and handle result
        DispatchQueue.global().async {
            self.presenter.setBackgroundImage(width: imageWidth, height: imageHeight) { result in
                switch result {
                case .success(let imageData):
                    self.handleBackgroundImage(imageData, nil)
                case .failure(let error):
                    print(error)
                    self.handleBackgroundImage(nil, error)
                }
            }

        }
        self.view.addSubview(self.backgroundImageView)
        AuthenticationSemaphore.shared.wait()
        //Other interface elements are waiting for the background image to load
        // setup@signInButton
        self.signInButton = UIButton()
        self.view.addSubview(self.signInButton)
        self.signInButton.layer.cornerRadius = 15
        self.signInButton.backgroundColor = .orange
        // constraints@signInButton
        self.signInButton.translatesAutoresizingMaskIntoConstraints = false
        self.signInButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        self.signInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.signInButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.signInButton.addTarget(self, action: #selector(self.signInButtonPushed), for: .touchUpInside)
        // setup@buttonLabel
        self.buttonLabel = UILabel()
        self.signInButton.addSubview(self.buttonLabel)
        self.buttonLabel.text = "SIGN IN / REGISTER"
        self.buttonLabel.textColor = .white
        self.buttonLabel.font = Appearance.buttomsFont
        self.buttonLabel.textAlignment = .center
        // constraints@buttonLabel
        self.buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        self.buttonLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 180).isActive = true
        self.buttonLabel.centerXAnchor.constraint(equalTo: self.signInButton.centerXAnchor).isActive = true
        self.buttonLabel.centerYAnchor.constraint(equalTo: self.signInButton.centerYAnchor).isActive = true
        self.buttonLabel.heightAnchor.constraint(equalTo: self.signInButton.heightAnchor, constant: -4).isActive = true
        self.signInButton.widthAnchor.constraint(equalTo: self.buttonLabel.widthAnchor, constant: 8).isActive = true
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
        self.textLabel.bottomAnchor.constraint(equalTo: self.signInButton.bottomAnchor, constant: -20).isActive = true
        self.textLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
        self.textLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.textLabel.centerYAnchor.constraint(equalTo: self.signInButton.centerYAnchor).isActive = true
        self.textLabel.heightAnchor.constraint(equalTo: self.signInButton.heightAnchor, multiplier: 6).isActive = true
        
    }
    func handleBackgroundImage(_ imageData: Data?, _ error: NetworkError?) {
        DispatchQueue.main.async() {
            guard let imageData, let image = UIImage(data: imageData) else {
                self.backgroundImageView.backgroundColor = .darkGray
                return
            }
            self.backgroundImageView.image = image
        }
    }
    
    //MARK: NAVIGATION
    @objc func signInButtonPushed() {
        let viewControllerToPresent = SignInViewController(rootViewController: self, initialHeight: 245, presenter: self.presenter)
        presentBottomSheetInsideNavigationController(
            viewController: viewControllerToPresent,
            configuration:.init(cornerRadius: 15, pullBarConfiguration: .visible(.init(height: -5)), shadowConfiguration: .default))
    }
    
    //MARK: Deinit
    func dismissThisVC() {
        self.dismiss(animated: true)
    }
    deinit {
        print("StartHereViewController was deinited")
    }
}





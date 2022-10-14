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
    var textLabel: UILabel!
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK: METHODS
    //MARK: View methods
    func setupViews() {
        // setup@backgroundImage
        self.backgroundImageView = UIImageView(frame: self.view.frame)
        let imageWidth = self.view.frame.width, imageHeight = self.view.frame.height
        // Download image and handle result
        var flag = false
        DispatchQueue.global().async {
            self.presenter.setBackgroundImage(width: imageWidth, height: imageHeight) { result in
                switch result {
                case .success(let imageData):
                    self.handleBackgroundImage(imageData, nil)
                case .failure(_):
                    self.handleBackgroundImageWithError()
                    return
                }
            }
        }
        self.view.addSubview(self.backgroundImageView)
        AuthenticationSemaphore.shared.wait()
        //Other interface elements are waiting for the background image to load
        // setup@signInButton
        self.signInButton = UIButton()
        self.signInButton.layer.cornerRadius = 15
        self.signInButton.backgroundColor = .orange
        self.signInButton.isHidden = true
        self.signInButton.setTitle("SIGN IN / REGISTER", for: .normal)
        self.signInButton.titleLabel?.font = Appearance.buttomsFont
        self.signInButton.titleLabel?.textAlignment = .center
        self.signInButton.titleLabel?.textColor = .white
        self.signInButton.addTarget(self, action: #selector(self.signInButtonPushed), for: .touchUpInside)
        setSignInButton()
        // constraints@signInButton
        self.signInButton.translatesAutoresizingMaskIntoConstraints = false
        self.signInButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        self.signInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.signInButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.signInButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        
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
    func handleBackgroundImage(_ imageData: Data?, _ error: NetworkError?) {
        DispatchQueue.main.async() {
            guard let imageData, let image = UIImage(data: imageData) else {
                self.backgroundImageView.backgroundColor = .darkGray
                return
            }
            self.backgroundImageView.image = image
        }
    }
    func handleBackgroundImageWithError() {
        DispatchQueue.main.async() {
            self.backgroundImageView = UIImageView(frame: self.view.frame)
            self.view.addSubview(self.backgroundImageView)
            self.backgroundImageView.backgroundColor = .darkGray
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
            self.backgroundImageView.addSubview(label)
            label.center = self.view.center
            label.textColor = .white
            label.font = Appearance.titlesFont
            label.text = "Check your Inthernet connection"
        }
    }
    func setSignInButton() {
        //button animation
        self.view.addSubview(signInButton)
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.signInButton.transform = .init(scaleX: 1.25, y: 1.25)
        }) { (finished: Bool) -> Void in
            self.signInButton.isHidden = false
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.signInButton.transform = .identity
            })
        }
    }
    
    //MARK: NAVIGATION
    @objc func signInButtonPushed() {
        setSignInButton()
        let viewControllerToPresent = SignInViewController(rootViewController: self, initialHeight: 200, presenter: self.presenter)
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





//
//  LoggedInViewController.swift
//  Authentication block
//
//  Created by Алексей Коваленко on 13.10.2022.
//

import UIKit

// MARK: Protocol
protocol LoggedInViewControllerProtocol: AnyObject {
    //MVP protocol
    var presenter: LoggedInPresenterProtocol! {get set}
    //View protocol
    var userNameLabel: UILabel! {get set}
    func setNewValueForUserNamelabel(newUserName: String)
    //NAVIGATION
    func logOutButtonPushed()
    func deleteAccountButtonPushed()
}
//MARK: View
class LoggedInViewController: UIViewController, LoggedInViewControllerProtocol {
    //MARK: MVP protocol
    var presenter: LoggedInPresenterProtocol!
    
    //MARK: OUTLETS
    var deleteAccountBarButton: UIBarButtonItem!
    var logoutButton: UIBarButtonItem!
    var userNameLabel: UILabel!
    var additionalInfoLabel: UILabel!
    var deletingInProgressView: UIView? = nil
    var activityIndicator: UIActivityIndicatorView? = nil
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        setupViews()
    }
    
    //MARK: METHODS
    //MARK: View methods
    func setupViews() {
        //setup@deleteAccountButton
        deleteAccountBarButton = UIBarButtonItem(title: "Delete account", style: .plain, target: self, action: #selector(deleteAccountButtonPushed))
        deleteAccountBarButton.setTitleTextAttributes([
            NSAttributedString.Key.font: Appearance.buttomsFont,
            NSAttributedString.Key.foregroundColor: UIColor.white],
            for: .normal)

        self.navigationItem.leftBarButtonItem = deleteAccountBarButton
        
        //setup@logoutButton
        logoutButton = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logOutButtonPushed))
        self.navigationItem.rightBarButtonItem = logoutButton
        logoutButton.setTitleTextAttributes([
            NSAttributedString.Key.font: Appearance.buttomsFont,
            NSAttributedString.Key.foregroundColor: UIColor.white],
            for: .normal)
        
        //setup@userNameLabel
        userNameLabel = UILabel()
        if let userName = self.presenter.userName {
            userNameLabel.text = "Hi " + userName
        } else {
            userNameLabel.text = "Hi"
        }
        self.view.addSubview(self.userNameLabel)
        self.userNameLabel.numberOfLines = 0
        self.userNameLabel.textColor = .white
        self.userNameLabel.font = Appearance.titlesFont
        self.userNameLabel.textAlignment = .center
        // constraints@userNameLabel
        self.userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.userNameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.userNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        self.userNameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    func setNewValueForUserNamelabel(newUserName: String) {
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.userNameLabel.transform = .init(scaleX: 1.25, y: 1.25)
        }) { (finished: Bool) -> Void in
            self.userNameLabel.text = "Hi, " + newUserName
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                self.userNameLabel.transform = .identity
            })
        }
    }
    func deletingInProgress() {
        deletingInProgressView = UIView()
        deletingInProgressView?.frame = view.frame
        deletingInProgressView?.backgroundColor = .gray
        deletingInProgressView?.layer.opacity = 0.3
        view.addSubview(deletingInProgressView ?? UIView())
        activityIndicator = UIActivityIndicatorView()
        activityIndicator?.center = self.view.center
        deletingInProgressView?.addSubview(activityIndicator ?? UIActivityIndicatorView())
        activityIndicator?.color = .white
        activityIndicator?.startAnimating()
    }

    //MARK: Button methods
    @objc func logOutButtonPushed() {
        presenter.logOut()
    }
    @objc func deleteAccountButtonPushed() {
        //view reaction
        deletingInProgress()
        let alert = UIAlertController(title: "Enter your password to confirm", message: "", preferredStyle: .alert)
        alert.addTextField()
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            let password = alert.textFields?.first?.text ?? ""
            self.deleteUserWithPassword(password: password)
        }
        let canselAction = UIAlertAction(title: "Cansel", style: .cancel) { canselAction in
            self.deletingInProgressView?.removeFromSuperview()
            self.activityIndicator?.removeFromSuperview()
            self.deletingInProgressView = nil
            self.activityIndicator = nil
        }
        alert.addAction(canselAction)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    func deleteUserWithPassword(password: String) {
        presenter.reauthenticateAndDeleteUser(password: password)
    }
    //MARK: Deinit
    deinit {
        print("LoggedInViewController was deinited")
    }
}

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
    //NAVIGATION
    func signOutButtonPushed()
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
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        setupViews()
    }
    
    //MARK: METHODS
    func setupViews() {

        //setup@deleteAccountButton
        deleteAccountBarButton = UIBarButtonItem(title: "Delete account", style: .plain, target: self, action: #selector(deleteAccountButtonPushed))
        deleteAccountBarButton.setTitleTextAttributes([
            NSAttributedString.Key.font: Appearance.buttomsFont,
            NSAttributedString.Key.foregroundColor: UIColor.white],
            for: .normal)

        self.navigationItem.leftBarButtonItem = deleteAccountBarButton
        
        //setup@logoutButton
        logoutButton = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(signOutButtonPushed))
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
    //MARK: METHODS
    @objc func deleteAccountButtonPushed() {
        //TODO: if logged in not in this session -> enter pass to delete account
        //This operation is sensitive and requires recent authentication. Log in again before retrying this request.
        presenter.deleteCurrentAccount() { result in
            switch result {
            case .success(_):
                print("deleting succesfull")
                //TODO: ALERT THAT ITS OK
            case .failure(let error):
                print(error.localizedDescription)
                //TODO: Handle error
            }
        }
    }
    @objc func signOutButtonPushed() {
        presenter.logOut()
    }

    //MARK: Deinit
    deinit {
        print("LoggedInViewController was deinited")
    }
}

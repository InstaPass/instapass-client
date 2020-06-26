//
//  LoginViewController.swift
//  InstaPass
//
//  Created by 法好 on 2020/4/24.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import UIKit
import SPAlert

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var passWordTextField: UITextField!
    
    @IBOutlet weak var loginImageView: UIImageView!
    
    var parentVC: UserTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        userNameTextField.delegate = self
        passWordTextField.delegate = self
        
        loginImageView.isUserInteractionEnabled = true
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(loginButtonTapped))
        loginImageView.addGestureRecognizer(singleTap)
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        textField.placeholder = nil
//    }
//    
//    let placeHolderString = ["用户名", "密码"]
//    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        textField.placeholder = placeHolderString[textField.tag]
//    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTextField {
            passWordTextField.becomeFirstResponder()
        } else if textField == passWordTextField {
            passWordTextField.resignFirstResponder()
            loginButtonTapped()
        }
        return true
    }

    @objc func loginButtonTapped() {
        displayActivityIndicatorAlert(title: "登录中…", message: nil, handler: {
            LoginHelper.login(username: self.userNameTextField.text ?? "",
                              password: self.passWordTextField.text ?? "",
                              handler: { resp in
                                  if resp == .ok {
                                      NSLog("ok")
                                      DispatchQueue.main.async {
                                          self.dismissActivityIndicatorAlert(handler: {
                                              SPAlert.present(title: "登录成功", image: UIImage(systemName: "checkmark.seal.fill")!)
                                           
                                            self.navigationController?.popViewController(animated: true)
                                            self.parentVC?.reloadData(success: {
                                                self.parentVC?.renderData()
                                            }, failure: {})
                                          })
                                      }
                                  } else {
                                      NSLog("bad response")
                                      DispatchQueue.main.async {
                                          self.dismissActivityIndicatorAlert(handler: {
                                              SPAlert.present(title: "登录失败", image: UIImage(systemName: "multiply")!)
                                          })
                                      }
                                    self.parentVC?.renderData()
                                  }
            })
        })
    }

    @IBAction func closeButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }

    var activityIndicatorAlert: UIAlertController?

    func displayActivityIndicatorAlert(title: String, message: String?, handler: (() -> Void)?) {
        activityIndicatorAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        activityIndicatorAlert!.addActivityIndicator()
        present(activityIndicatorAlert!, animated: true, completion: handler)
    }

    func dismissActivityIndicatorAlert(handler: (() -> Void)?) {
        activityIndicatorAlert?.dismiss(animated: true, completion: handler)
        activityIndicatorAlert = nil
    }
}

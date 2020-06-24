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
    @IBOutlet var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        userNameTextField.delegate = self
        passWordTextField.delegate = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTextField {
            passWordTextField.becomeFirstResponder()
        } else if textField == passWordTextField {
            passWordTextField.resignFirstResponder()
            loginButtonTapped(loginButton)
        }
        return true
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        displayActivityIndicatorAlert(title: "正在登录", message: "请稍候…", handler: {
            LoginHelper.login(username: self.userNameTextField.text ?? "",
                              password: self.passWordTextField.text ?? "",
                              handler: { resp in
                                  if resp == .ok {
                                      NSLog("ok")
                                      DispatchQueue.main.async {
                                          self.dismissActivityIndicatorAlert(handler: {
                                              SPAlert.present(title: "登录成功", image: UIImage(systemName: "checkmark.seal.fill")!)
                                              self.dismiss(animated: true)
                                          })
                                      }
                                  } else {
                                      NSLog("bad response")
                                      DispatchQueue.main.async {
                                          self.dismissActivityIndicatorAlert(handler: {
                                              SPAlert.present(title: "登录失败", image: UIImage(systemName: "multiply")!)
                                          })
                                      }
                                  }
            })
        })
    }

    @IBAction func closeButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    var activityIndicatorAlert: UIAlertController?

    func displayActivityIndicatorAlert(title: String, message: String, handler: (() -> Void)?) {
        activityIndicatorAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        activityIndicatorAlert!.addActivityIndicator()
        present(activityIndicatorAlert!, animated: true, completion: handler)
    }

    func dismissActivityIndicatorAlert(handler: (() -> Void)?) {
        activityIndicatorAlert?.dismiss(animated: true, completion: handler)
        activityIndicatorAlert = nil
    }
}

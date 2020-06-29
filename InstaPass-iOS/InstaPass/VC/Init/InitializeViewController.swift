//
//  RegisterViewController.swift
//  InstaPass
//
//  Created by 法好 on 2020/6/27.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import UIKit
import Photos
import SPAlert
import AssetsLibrary

//import ImagePicker

class InitializeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    override func viewDidLoad() {

        requireRegister.isUserInteractionEnabled = true
        let registerSingleTap = UITapGestureRecognizer(target: self, action: #selector(registerButtonTapped))
        requireRegister.addGestureRecognizer(registerSingleTap)
        
        requireRegister.accessibilityLabel = "以新身份注册"
        requireRegister.accessibilityRespondsToUserInteraction = true
        
        retryLoading.isUserInteractionEnabled = true
        let retrySingleTap = UITapGestureRecognizer(target: self, action: #selector(retryButtonTapped))
        retryLoading.addGestureRecognizer(retrySingleTap)
        
        retryLoading.accessibilityLabel = "再试一次"
        retryLoading.accessibilityRespondsToUserInteraction = true
        
        loginButton.isUserInteractionEnabled = true
        let loginSingleTap = UITapGestureRecognizer(target: self, action: #selector(loginButtonTapped))
        loginButton.addGestureRecognizer(loginSingleTap)
        
        loginButton.accessibilityLabel = "登录"
        loginButton.accessibilityRespondsToUserInteraction = true
        
        tryLoading()

        super.viewDidLoad()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let resultImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        picker.dismiss(animated: true, completion: {
            if resultImage != nil {
                self.sendRegisterRequest(image: resultImage!)
            } else {
                SPAlert.present(message: "未能取得图片。", haptic: .error)
            }
        })
    }
    
    func setLoadingLabel() {
        majorTitleLabel.text = "正在同服务器取得联系"
        minorTitleLabel.text = "请稍等片刻"
        loadingIndicator.isHidden = false
        requireRegister.isHidden = true
        loginButton.isHidden = true
        retryLoading.isHidden = true
    }
    
    func setRegisteringLabel() {
        majorTitleLabel.text = "正在确认您的身份"
        minorTitleLabel.text = "请稍等片刻"
        loadingIndicator.isHidden = false
        requireRegister.isHidden = true
        loginButton.isHidden = true
        retryLoading.isHidden = true
    }
    
    func setRequireRegisterLabel() {
        majorTitleLabel.text = "无记录"
        minorTitleLabel.text = "请登入 InstaPass 账户"
        loadingIndicator.isHidden = true
        loginButton.isHidden = false
        requireRegister.isHidden = false
        retryLoading.isHidden = true
    }
    
    func setRetryLabel() {
        majorTitleLabel.text = "联络失败"
        minorTitleLabel.text = "未能同服务器取得联系"
        loadingIndicator.isHidden = true
        requireRegister.isHidden = false
        loginButton.isHidden = false
        if UserPrefInitializer.userName != "" && UserPrefInitializer.userId != "" {
            retryLoading.isHidden = false
        } else {
            retryLoading.isHidden = true
        }
    }

    func tryLoading() {
        // Do any additional setup after loading the view.
        if UserPrefInitializer.userName != "" && UserPrefInitializer.userId != "" {
            setLoadingLabel()
            LoginHelper.login(realname: UserPrefInitializer.userName,
                              userId: UserPrefInitializer.userId,
                              handler: { resp in
                                if resp == .ok {
                                    self.completeInit()
                                } else {
                                    self.setRetryLabel()
                                }
                              })
        } else {
            setRequireRegisterLabel()
        }
    }
    
    @IBOutlet weak var majorTitleLabel: UILabel!
    @IBOutlet weak var minorTitleLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var requireRegister: UIStackView!
    @IBOutlet weak var retryLoading: UIStackView!
    @IBOutlet weak var loginButton: UIStackView!
    
    @objc func registerButtonTapped() {
        
        let alertController = UIAlertController(title: "提供身份证明",
                                                message: "请提供一张由政府颁发的有效身份证件的正面照片。",
                                                preferredStyle: .actionSheet)
        
        alertController.view.setTintColor()
        
        let cameraAction = UIAlertAction(title: "拍照",
                                                  style: .default,
                                                  handler: { _ in
                                                    self.loadImage(type: .camera)
                                                  })
        
        let albumAction = UIAlertAction(title: "从图库选择",
                                                  style: .default,
                                                  handler: { _ in
                                                    self.loadImage(type: .photoLibrary)
                                                  })
        
        let cancelAction = UIAlertAction(title: "取消",
                                         style: .cancel,
                                         handler: { _ in
                                            self.tryLoading()
                                         })
        
        alertController.addAction(cameraAction)
        alertController.addAction(albumAction)
        alertController.addAction(cancelAction)
        
        alertController.popoverPresentationController?.sourceView = requireRegister
        alertController.popoverPresentationController?.sourceRect = requireRegister.bounds
        
        present(alertController, animated: true, completion: nil)
    }
    
    func loadImage(type: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(type)
        {
            let photosPicker = UIImagePickerController()
            photosPicker.sourceType = type
            photosPicker.delegate = self
            photosPicker.allowsEditing = true
            photosPicker.navigationBar.barTintColor = globalTintColor
            present(photosPicker, animated: true, completion: nil)
        }
        else
        {
            SPAlert.present(message: "未获得访问授权。", haptic: .error)
        }
    }
    
    func sendRegisterRequest(image: UIImage) {
        setLoadingLabel()
        let jpegData = image.compressImageTo(maxMB: 1)
        if jpegData == nil {
            SPAlert.present(message: "压缩图片失败。请再试一次。", haptic: .error)
            return
        }
        
        let parameter = [
            "id_card_snapshot": jpegData!.base64EncodedString()
        ]
        RequestManager.request(type: .post,
                               feature: .certificate,
                               subUrl: nil,
                               params: parameter,
                               success: { jsonResponse in
                                
                                self.promptInfo(jsonResponse["realname"].stringValue, jsonResponse["id_number"].stringValue)
                                return
                               }, failure: { error in
                                self.setRetryLabel()
                                
                                SPAlert.present(message: "服务器报告了一个「\(error)」错误。", haptic: .error)
                                return
                               })
    }
    
    @objc func retryButtonTapped() {
        tryLoading()
    }
    
    @objc func loginButtonTapped() {
        var userIdField: UITextField?
        var userNameTextField: UITextField?
        
        let alertController = UIAlertController.init(title: "既有用户登入", message: "请提供注册时使用的身份信息。", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确认",
                                       style: .default,
                                       handler: {_ in
                                        UserPrefInitializer.userId = userIdField?.text ?? ""
                                        UserPrefInitializer.userName = userNameTextField?.text ?? ""
                                        self.tryLoading()
                                       })
        let cancelAction = UIAlertAction(title: "取消",
                                         style: .cancel,
                                         handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { (textField) in
            userIdField = textField
            userIdField?.placeholder = "身份证件 ID"
        }
        
        alertController.addTextField { (textField) in
            userNameTextField = textField
            userNameTextField?.placeholder = "真实姓名"
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    func completeInit() {
        performSegue(withIdentifier: "sucessfullyInitSegue", sender: nil)
    }
    
    func promptInfo(_ realName: String, _ idNumber: String) {
        
        self.tryLoading()
        
        
        let alertController = UIAlertController(title: "确认您的个人信息",
                                                message: "\(realName)，身份证号码 \(idNumber)",
                                                preferredStyle: .actionSheet)
        
        alertController.view.setTintColor()
        
        let correctButton = UIAlertAction(title: "正确",
                                                  style: .default,
                                                  handler: { _ in
                                                    
                                                    UserPrefInitializer.userName = realName
                                                    UserPrefInitializer.userId = idNumber
                                                    self.tryLoading()
                                                  })
        
        let cancelAction = UIAlertAction(title: "不正确",
                                         style: .cancel,
                                         handler: { _ in
                                            self.tryLoading()
                                         })
        
        alertController.addAction(correctButton)
        alertController.addAction(cancelAction)
        
        alertController.popoverPresentationController?.sourceView = requireRegister
        alertController.popoverPresentationController?.sourceRect = requireRegister.bounds
        
        present(alertController, animated: true, completion: nil)
    }
}

//
//  RegisterViewController.swift
//  InstaPass
//
//  Created by 法好 on 2020/6/27.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import UIKit
import SPAlert
import ImagePicker

class InitializeViewController: UIViewController, ImagePickerDelegate {
    override func viewDidLoad() {

        requireRegister.isUserInteractionEnabled = true
        let registerSingleTap = UITapGestureRecognizer(target: self, action: #selector(registerButtonTapped))
        requireRegister.addGestureRecognizer(registerSingleTap)
        
        requireRegister.accessibilityLabel = "以新身份登入"
        requireRegister.accessibilityRespondsToUserInteraction = true
        
        retryLoading.isUserInteractionEnabled = true
        let retrySingleTap = UITapGestureRecognizer(target: self, action: #selector(retryButtonTapped))
        retryLoading.addGestureRecognizer(retrySingleTap)
        
        retryLoading.accessibilityLabel = "再试一次"
        retryLoading.accessibilityRespondsToUserInteraction = true
        
        tryLoading()

        super.viewDidLoad()
    }
    
    func setLoadingLabel() {
        majorTitleLabel.text = "正在同服务器取得联系"
        minorTitleLabel.text = "请稍等片刻"
        loadingIndicator.isHidden = false
        requireRegister.isHidden = true
        retryLoading.isHidden = true
    }
    
    func setRegisteringLabel() {
        majorTitleLabel.text = "正在确认您的身份"
        minorTitleLabel.text = "请稍等片刻"
        loadingIndicator.isHidden = false
        requireRegister.isHidden = true
        retryLoading.isHidden = true
    }
    
    func setRequireRegisterLabel() {
        majorTitleLabel.text = "无记录"
        minorTitleLabel.text = "请登入 InstaPass 账户"
        loadingIndicator.isHidden = true
        requireRegister.isHidden = false
        retryLoading.isHidden = true
    }
    
    func setRetryLabel() {
        majorTitleLabel.text = "联络失败"
        minorTitleLabel.text = "未能同服务器取得联系"
        loadingIndicator.isHidden = true
        requireRegister.isHidden = false
        
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
    
    @objc func registerButtonTapped() {
        let configuration = Configuration()
        configuration.doneButtonTitle = "完成"
        configuration.noImagesTitle = "读入照片库中"
        configuration.OKButtonTitle = "好"
        configuration.allowMultiplePhotoSelection = false
        configuration.allowVideoSelection = false
        configuration.cancelButtonTitle = "取消"
        configuration.mainColor = globalTintColor
        configuration.recordLocation = false
        configuration.noCameraTitle = "无法连接到相机"
        configuration.requestPermissionMessage = "InstaPass 需要您的许可来访问您的相片。"
        configuration.requestPermissionTitle = "请求许可"

        let imagePickerController = ImagePickerControllerWithAlert(configuration: configuration)
        imagePickerController.delegate = self
    
        present(imagePickerController, animated: true, completion: {
            imagePickerController.alert = SPAlertView(title: "请提供一张由政府颁发的身份证正面相片。", message: nil, image: UIImage(systemName: "exclamationmark.shield")!)
            imagePickerController.alert?.haptic = .warning
            imagePickerController.alert?.duration = TimeInterval(5)
            imagePickerController.alert?.present()
        })
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        (imagePicker as? ImagePickerControllerWithAlert)?.alert?.dismiss()
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        if images.count == 1 {
            imagePicker.dismiss(animated: true, completion: {
                self.sendRegisterRequest(image: images[0])
            })
        } else {
            imagePicker.dismiss(animated: true, completion: nil)
        }
        (imagePicker as? ImagePickerControllerWithAlert)?.alert?.dismiss()
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
        (imagePicker as? ImagePickerControllerWithAlert)?.alert?.dismiss()
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
        
        present(alertController, animated: true, completion: nil)
    }
}

class ImagePickerControllerWithAlert: ImagePickerController {
    var alert: SPAlertView?
}

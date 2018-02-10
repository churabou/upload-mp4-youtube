//
//  ViewController.swift
//  sample
//
//  Created by ちゅーたつ on 2018/02/04.
//  Copyright © 2018年 ちゅーたつ. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD


class ViewController: UIViewController {

    
    let session = YoutubeSession.shared
    
    @objc fileprivate func actionAuth() {
        
        session.requestAuthorization(controller: self, completion: {
            print("ok")
            self.authButton.removeFromSuperview()
            self.setUploadButton()
        })
    }
    
    @objc fileprivate func actionUpload() {
        
        guard let file = Bundle.main.path(forResource: "video2", ofType: "mp4") else {
            fatalError("nofile")
        }
        
        UpdateUI(isRequesting: true)

        session.uploadVideo(file: file, completion: {
            self.UpdateUI(isRequesting: false)
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        session.deleateAuthFromKeyChain()
        if session.authorization != nil {
            setUploadButton()
        } else {
            setAuthButton()
        }
    }
    
    let authButton = UIButton()
    let uploadButton = UIButton()
    
    func setAuthButton() {
        
        authButton.setTitle("auth", for: .normal)
        authButton.setTitleColor(.white, for: .normal)
        authButton.backgroundColor = .blue
        authButton.addTarget(self, action: #selector(actionAuth), for: .touchUpInside)
        view.addSubview(authButton)

        authButton.snp.makeConstraints({ make in
            make.size.equalTo(100)
            make.center.equalToSuperview()
        })
    }
    
    func setUploadButton() {
        
        uploadButton.setTitle("upload", for: .normal)
        uploadButton.setTitleColor(.white, for: .normal)
        uploadButton.backgroundColor = .red
        uploadButton.addTarget(self, action: #selector(actionUpload), for: .touchUpInside)
        view.addSubview(uploadButton)
        
        uploadButton.snp.makeConstraints({ make in
            make.size.equalTo(100)
            make.center.equalToSuperview()
        })
    }
    
    func UpdateUI(isRequesting: Bool) {
        
        if isRequesting {
            SVProgressHUD.show()
            uploadButton.isEnabled = false
        } else {
            SVProgressHUD.dismiss()
            uploadButton.isEnabled = true
        }
    }
}

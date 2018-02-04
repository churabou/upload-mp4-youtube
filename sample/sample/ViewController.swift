//
//  ViewController.swift
//  sample
//
//  Created by ちゅーたつ on 2018/02/04.
//  Copyright © 2018年 ちゅーたつ. All rights reserved.
//

import UIKit
import GTMAppAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let auth = GTMAppAuthFetcherAuthorization(fromKeychainForName: "AuthorizerKey") {
            
            let session = YoutubeSession()
            
            guard let url = Bundle.main.url(forResource: "video", withExtension: "mp4") else {
                fatalError("nofile")
            }
            session.upload(url)
            
        } else {
            GoogleOauth2Manager.shared.auth(controller: self)
        }
    }
}

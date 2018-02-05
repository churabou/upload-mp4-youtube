//
//  ViewController.swift
//  sample
//
//  Created by ちゅーたつ on 2018/02/04.
//  Copyright © 2018年 ちゅーたつ. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let auth = GoogleOauth2Manager.shared.authorization {
            
            GoogleOauth2Manager.testFeach(auth: auth)
//            let session = YoutubeSession()
//
//            guard let url = Bundle.main.url(forResource: "video", withExtension: "mp4") else {
//                fatalError("nofile")
//            }
//            session.upload(url)
            
        } else {
            GoogleOauth2Manager.shared.requestAuthorization(controller: self)
        }
        

    }
}

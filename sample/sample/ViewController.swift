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
            let session = YoutubeSession()

            guard let file = Bundle.main.path(forResource: "video", ofType: "mp4") else {
                fatalError("nofile")
            }
            
            session.uploadVideo(file: file)
        } else {
            GoogleOauth2Manager.shared.requestAuthorization(controller: self)
        }
        

    }
}

import GTMAppAuth
import GoogleAPIClientForREST


class YoutubeSession {
    
    static let shared = YoutubeSession()
    
    var authorization: GTMAppAuthFetcherAuthorization? {
        if let auth = GTMAppAuthFetcherAuthorization(fromKeychainForName: "AuthorizerKey") {
            return auth
        }
        return nil
    }
    
    internal var currentAuthorizationFlow: OIDAuthorizationFlowSession?
    
    internal func requestAuthorization(controller: UIViewController, completion: @escaping () -> ()) {
        
        let yourKey = ""
        let clientId = "\(yourKey).apps.googleusercontent.com"
        let redirectURI = URL(string: "com.googleusercontent.apps.\(yourKey):/oauthredirect")!
        let scopes = [kGTLRAuthScopeYouTube, OIDScopeEmail]
        
        let configuration = GTMAppAuthFetcherAuthorization.configurationForGoogle()
        let request = OIDAuthorizationRequest(configuration: configuration,
                                              clientId: clientId,
                                              clientSecret: nil,
                                              scopes: scopes,
                                              redirectURL: redirectURI,
                                              responseType: OIDResponseTypeCode,
                                              

                                              additionalParameters: nil)
        
        
        currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, presenting: controller, callback: { authState, error in
            
            if let state = authState {
                
                let auth = GTMAppAuthFetcherAuthorization(authState: state)
                GTMAppAuthFetcherAuthorization.save(auth, toKeychainForName: "AuthorizerKey")
                completion()
            }
        })
    }
    
    
    fileprivate lazy var authenticatedService: GTLRYouTubeService? = {
        
        let service = GTLRYouTubeService()
        guard let auth = authorization else {
            return nil
        }
        service.shouldFetchNextPages = true
        service.isRetryEnabled = true
        service.authorizer = auth
        
        return service
    }()
    
    //https://github.com/google/google-api-objectivec-client-for-rest/blob/master/Examples/YouTubeSample/YouTubeSampleWindowController.m#L434
    internal func uploadVideo(file: String, completion: @escaping () -> ()){
        
        guard let service = authenticatedService else {
            return
        }
        
        let status = GTLRYouTube_VideoStatus()
        status.privacyStatus = kGTLRYouTube_VideoStatus_PrivacyStatus_Public
        
        let snippet = GTLRYouTube_VideoSnippet()
        snippet.title = "upload title"
        snippet.descriptionProperty = "test upload 3"
        snippet.tags = "test,video,upload".components(separatedBy: ",")
        
        let video = GTLRYouTube_Video()
        video.snippet = snippet
        video.status = status
        
        var error: NSError?
        let fileURL = NSURL(fileURLWithPath: file)
        if !fileURL.checkResourceIsReachableAndReturnError(&error) {
            print("file not found")
            return 
        }
        
        let params = GTLRUploadParameters(fileURL: fileURL as URL, mimeType: "video/mp4")
        
        let query = GTLRYouTubeQuery_VideosInsert.query(withObject: video, part: "snippet,status", uploadParameters: params)

        query.executionParameters.uploadProgressBlock = {(progressTicket, totalBytesUploaded, totalBytesExpectedToUpload) in
            print("Uploaded \(totalBytesUploaded)/\(totalBytesExpectedToUpload)")
        }
        
        
        service.executeQuery(query, completionHandler: { ticket, video, error in

            if error != nil {
                print(error?.localizedDescription)
            } else {
                
                if let video = video as? GTLRObject  {
                       print("video: \(video.json)")
                }
                completion()
            }
        })
    }
    
    func deleateAuthFromKeyChain() {
        GTMAppAuthFetcherAuthorization.removeFromKeychain(forName: "AuthorizerKey")
    }
}

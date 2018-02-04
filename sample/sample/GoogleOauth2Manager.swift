import GTMAppAuth

class GoogleOauth2Manager {
    
    static let shared = GoogleOauth2Manager()
    
    var authorization: GTMAppAuthFetcherAuthorization?
    var currentAuthorizationFlow: OIDAuthorizationFlowSession?
    
    func auth(controller: UIViewController) {
        
        let yourKey = ""
        let clientId = "\(yourKey).apps.googleusercontent.com"
        let redirectURI = URL(string: "com.googleusercontent.apps.\(yourKey):/oauthredirect")!
        
        let configuration = GTMAppAuthFetcherAuthorization.configurationForGoogle()
        let request = OIDAuthorizationRequest(configuration: configuration,
                                              clientId: clientId,
                                              clientSecret: nil,
                                              scopes: [OIDScopeOpenID, OIDScopeProfile],
                                              redirectURL: redirectURI,
                                              responseType: OIDResponseTypeCode,
                                              
                                              additionalParameters: nil)
        
        
        currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, presenting: controller, callback: { authState, error in
            
            if let state = authState {
                print("ok")
                
                let auth = GTMAppAuthFetcherAuthorization(authState: state)
                self.authorization = auth
                GTMAppAuthFetcherAuthorization.save(auth, toKeychainForName: "AuthorizerKey")
                
                self.testFeach()
            }
        })
    }
    
    func testFeach() {
        
        let service = GTMSessionFetcherService()
        service.authorizer = authorization
        
        let endpoint = "https://www.googleapis.com/oauth2/v3/userinfo"
        guard let url = URL(string: endpoint) else {
            return
        }
        
        let feacher = service.fetcher(with: url)
        feacher.beginFetch(completionHandler: { data, error in
            
            if error != nil {
                print(error)
            }
            let userInfo = try! JSONSerialization.jsonObject(with: data!, options: [])
            print(userInfo)
        })
    }
}


import GTMAppAuth
import GoogleAPIClientForREST

class GoogleOauth2Manager {
    
    static let shared = GoogleOauth2Manager()
    
    var authorization: GTMAppAuthFetcherAuthorization? {
        
        if let auth = GTMAppAuthFetcherAuthorization(fromKeychainForName: "AuthorizerKey") {
            return auth
        }
        return nil
    }
    
    var currentAuthorizationFlow: OIDAuthorizationFlowSession?
    
    func requestAuthorization(controller: UIViewController) {
        
        let yourKey = ""
        let clientId = "\(yourKey).apps.googleusercontent.com"
        let redirectURI = URL(string: "com.googleusercontent.apps.\(yourKey):/oauthredirect")!
        let scopes = [OIDScopeOpenID, OIDScopeProfile, kGTLRAuthScopeYouTube,OIDScopeEmail]
        
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
                print("ok")
                
                let auth = GTMAppAuthFetcherAuthorization(authState: state)
                GTMAppAuthFetcherAuthorization.save(auth, toKeychainForName: "AuthorizerKey")
            }
        })
    }
    
    static func testFeach(auth: GTMAppAuthFetcherAuthorization) {
        
        let service = GTMSessionFetcherService()
        service.authorizer = auth
        
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


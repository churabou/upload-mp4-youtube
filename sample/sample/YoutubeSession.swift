import GoogleAPIClientForREST
import GTMAppAuth


class YoutubeSession {
    
    
    fileprivate lazy var authenticatedService: GTLRYouTubeService? = {
        
        let service = GTLRYouTubeService()
        guard let auth = GTMAppAuthFetcherAuthorization(fromKeychainForName: "AuthorizerKey") else {
            return nil
        }
        service.authorizer = auth
        service.apiKey = "APIKey"
        
        return service
    }()
    
    func post() {
        
        guard let  url = URL(string: "https.youtube.com") else {
            print("@@ invalid url")
            return
        }
        
        upload(url)
    }
    
    
    func upload(_ url: URL) {
        
        guard let service = authenticatedService else {
            return
        }

        let status = GTLRYouTube_VideoStatus()
        status.privacyStatus = kGTLRYouTube_VideoStatus_PrivacyStatus_Public
        
        let snippet = GTLRYouTube_VideoSnippet()
        snippet.title = "Lalala"
        snippet.descriptionProperty = "TestUpload"
        snippet.tags = "test,video,upload".components(separatedBy: ",")
        
        let youtubeVideo = GTLRYouTube_Video()
        youtubeVideo.snippet = snippet
        youtubeVideo.status = status
        
        let params = GTLRUploadParameters(fileURL: url, mimeType: "video/mp4")
        
        let query = GTLRYouTubeQuery_VideosInsert.query(withObject: youtubeVideo, part: "snippet,status", uploadParameters: params)
        
        query.executionParameters.uploadProgressBlock = {(progressTicket, totalBytesUploaded, totalBytesExpectedToUpload) in
            print("Uploaded", totalBytesUploaded)
        }
        
        
        service.executeQuery(query, completionHandler: { ticket,b,c in
            
            
            print(ticket)
            print(b)
            print(c)
            
        })
    }
}

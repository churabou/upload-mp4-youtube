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
        
        let video = GTLRYouTube_Video()
        video.snippet = snippet
        video.status = status
        
        
        let fileHandle = try! FileHandle(forReadingFrom: url)
        
        let params = GTLRUploadParameters(fileHandle: fileHandle, mimeType: "video/mp4")
//        let params = GTLRUploadParameters(data: data, mimeType: "video/mp4")
//        let params = GTLRUploadParameters(fileURL: url, mimeType: "video/mp4")
        
        let query = GTLRYouTubeQuery_VideosInsert.query(withObject: video, part: "snippet,status", uploadParameters: params)
        
        query.executionParameters.uploadProgressBlock = {(progressTicket, totalBytesUploaded, totalBytesExpectedToUpload) in
            print("Uploaded", totalBytesUploaded)
        }
        
        
        service.executeQuery(query, completionHandler: { ticket,b,error in
            
            
            print("@チケット")
            print(ticket)
            print(b)
            print("@エラー")
            print(error?.localizedDescription)
            
        })
    }
}

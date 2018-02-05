import GoogleAPIClientForREST


class YoutubeSession {
    
    
    fileprivate lazy var authenticatedService: GTLRYouTubeService? = {
        
        let service = GTLRYouTubeService()
        guard let auth = GoogleOauth2Manager.shared.authorization else {
            return nil
        }
        service.shouldFetchNextPages = true
        service.isRetryEnabled = true
        service.authorizer = auth
        
        return service
    }()
    
    //https://github.com/google/google-api-objectivec-client-for-rest/blob/master/Examples/YouTubeSample/YouTubeSampleWindowController.m#L434
    func uploadVideo(file: String){
        
        guard let service = authenticatedService else {
            return
        }
        
        let status = GTLRYouTube_VideoStatus()
        status.privacyStatus = kGTLRYouTube_VideoStatus_PrivacyStatus_Public
        
        let snippet = GTLRYouTube_VideoSnippet()
        snippet.title = "upload title"
        snippet.descriptionProperty = "test upload"
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
            print("Uploaded", totalBytesUploaded)
        }
        
        
        service.executeQuery(query, completionHandler: { ticket, video, error in
            
            
            print("@チケット")
            print(ticket)
            print(video)
            print("@エラー")
            print(error?.localizedDescription)
        })
    }
}

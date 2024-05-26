//
//  NetworkManager.swift
//  Fitcoder Watch App
//
//  Created by Rizki Maulana on 22/05/24.
//

import Foundation

class NetworkManager {
    let userDefaultsManager = UserDefaultsManager()
    
    func commitToGitHub() {
        let userName = Constants.userName
        let repoName = Constants.repoName
        let filePath = Constants.filePath
        let token = Constants.token
        let name = Constants.name
        let email = Constants.email
        let sha = userDefaultsManager.shaFromFile
        let commitMessage = "Standing activity commit"
        let content = "User stood up and completed the activity."
        
        let url = URL(string: "https://api.github.com/repos/\(userName)/\(repoName)/contents/\(filePath)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.setValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")
        
        let contentData = content.data(using: .utf8)!.base64EncodedString()
        var params: [String: Any] = [
            "message": commitMessage,
            "content": contentData,
            "committer": [
                "name": name,
                "email": email
            ]
        ]
        
        if sha != nil {
            params["sha"] = sha
        }
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error committing to GitHub: \(String(describing: error))")
                return
            }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let content = json["content"] as? [String: Any],
               let newSha = content["sha"] as? String {
                self.userDefaultsManager.shaFromFile = newSha
            }
            print("Success: \(String(data: data, encoding: .utf8)!)")
        }
        
        task.resume()
    }
}

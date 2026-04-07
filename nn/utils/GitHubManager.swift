//
//  GitHubManager.swift
//  nn
//
//  Created by JUNGGWAN KIM on 9/8/25.
//

import Foundation
import SwiftUI
import AuthenticationServices

class GitHubManager {
    static let shared = GitHubManager()
    
    private let clientId = "Ov23liHR90McyBLaxhxX"
    private let clientSecret = "ea395945fcba242d1dacd6bcb83c157a875c3b9a"
    private let callbackScheme = "nn.diary"
    private var authSession: ASWebAuthenticationSession?
    private var token: String?
    private let contextProvider = ContextProvider()
    private var repo: String?
    
    
    /// 앱에 연동
    func startGitHubLogin(completion: @escaping () -> Void) {
        let authURL = URL(string:
            "https://github.com/login/oauth/authorize?client_id=\(clientId)&scope=repo")!

        authSession = ASWebAuthenticationSession(
            url: authURL,
            callbackURLScheme: callbackScheme
        ) { callbackURL, error in
            guard error == nil, let callbackURL = callbackURL else { return }

            // redirect url 예: myapp://callback?code=XXXX
            if let code = URLComponents(string: callbackURL.absoluteString)?
                .queryItems?
                .first(where: { $0.name == "code" })?.value {

                // code를 서버로 보내 토큰 교환
                self.exchangeCodeForToken(code: code) { t in
                    if let accessToken = t {
                        self.token = accessToken
                        NnUserDefaults.gitAccessToken = accessToken
                    }
                    completion()
                }
            }
        }
        authSession?.presentationContextProvider = contextProvider
        authSession?.start()
    }
    
    func getToken() -> String {
        if self.token?.isEmpty ?? true {
            token = NnUserDefaults.gitAccessToken
        }
        return token!
    }
    
    func fetchRepositories(token: String, completion: @escaping ([GitHubRepo]) -> Void) {
        var request = URLRequest(url: URL(string: "https://api.github.com/user/repos")!)
        request.addValue("token \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, res, err in
            print("res: \(String(describing: res))")
            print("err: \(String(describing: err))")
            debugPrint("data: \(String(describing: data))")
            
            if let data = data {
                if let repos = try? JSONDecoder().decode([GitHubRepo].self, from: data) {
                    print("repos")
                    completion(repos)
                } else {
                    print("repos2")
                    completion([])
                }
            } else {
                completion([])
            }
        }.resume()
    }
    
    func createRepository(token: String, name: String, description: String? = nil, isPrivate: Bool = false, completion: @escaping (GitHubRepo?) -> Void) {
        var request = URLRequest(url: URL(string: "https://api.github.com/user/repos")!)
        request.httpMethod = "POST"
        request.addValue("token \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        var body: [String: Any] = [
            "name": name,
            "private": isPrivate
        ]
        if let desc = description {
            body["description"] = desc
        }

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, res, err in
            print("data: \(String(describing: data))")
            print("res: \(String(describing: res))")
            print("err: \(String(describing: err))")
            
            if let data = data,
               let repo = try? JSONDecoder().decode(GitHubRepo.self, from: data) {
                completion(repo)
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    /// 파일 업로드
    /// 단순 업로드로 같은 파일 존재시 변경내용이 반영되지 않는다.
    func uploadFileToGitHub(repo: String, path: String, content: Data) {
        let url = URL(string: "https://api.github.com/repos/\(repo)/contents/\(path)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("token \(getToken())", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let base64Content = content.base64EncodedString()
        let body: [String: Any] = [
            "message": "Add file via app",
            "content": base64Content
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, res, err in
            print("data: \(String(describing: data))")
            print("res: \(String(describing: res))")
            print("err: \(String(describing: err))")
            
            if let data = data,
               let response = try? JSONSerialization.jsonObject(with: data) {
                print("Upload Response:", response)
            }
        }.resume()
    }
    
    func uploadIfChanged(
        repo: String,
        path: String,
        newContent: Data,
        message: String
    ) {
        let url = URL(string: "https://api.github.com/repos/\(repo)/contents/\(path)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("token \(getToken())", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, _ in
            var sha: String? = nil
            var isSame = false
            
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                
                // sha 추출
                sha = json["sha"] as? String
                
                // 기존 content 추출
                if let encodedContent = json["content"] as? String {
                    // base64 디코딩 (개행 제거)
                    let cleaned = encodedContent.replacingOccurrences(of: "\n", with: "")
                    if let oldData = Data(base64Encoded: cleaned) {
                        // ⚡ 바이트 단위 비교
                        isSame = (oldData == newContent)
                    }
                }
            }
            
            // 기존 내용과 완전히 같으면 업로드 안 함
            if isSame {
                print("⚡ 기존 파일과 동일 → 업로드 생략")
                return
            }
            
            // PUT 요청 (새로 생성 or 업데이트)
            var putRequest = URLRequest(url: url)
            putRequest.httpMethod = "PUT"
            putRequest.addValue("token \(self.getToken())", forHTTPHeaderField: "Authorization")
            putRequest.addValue("application/json", forHTTPHeaderField: "Accept")

            let base64Content = newContent.base64EncodedString()
            var body: [String: Any] = [
                "message": message,
                "content": base64Content
            ]
            if let sha = sha {
                body["sha"] = sha   // 있으면 업데이트
            }

            putRequest.httpBody = try? JSONSerialization.data(withJSONObject: body)

            URLSession.shared.dataTask(with: putRequest) { data, _, _ in
                if let data = data,
                   let response = try? JSONSerialization.jsonObject(with: data) {
                    print("✅ Upload/Update Response:", response)
                }
            }.resume()
        }.resume()
    }
    
    func canUse() -> Bool {
        token = getToken()
        repo = getRepo()
        return if token?.isEmpty ?? true || repo?.isEmpty ?? true {
            false
        } else {
            true
        }
    }
    
    func setRepo(_ gitHubRepo: GitHubRepo) {
        repo = gitHubRepo.fullName
        NnUserDefaults.gitRepo = gitHubRepo.fullName
    }
    
    func getRepo() -> String {
        if self.repo?.isEmpty ?? true {
            repo = NnUserDefaults.gitRepo
        }
        return repo!
    }
    
    /// 토큰 가져오기
    private func exchangeCodeForToken(code: String, completion: @escaping (String?) -> Void) {
        var request = URLRequest(url: URL(string: "https://github.com/login/oauth/access_token")!)
        request.httpMethod = "POST"
        let body = "client_id=\(clientId)&client_secret=\(clientSecret)&code=\(code)"
        request.httpBody = body.data(using: .utf8)
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, res, err in
            print("data: \(String(describing: data))")
            print("res: \(String(describing: res))")
            print("err: \(String(describing: err))")
            
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let token = json["access_token"] as? String {
                completion(token)
            } else {
                completion(nil)
            }
        }.resume()
    }
}

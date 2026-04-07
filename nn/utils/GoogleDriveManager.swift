//
//  GoogleDriveManager.swift
//  nn
//
//  Created by JUNGGWAN KIM on 8/28/25.
//

import Foundation
import CoreData
import GoogleSignIn

class GoogleDriverManager {
    static let shared = GoogleDriverManager()
    private var accessToken: String? = nil
    private var refreshToken: String? = nil
    private var clientId: String? = nil
    private var clientSecret: String? = nil
    private var fileId: String? = nil
    private let rootKey: String = "rootKey"
    
    
    func getFileId() -> String {
        return fileId ?? NnUserDefaults.googleFileId
    }
    
    func signIn() {
        print("[GIDSignIn]-------------------------------")
        if let clientID = getClientId() {
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            
            guard let rootVc = UIApplication.shared.getCurrentRootVc() else {
                print("signIn failed: can not get rootVc")
                return
            }
            
            GIDSignIn.sharedInstance.signIn(
                withPresenting: rootVc,
                hint: nil,
                additionalScopes: ["https://www.googleapis.com/auth/drive.file"]
            ) { signInResult, error in
                if let error = error {
                    print("signIn failed: \(error)")
                    return
                }
                guard let user = signInResult?.user else {
                    print("signIn failed: can not get signInResult.user")
                    return
                }
                
                print("signIn succeed")
                print("access token: \(user.accessToken)")
                NnUserDefaults.gitAccessToken = user.accessToken.tokenString
                self.accessToken = user.accessToken.tokenString
                print("configuration: \(user.configuration)")
                print("refreshToken: \(user.refreshToken)")
            }
        } else {
            print("signIn failed: can not get clientId")
            return
        }
        print("------------------------------------------")
    }
    
    func restorePreviousGoogleSignIn() {
        GIDSignIn.sharedInstance.restorePreviousSignIn() {user, err in
            if user != nil {
                self.accessToken = NnUserDefaults.googleAccessToken
                print("succeed, \(String(describing: user?.accessToken.tokenString))")
            } else {
                print ("error: \(String(describing: err))")
            }
        }
    }
    
    func uploadFilteredEntityToDrive(context: NSManagedObjectContext) {
        guard let jsonData = exportFilteredEntityToJSON(context: context) else { return }
        
        if let token = accessToken {
            uploadToDrive(
                fileData: jsonData,
                fileName: "nn_Backup.json",
                mimeType: "application/json",
                accessToken: token
            )
        } else {
            print("token is nil")
            return
        }
    }
    
    func saveToCoreData(items: [SavedDiary], context: NSManagedObjectContext) {
        for item in items {
            if let md = MDate(str: item.date) {
                if let diary = DiaryServicer.shared.search(context, date: md) {
                    DiaryServicer.shared.update(context, diary: diary, date: md, text: item.note) { isSuccess, diary in
                    }
                } else {
                    DiaryServicer.shared.write(context, date: md, text: item.note) { isSuccess, diary in
                    }
                }
            }
        }
        do {
            try context.save()
            print("저장 성공!")
        } catch {
            print("저장 실패:", error)
        }
    }
    
    func downloadFile(completion: @escaping (Data?) -> Void) {
        let url = URL(string: "https://www.googleapis.com/drive/v3/files/\(getFileId())?alt=media")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("다운로드 에러:", error)
                    completion(nil)
                    return
                }
                print("downloadFile response: \(String(describing: response))")
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        completion(data)
                    }
                }
                
                print("downloadFile data: \(String(describing: data))")
            }.resume()
        } else {
            print(print("다운로드 에러:", "accessToke is nil"))
        }
    }
    
    func canUse() -> Bool {
        return if accessToken?.isEmpty ?? true {
            false
        } else {
            true
        }
    }
    
    private func exportFilteredEntityToJSON(context: NSManagedObjectContext) -> Data? {
        print("[exportFilteredEntityToJSONWithRootKey]-----------")
        do {
            let results = DiaryServicer.shared.searchAll(context)
            
            var dicts: [Dictionary<String, Any>] = []
            results?.forEach { d in
                var dict = [String: Any]()
                for attr in d.entity.attributesByName {
                    dict[attr.key] = d.value(forKey: attr.key)
                }
                dicts.append(dict)
            }
            // 루트 키를 둔 Dictionary 생성
            let finalDict: [String: Any] = [rootKey: dicts]
            print("\(rootKey): [")
            print(" [")
            dicts.forEach{ d in
                print(" \(d)")
            }
            print(" ]")
            print("]")
            print("--------------------------------------------")
            return try JSONSerialization.data(withJSONObject: finalDict, options: .prettyPrinted)
        } catch {
            print("Export 실패: \(error)")
            print("--------------------------------------------")
            return nil
        }
    }

    private func uploadToDrive(
        fileData: Data,
        fileName: String,
        mimeType: String,
        accessToken: String
    ) {
        let url = URL(string: "https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        let boundary = "boundary-\(UUID().uuidString)"
        request.setValue("multipart/related; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        // 멀티파트 body 생성
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Type: application/json; charset=UTF-8\r\n\r\n".data(using: .utf8)!)
        body.append("{\"name\": \"\(fileName)\"}\r\n".data(using: .utf8)!)

        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(fileData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--".data(using: .utf8)!)

        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let e = error {
                print("업로드 에러(네트워크): \(e)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("업로드 성공")
                } else if httpResponse.statusCode == 401 {
                    // 토큰 만료 → 새 토큰 발급 후 재시도
                    self.refreshAccessToken { isSuccess, token in
                        if isSuccess,
                         let t = token {
                            self.uploadToDrive(fileData: fileData, fileName: fileName, mimeType: mimeType, accessToken: t)
                        } else {
                            print("토큰 갱신 실패")
                        }
                    }
                } else {
                    print("업로드 에러")
                }
            }
            if let d = data {
                do {
                    print("body: \(String(data: d, encoding: .utf8) ?? "")")
                    let result = try JSONSerialization.jsonObject(with: d) as? [String: Any]
                    print("응답 파싱 성공: ", result ?? "")
                    if let fid = result?["id"] as? String {
                        self.fileId = fid
                        NnUserDefaults.googleFileId = fid
                    }
                } catch {
                    print("응답 파싱 실패:", error)
                    return
                }
            }
        }.resume()
    }

    private func getClientId() -> String? {
        if let url = Bundle.main.url(forResource: "client_515723939210-d1ops1gkjurah7j991phlqh04n3m8idm.apps.googleusercontent.com", withExtension: "plist"),
           let data = try? Data(contentsOf: url),
           let dict = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any] {
            
            guard let clientID = dict["CLIENT_ID"] as? String else {
                return nil
            }
            return clientID
        } else {
            return nil
        }
    }
    
    private func refreshAccessToken(completion: @escaping (Bool, String?) -> Void) {
        let url = URL(string: "https://oauth2.googleapis.com/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let bodyParams = [
            "client_id": clientId,
            "client_secret": clientSecret,
            "refresh_token": refreshToken,
            "grant_type": "refresh_token"
        ]
        request.httpBody = bodyParams
            .compactMap { "\($0.key)=\(String(describing: $0.value))" }
            .joined(separator: "&")
            .data(using: .utf8)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let newAccessToken = json["access_token"] as? String else {
                completion(false, nil)
                return
            }
            
            print("새 AccessToken 발급: \(newAccessToken)")
            completion(true, newAccessToken)
        }.resume()
    }
    
//    private func getFileMetadata(fileId: String, accessToken: String, completion: @escaping (Int64?) -> Void) {
//        let urlStr = "https://www.googleapis.com/drive/v3/files/\(fileId)?fields=id,name,size,mimeType"
//        guard let url = URL(string: urlStr) else {
//            completion(nil)
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data,
//                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
//                  let sizeStr = json["size"] as? String,
//                  let size = Int64(sizeStr) else {
//                completion(nil)
//                return
//            }
//            completion(size)
//        }.resume()
//    }

}

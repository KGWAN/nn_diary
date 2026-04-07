//
//  GoogledriveView.swift
//  nn
//
//  Created by JUNGGWAN KIM on 8/26/25.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import CoreData

struct GoogledriveView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var theme: ThemeManager
    
    let gdm = GoogleDriverManager.shared
    
    var body: some View {
        VStack {
            SubHeaderView() {
                dismiss()
            }
            VStack(alignment: .leading, spacing: 20) {
                Text("Google Drive에 데이터를 수동으로 백업하여 핸드폰이 바뀌어도 간편하게 복구할 수 있습니다. 주기적으로 백업해야 데이터를 안전하게 보관할 수 있습니다.")
                .foregroundStyle(theme.week)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                Button("Data backup") {
                    gdm.uploadFilteredEntityToDrive(context: viewContext)
                }
                .foregroundStyle(theme.foreground)
                Button("Data restoration") {
                    gdm.downloadFile() { data in
                        guard let data = data else { return }
                        do {
                            let decoded = try JSONDecoder().decode(GoogleDriveResponse.self, from: data)
                            let items = decoded.rootKey
                            decoded.rootKey.forEach { j in
                                print("Response: \(j)")
                            }
                            DispatchQueue.main.async {
                                gdm.saveToCoreData(items: items, context: viewContext)
                            }
                        } catch {
                            print("디코딩 실패:", error)
                        }
                    }
                }
                .foregroundStyle(theme.foreground)
                Button("Google Drive 연동") {
                    gdm.signIn()
                }
                .foregroundStyle(theme.foreground)
                Spacer()
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
            .onOpenURL { url in
                print("url: \(url)")
                _ = GIDSignIn.sharedInstance.handle(url)
                print("handle: \(GIDSignIn.sharedInstance.handle(url))")
            }
        }
        .background(theme.background)
    }
}



//#Preview {
//    GoogledriveView()
//}

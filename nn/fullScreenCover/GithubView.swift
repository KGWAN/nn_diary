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

struct GithubView: View {
    @State private var repos: [GitHubRepo] = []
    @State private var selectedRepo: GitHubRepo?
    @State private var isAvailable: Bool = false
    @State var month: MDate = MDate(date: Date())
    @State var isShowPopup: Bool = false
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var theme: ThemeManager
    
    private let gitManager = GitHubManager.shared
    
    var body: some View {
        ZStack {
            VStack{
                SubHeaderView() {
                    dismiss()
                }
                VStack(alignment: .leading, spacing: 20) {
                    Text("Git Hub에 데이터를 md파일로 올릴 수 있습니다. 월별로 데이터를 업로드 할 수 있습니다. 아래의 순서로 진행됩니다.")
                        .foregroundStyle(theme.week)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                    
                    // Step 1
                    Text("1. Git Hub 연동을 진행합니다. Git Hub 계정이 필요합니다. 아래의 버튼을 눌러 계정을 연동합니다.")
                        .foregroundStyle(theme.week)
                    Button {
                        // 깃허브 연동
                        gitManager.startGitHubLogin(
                            completion: {
                                if !gitManager.getToken().isEmpty {
                                    isAvailable = true
                                }
                            }
                        )
                    } label: {
                        Text("Git Hub 연동")
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                    .background(theme.hilight)
                    .foregroundStyle(theme.foreground)
                    .cornerRadius(5)
                    
                    // Step 2
                    Text("2. 업로드할 저장소를 선택합니다. 버튼을 누르면 저장소를 불러오고 존재하지 않는 경우 새로 생성합니다.")
                        .foregroundStyle(theme.week)
                    Button {
                        print("[fetchRepositories]------------------------")
                        gitManager.fetchRepositories(token: gitManager.getToken()) { repos in
                            DispatchQueue.main.async {
                                print("count: \(repos.count)")
                                    self.repos = repos
                            }
                        }
                    } label: {
                        Text("저장소 불러오기")
                        .foregroundStyle(isAvailable ? theme.foreground : theme.week)
                        
                        Spacer()
                    }
                    .disabled(!isAvailable)
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                    .background(theme.hilight)
                    .foregroundStyle(theme.foreground)
                    .cornerRadius(5)
                                  
                    VStack(spacing: 5) {
                        if repos.count > 0 {
                            ForEach(repos) { repo in
                                HStack {
                                    Text(repo.fullName)
                                    Spacer()
                                    if repo.id == selectedRepo?.id {
                                        Image(systemName: "checkmark")
                                    }
                                }
                                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                .background(theme.hilight2)
                                .cornerRadius(8)
                                .onTapGesture {
                                    selectedRepo = repo
                                    gitManager.setRepo(repo)
                                }
                            }
                        } else {
                            HStack {
                                Text("저장소가 없습니다.")
                                    .foregroundStyle(.gray)
                                Spacer()
                            }
                            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                        }
                        
                        Button(
                            action: {
                                gitManager.createRepository(
                                    token: gitManager.getToken(),
                                    name: "my_diary_repo",
                                    description: "Created via 'nn' app") { newRepo in
                                    DispatchQueue.main.async {
                                        if let newRepo = newRepo {
                                            self.repos.append(newRepo)
                                            selectedRepo = newRepo
                                            gitManager.setRepo(newRepo)
                                        }
                                    }
                                }
                            },
                            label: {
                                HStack {
                                    Text("새 저장소 추가")
                                        .foregroundStyle(isAvailable ? .black : .gray)
                                    Spacer()
                                }
                                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                .background(theme.hilight2)
                                .cornerRadius(8)
                            }
                        ).disabled(!isAvailable)
                    }
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                    .background(theme.hilight)
                    .cornerRadius(3)
                    
                    // Step 3
                    Text("3. 업로드할 달을 선택합니다. 아래의 버튼을 눌러 업로드하고자 하는 달을 선택합니다.")
                        .foregroundStyle(theme.week)
                    BtnSeletingMonth(month:
                                        Binding(
                                            get: {
                                                month.date
                                            }, set: { d in
                                                month = MDate(date: d)
                                            }
                                        )
                    ) {
                        isShowPopup = true
                    }
                    .background(theme.hilight)
                    .cornerRadius(5)
                    
                    // Step4
                    Text("4. 선택한 저장소에 업로드합니다. 아래의 버튼을 누르면 업로드를 진행합니다.")
                        .foregroundStyle(theme.week)
                    Button {
                        guard let selectedRepo = selectedRepo else { return }
                        // make md
                        var markdown = ""
                        if let diaries: [Diary] = DiaryServicer.shared.selectFor(viewContext, month: month.date, isAscending: true) {
                            diaries.forEach {
                                if ($0 == diaries.first) {
                                    markdown += """
                                    # \(month.date.formatted(format: "MM월"))
                                    """
                                }
                                markdown += """
                                    
                                <hr style="border: 2px solid black; margin: 20px 0;">    
                                
                                ## \($0.date ?? "")

                                \($0.note ?? "")
                                """
                            }
                        }
                        if let fileContent = markdown.data(using: .utf8) {
                            gitManager.uploadIfChanged(
                                repo: selectedRepo.fullName,
                                path: "docs/y_\(month.date.formatted(format: "yyyy"))/diary_\(month.date.formatted(format: "MM")).md",
                                newContent: fileContent,
                                message: "Update readme.md only if bytes differ"
                            )
                        }
                    } label: {
                        Text("업로드")
                            .foregroundStyle(gitManager.canUse() ? theme.foreground : theme.week)
                        
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                    .background(theme.hilight)
                    .foregroundStyle(theme.foreground)
                    .cornerRadius(5)
                    .disabled(!gitManager.canUse())
                    
//                    Button("Data restoration") {
//                        // 파일 불러오기
//                    }
//                    .foregroundStyle(theme.foreground)
                    Spacer()
                }
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
            }
            
            if isShowPopup {
                SelectingMonthPopup(
                    year: month.date.getYear(),
                    isShowPopup: $isShowPopup
                ) { mAndY in
                    month = MDate(date: mAndY)
                    isShowPopup = false
                }
            }
        }
        .background(theme.background)
        .onOpenURL { url in
        }
        .onAppear() {
            if !gitManager.getToken().isEmpty {
                isAvailable = true
            }
            gitManager.fetchRepositories(token: gitManager.getToken()) { repos in
                DispatchQueue.main.async {
                    print("count: \(repos.count)")
                    self.repos = repos
                    repos.forEach { ghr in
                        if ghr.fullName == gitManager.getRepo() {
                            selectedRepo = ghr
                        }
                    }
                }
            }
        }
    }
}



//#Preview {
//    GoogledriveView()
//}

//
//  SettingView.swift
//  nn
//
//  Created by JUNGGWAN KIM on 8/4/25.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var theme: ThemeManager
    
    @State private var pathCode: Path? = nil
    
    private struct ItemInfo: Identifiable {
        let id = UUID()
        let path : Path
        let title: String
        let img: String
    }
    
    private let itemList: [ItemInfo] = [
//        ItemInfo(code: "00",title: "알림", img: "noti_btn"),
        ItemInfo(path: Path.THEME, title: "테마", img: "theme_btn"),
//        ItemInfo(code: "02", title: "글자 스타일", img: "textstyle_btn"),
        ItemInfo(path: Path.LOCK, title: "화면 잠금", img: "lock_btn"),
        ItemInfo(path: Path.PDF, title: "pdf 내보내기", img: "pdf_btn"),
        ItemInfo(path: Path.GOOGLEDRIVE, title: "구글 드라이브 연동", img: "googledrive_btn"),
        ItemInfo(path: Path.GITHUB, title: "깃허브", img: "git_btn")
    ]
    
    var body: some View {
        VStack {
            SubHeaderView() {
                dismiss()
            }
            VStack(alignment: .leading, spacing: 10) {
                ForEach(itemList, id: \.self.id) { i in
                    SettingItemBtn(img: i.img, title: i.title) {
                        // 버튼 클릭
                        pathCode = i.path
                    }
                }
            }
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
            Spacer()
        }
        .background(theme.background)
        .fullScreenCover(
            item: $pathCode,
            onDismiss: {
                
            },
            content: { pc in
                switch pc {
                case Path.THEME:
                    ThemeSettingView(selectedTheme: theme.currentTheme)
                case Path.LOCK:
                    LockSettingView()
                case Path.PDF:
                    PdfView()
                case Path.GOOGLEDRIVE:
                    GoogledriveView()
                case Path.GITHUB:
                    GithubView()
                default:
                    ErrorView()
                }
            }
        )
    }
}

//#Preview {
//    SettingView()
//}

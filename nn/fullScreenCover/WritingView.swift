//
//  WriteView.swift
//  nn
//
//  Created by JUNGGWAN KIM on 7/25/25.
//

import SwiftUI
import CoreData
import PhotosUI

struct WritingView: View {
    @State var date: MDate
    @State private var text: String = ""
    @State private var diary: Diary? = nil
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var isPickerPresented = false
    
    @FocusState private var isFocused: Bool
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var theme: ThemeManager
    
    @StateObject var toastManager = ToastManager.shared
    private let servicer = DiaryServicer.shared
    private let managerGit = GitHubManager.shared
    
    var body: some View {
        ZStack {
            VStack {
                SubHeaderView() {
                    dismiss()
                }
                VStack {
                    Button(date.date.formatted(format: "yyyy.MM.dd EEEE")) {
                        // 날짜 선택
//                        showDatePicker.toggle()
                    }
                    .foregroundStyle(theme.week)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 20, trailing: 0))
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                    }
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $text)
                            .foregroundStyle(theme.foreground)
                            .scrollContentBackground(.hidden)
                            .background(theme.background)
                            .focused($isFocused)
                        if (text.isEmpty && !isFocused) {
                            Text("기록하기")
                                .foregroundStyle(theme.week)
                        }
                    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                .onAppear {
                    diary = servicer.search(viewContext, date: date)
                    print("[diary info]--------------------")
                    print("date: \(String(describing: diary?.date))")
                    print("note: \(String(describing: diary?.note))")
                    print("register date: \(String(describing: diary?.registrationDate))")
                    print("revision date: \(String(describing: diary?.revisionDate))")
                    print("---------------------------------")
                    if let d = diary,
                       d.registrationDate != nil {
                        if let n = d.note,
                           !n.isEmpty {
                            text = n
                        }
                    }
                }
                
                HStack(alignment: .center, spacing: 10) {
                    WritingImgButton(img: "photo_btn") {
                        if managerGit.canUse() {
                            isPickerPresented = true
                        } else {
                            ToastManager.shared.show("깃허브 연동을 해야 사용가능합니다.")
                        }
                    }
                    .opacity(managerGit.canUse() ? 1 : 0.3)
                    .photosPicker (
                        isPresented: $isPickerPresented,
                        selection: $selectedItem,
                        matching: .images
                    )
                    
                    WritingImgButton(img: "time_btn") {
                        text += "\(Date().formatted(format: "hh:mm"))"
                    }
                    Spacer()
                    if (!text.isEmpty) {
                        WritingImgButton(img: "save_btn") {
                            // 텍스트 저장
                            if let d = diary,
                               d.registrationDate != nil {
                                servicer.update(
                                    viewContext,
                                    diary: d,
                                    date: date,
                                    text: text) { isSuccess, newDiary in
                                        if isSuccess {
                                            self.diary = newDiary
                                            ToastManager.shared.show("저장 완료")
                                        } else {
                                            print("Dinary can not saved.")
                                        }
                                    }
                            } else {
                                servicer.write(
                                    viewContext,
                                    date: date,
                                    text: text
                                ) { isSuccess, newDiary in
                                        if isSuccess {
                                            self.diary = newDiary
                                            toastManager.show("작성 완료")
                                        } else {
                                            print("Dinary can not saved.")
                                        }
                                    }
                            }
                            // 이미지 저장
                            if let selectedImage,
                               managerGit.canUse(),
                               let image = selectedImage.pngData() {
//                                    managerGit.uploadFileToGitHub(repo: ㅁ, path: ㅁ, content: image)
                            }
                            // 화면 정리
                            UIApplication.shared.hideKeyboard()
                        }
                    }
                }.padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            }
            if toastManager.isVisible {
                VStack {
                    Spacer()
                    ToastView(message: toastManager.message)
                }.padding(EdgeInsets(top: 0, leading: 20, bottom: 40, trailing: 20))
            }
        }
        .background(theme.background)
        .onChange(of: selectedItem) { old, new in
            if let new {
                Task {
                    if let data = try? await new.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedImage = uiImage
                    }
                }
            }
        }
    }
}

//#Preview {
//    WritingView(date: MDate(date: Date()))
//}




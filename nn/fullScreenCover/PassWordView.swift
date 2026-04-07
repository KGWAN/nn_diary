//
//  PassWordView.swift
//  nn
//
//  Created by JUNGGWAN KIM on 8/13/25.
//

import SwiftUI

struct PassWordView: View {
    @State var checkingPassword: String = ""
    @State var tempPassword: String = ""
    @State var textGuide: String = ""
    @State var purposeCode: Int
    @State var password: String = NnUserDefaults.password
    @Binding var isSuccess: Bool
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var theme: ThemeManager
    
    private let keypad: [[String]] = [
            ["1", "2", "3"],
            ["4", "5", "6"],
            ["7", "8", "9"],
            ["", "0", "⌫"]
        ]
    private let textGuideList: [String] = [
        "설정할 비밀번호를 입력해주세요.",
        "확인을 위해 비밀번호를 한 번 더 입력해주세요.",
        "비밀번호가 일치하지 않습니다.",
        "비밀번호를 입력해주세요."
    ]
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    isSuccess = false
                    onDismiss()
                } label: {
                    Image("close_btn")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .background(theme.hilight2)
                        .cornerRadius(3)
                }
            }
            Spacer()
            Text(textGuide)
                .frame(height: 60)
                .onAppear {
                    if purposeCode == 0 {
                        textGuide = textGuideList[0]
                    } else if purposeCode == 1 {
                        textGuide = textGuideList[3]
                    }
                }
                .foregroundStyle(theme.foreground)
            HStack(
                alignment: .center,
                spacing: 20,
                content: {
                    Spacer()
                    ForEach(0..<6, id: \.self) { i in
                        Circle()
                            .fill(tempPassword.count > i ? theme.foreground : theme.week)
                            .frame(width: 20, height: 20)
                    }
                    Spacer()
                }
            )
            Spacer()
            ForEach(keypad, id: \.self) { row in
                HStack(spacing: 15) {
                    ForEach(row, id: \.self) { key in
                        Button(action: {
                            switch key {
                            case "⌫":
                                if !tempPassword.isEmpty {
                                    tempPassword.removeLast()
                                }
                            default :
                                tempPassword = tempPassword + key
                                if tempPassword.count == 6  {
                                    if purposeCode == 0 {
                                        if checkingPassword.isEmpty {
                                            textGuide = textGuideList[1]
                                            checkingPassword = tempPassword
                                            tempPassword = ""
                                        } else {
                                            if checkingPassword == tempPassword {
                                                password = checkingPassword
                                                isSuccess = true
                                                onDismiss()
                                            } else {
                                                textGuide = textGuideList[2]
                                                tempPassword = ""
                                            }
                                        }
                                    } else if purposeCode == 1 {
                                        if tempPassword == password {
                                            isSuccess = true
                                            onDismiss()
                                        } else {
                                            textGuide = textGuideList[2]
                                            tempPassword = ""
                                        }
                                    }
                                }
                            }
                        }) {
                            Text(key)
                                .font(.title)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(theme.hilight)
                                .foregroundColor(theme.foreground)
                                .cornerRadius(3)
                        }
                        .disabled(key.isEmpty) // 빈칸 비활성화
                    }
                }
            }
        }
        .padding(20)
        .background(theme.background)
    }
    
    func onDismiss() {
        print("[onSetPassword]----------")
        print("isSuccess: \(isSuccess)")
        print("password: \(password)")
        print("-------------------------")
        dismiss()
    }
}

//#Preview {
//    PassWordView()
//}

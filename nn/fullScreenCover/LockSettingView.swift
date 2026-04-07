//
//  LockSettingView.swift
//  nn
//
//  Created by JUNGGWAN KIM on 8/13/25.
//

import SwiftUI

struct LockSettingView: View {
    @State private var states: [String: Bool] = [:]
    @State private var pathCode: Path? = nil
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var theme: ThemeManager
    
    @AppStorage("password") private var password: String = ""
    
    @StateObject var toastManager = ToastManager.shared
    
    var body: some View {
        ZStack {
            VStack {
                SubHeaderView() {
                    dismiss()
                }
                VStack(spacing: 10) {
                    Text("비밀번호를 잃어버리면 찾을 수 없습니다.\n비밀번호, 생체인증을 모두 활성화시 생체인증을 우선합니다.")
                        .foregroundStyle(theme.week)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
                    ForEach(Lock.allCases, id: \.self) { option in
                        Toggle(
                            isOn: Binding(get: {
                                states[option.rawValue] ?? false
                            }, set: {
                                states[option.rawValue] = $0
                                onChangeStateOf(option)
                                
                            }),
                            label: {
                                Text(option.rawValue)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundStyle(theme.foreground)
                            }
                        )
                        .toggleStyle(SwitchToggleStyle(tint: Color.black))
                        .padding(15)
                        .background(theme.hilight)
                        .cornerRadius(5)
                        .contentShape(Rectangle())
                        .onChange(of: states[option.rawValue] ?? false) { _, newValue in
                            switch option {
                            case .PASSWORD:
                                ConfigServicer.shared.updatePw(newValue, viewContext: viewContext)
                            case .BIO:
                                ConfigServicer.shared.updateBio(newValue, viewContext: viewContext)
                            }
                        }
                    }
                }
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                .onAppear() {
                    let c = ConfigServicer.shared.search(viewContext)
                    if c == nil {
                        ConfigServicer.shared.write(viewContext)
                    }
                    Lock.allCases.forEach {
                        if c != nil {
                            switch $0 {
                            case .PASSWORD:
                                states[$0.rawValue] = c!.useYnPw == "Y"
                            case .BIO:
                                states[$0.rawValue] = c!.useYnBio == "Y"
                            }
                        }
                    }
                }
                Spacer()
            }
            if toastManager.isVisible {
                VStack {
                    Spacer()
                    ToastView(message: toastManager.message)
                }.padding(EdgeInsets(top: 0, leading: 20, bottom: 40, trailing: 20))
            }
        }
        .background(theme.background)
        .fullScreenCover(item: $pathCode) {
            
        } content: { pc in
            switch pc {
            case Path.PASSWORD:
                PassWordView(
                    purposeCode: 0,
                    isSuccess: Binding(
                        get: { states[Lock.PASSWORD.rawValue] ?? false },
                        set: { v in
                            states[Lock.PASSWORD.rawValue] = v
                        }
                    )
                )
            default:
                ErrorView()
            }
        }

    }
    
    func onChangeStateOf(_ switchType: Lock) {
        if let s = states[switchType.rawValue] {
            print("[onChangeStateOf]----------")
            print("switch: \(switchType.rawValue)")
            print("id: \(switchType.id)")
            print("state: \(s)")
            switch switchType {
            case .PASSWORD:
                if s == true {
                    pathCode = Path.PASSWORD
                } else {
                    password = ""
                }
            case .BIO:
                if s == true {
                    BioController.shared.authenticate {
                        ToastManager.shared.show("생체 인증 잠금 설정이 완료되었습니다.")
                    } onFailure: { e in
                        print(e)
                        ToastManager.shared.show("\(e)")
                        states[switchType.rawValue] = false
                    }

                }
            }
            print("---------------------------")
        } else {
            print("states 키 값이 없습니다.")
            return
        }
    }
}

//#Preview {
//    LockSettingView()
//}

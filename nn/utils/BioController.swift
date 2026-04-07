//
//  BioManager.swift
//  nn
//
//  Created by JUNGGWAN KIM on 8/20/25.
//

import Foundation
import LocalAuthentication

class BioController {
    static let shared = BioController()
    
    private let reason = "앱 접근을 위해 인증이 필요합니다."
    private let context = LAContext()
    
    // 생체 인증이 가능한지 확인
    func canEvaluate() -> Bool {
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            return true
        } else {
            // 생체 인증 불가 (Face ID, Touch ID 없음 등)
            print(error ?? "")
            return false
        }
    }
    
    func authenticate(onSuccess: @escaping () -> Void, onFailure: @escaping (LAError) -> Void){
        if canEvaluate() {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        onSuccess()
                    } else {
                        // 생체 인증 실패
                        if let e = authenticationError as? LAError {
                            onFailure(e)
                        }
                    }
                }
            }
        }
    }
}

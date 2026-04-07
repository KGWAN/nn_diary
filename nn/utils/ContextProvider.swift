//
//  ContextProvider.swift
//  nn
//
//  Created by JUNGGWAN KIM on 9/9/25.
//

import Foundation
import AuthenticationServices

class ContextProvider: NSObject, ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first!
    }
}

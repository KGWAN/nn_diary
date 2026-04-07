//
//  ExtensionUIApplication.swift
//  nn
//
//  Created by JUNGGWAN KIM on 8/8/25.
//

import Foundation
import UIKit

extension UIApplication {
    func getCurrentRootVc() -> UIViewController? {
            // keyWindow는 iOS 15 이후에도 안전하게 접근 가능
            return connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }?
                .rootViewController
        }
    
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

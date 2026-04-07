//
//  ExtensionView.swift
//  nn
//
//  Created by JUNGGWAN KIM on 9/4/25.
//

import Foundation
import SwiftUI
import SwiftUI

extension View {
    /// SwiftUI View의 실제 크기를 계산해주는 함수
        func sizeThatFits(in size: CGSize) -> CGSize {
            let controller = UIHostingController(rootView: self)
            controller.view.frame = CGRect(origin: .zero, size: size)
            return controller.sizeThatFits(in: size)
        }
}

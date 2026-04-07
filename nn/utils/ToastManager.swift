//
//  ToastManager.swift
//  nn
//
//  Created by JUNGGWAN KIM on 8/8/25.
//

import Foundation
import Combine
import SwiftUI

class ToastManager: ObservableObject {
    static let shared = ToastManager()
    @Published var message: String = ""
    @Published var isVisible: Bool = false
    
    private var timer: AnyCancellable?
    
    func show(_ message: String) {
        self.message = message
        self.isVisible = true
        print("toast message: \(message)")
        timer?.cancel()
        timer = Just(())
            .delay(for: .seconds(3), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.isVisible = false
            }
    }
}

struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .foregroundStyle(Color.black)
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            .background(Color.gray.opacity(0.7))
            .cornerRadius(5)
    }
}

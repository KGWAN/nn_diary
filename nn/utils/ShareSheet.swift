//
//  ShareSheet.swift
//  nn
//
//  Created by JUNGGWAN KIM on 9/4/25.
//

import Foundation
import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

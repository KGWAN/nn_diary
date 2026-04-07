//
//  P.swift
//  nn
//
//  Created by JUNGGWAN KIM on 9/3/25.
//

import Foundation
import UIKit
import SwiftUI

struct PDFGenerator {
    static func export(items: [Diary], itemHeight: CGFloat = 120, fileName: String) -> URL? {
        let pageSize = CGSize(width: 595, height: 842) // A4
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize))
        
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("\(fileName).pdf")
        
        // 한 페이지에 들어갈 수 있는 최대 아이템 개수
        let availableHeight: CGFloat = pageSize.height - 100 // 상단 타이틀/여백 빼고
        let itemsPerPage = Int(floor(availableHeight / itemHeight))
        
        do {
            try renderer.writePDF(to: url) { context in
                // items를 페이지 단위로 자르기
                let chunked = stride(from: 0, to: items.count, by: itemsPerPage).map {
                    Array(items[$0..<min($0 + itemsPerPage, items.count)])
                }
                
                for (index, pageItems) in chunked.enumerated() {
                    context.beginPage()
                    
                    let hostingController = UIHostingController(
                        rootView: DiaryPageTempleteView(pageNumber: index + 1, diaries: pageItems)
                    )
                    hostingController.view.frame = CGRect(origin: .zero, size: pageSize)
                    
                    hostingController.view.layer.render(in: context.cgContext)
                }
            }
            return url
        } catch {
            print("PDF 생성 실패:", error)
            return nil
        }
    }
}

struct MultiPagePDFGenerator {
    static func export(items: [Diary], fileName: String) -> URL? {
        let pageSize = CGSize(width: 595, height: 842) // A4
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize))
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("\(fileName).pdf")
        
        // 한 페이지에 들어갈 수 있는 최대 아이템 개수
        let sampleView = DiaryTempleteView(date: items.first?.date ?? "2020-01-01(sample)", note: items.first?.note ?? "sample date")
        let itemSize = sampleView.sizeThatFits(in: CGSize(width: pageSize.width, height: .greatestFiniteMagnitude))
        
        let availableHeight: CGFloat = pageSize.height
        let itemsPerPage = Int(floor(availableHeight / itemSize.height))
        
        do {
            try renderer.writePDF(to: url) { context in
                // items를 페이지 단위로 자르기
                let chunked = stride(from: 0, to: items.count, by: itemsPerPage).map {
                    Array(items[$0..<min($0 + itemsPerPage, items.count)])
                }
                
                for (index, pageItems) in chunked.enumerated() {
                    context.beginPage()
                    
                    let hostingController = UIHostingController(
                        rootView: DiaryPageTempleteView(pageNumber: index + 1, diaries: pageItems)
                    )
                    hostingController.view.frame = CGRect(origin: .zero, size: pageSize)
                    hostingController.view.drawHierarchy(in: hostingController.view.bounds, afterScreenUpdates: true)
                }
            }
            return url
        } catch {
            print("PDF 생성 실패:", error)
            return nil
        }
    }
}

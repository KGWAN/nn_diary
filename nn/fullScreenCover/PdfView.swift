//
//  PdfView.swift
//  nn
//
//  Created by JUNGGWAN KIM on 8/25/25.
//

import SwiftUI

struct PdfView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var theme: ThemeManager
    
    @State private var pdfURL: URL?
    @State private var showShare = false
    @State var month: MDate = MDate(date: Date())
    @State var isShowPopup: Bool = false
    @State var diaries: [Diary]? = nil
    @State var isShowPreview: Bool = false
    
    
    var body: some View {
        ZStack {
            VStack() {
                SubHeaderView() {
                    dismiss()
                }
                VStack(alignment: .leading, spacing: 20) {
                    BtnSeletingMonth(month:
                        Binding(
                            get: {
                                month.date
                            }, set: { d in
                                month = MDate(date: d)
                            }
                        )
                    ) {
                        isShowPopup = true
                    }
                    Button(
                        action: {
                            // pdf 내보내기
                            if let items = diaries {
                                if let url = MultiPagePDFGenerator.export(
                                    items: items,
                                    fileName: "\(month.date.formatted(format: "yyyyMM"))_diaries"
                                ) {
                                    pdfURL = url
                                    showShare = true
                                }
                            }
                            
                        }, label: {
                            HStack {
                                Text("선택된 달에 작성된 일기: \(diaries?.count ?? 0)개")
                                    .foregroundColor(theme.foreground)
                                Spacer()
                                Image("pdf_output_btn")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            }
                        }
                    )
                    Text("선택된 월의 일기를 pdf로 변환해 저장할 수 있어요.")
                        .foregroundStyle(theme.week)
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 20))
                    Button {
                        // 미리보기 팝업
                        isShowPreview = true
                    } label: {
                        Text("미리보기")
                            .padding(8)
                            .cornerRadius(5)
                            .foregroundStyle(theme.foreground)
                            .background(theme.hilight)
                    }

                    Spacer()
                }.padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
            }
            
            if isShowPopup {
                SelectingMonthPopup(
                    year: month.date.getYear(),
                    isShowPopup: $isShowPopup
                ) { mAndY in
                    month = MDate(date: mAndY)
                    isShowPopup = false
                }
            }
            
            if isShowPreview {
                PreviewPdfPopup(pageNumber: 0, diaries: diaries ?? [], isShowPreview: $isShowPreview)
            }
        }
        .background(theme.background)
        .onAppear() {
            diaries = DiaryServicer.shared.selectFor(viewContext, month: month.date)
        }
        .onChange(of: month.date) { old, new in
            diaries = DiaryServicer.shared.selectFor(viewContext, month: month.date)
        }
        .sheet(isPresented: $showShare) {
            if let pdfURL {
                ShareSheet(items: [pdfURL])
            }
        }
    }
}



//#Preview {
//    PdfView()
//}

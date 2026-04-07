import SwiftUI

struct DropdownButton: View {
    @Binding var selectedItem: String
    let items: [String]
    let isFirstItemSelected: Bool

    @State private var isExpanded = false
    
    @EnvironmentObject var theme: ThemeManager

    var body: some View {
        VStack(alignment: .trailing, spacing: 3) {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack(alignment: .center) {
                    Text(selectedItem.isEmpty ? "항목 선택" : selectedItem)
                        .foregroundColor(theme.foreground)
                    if let img = UIImage(named: "dropdown_btn")?.rotated(by: !isExpanded ? 0 : 180) {
                        Image(uiImage: img)
                            .resizable()
                            .frame(width: 15, height: 15)
                            .background(theme.hilight2)
                            .cornerRadius(15/2)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
            }
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            .frame(maxWidth: 100, maxHeight: 30)

            if isExpanded {
                VStack(spacing: 0) {
                    ForEach(items, id: \.self) { item in
                        Button(action: {
                            selectedItem = item
                            isExpanded = false
                        }) {
                            Text(item)
                                .foregroundStyle(theme.background)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .overlay(
                            item != items.last ?
                            Rectangle()
                                .frame(height: 1) // 선 두께
                                .foregroundColor(theme.background) // 선 색상
                                .padding(.top, nil) // 위 여백 제거
                                .padding(.bottom, 0) // 아래쪽에 붙이기
                            : nil,
                            alignment: .bottom // 아래쪽에 정렬
                        )
                    }
                }
                .frame(width: 200)
                .background(theme.foreground)
                .cornerRadius(10)
            }
        }
        .onAppear() {
            if isFirstItemSelected,
                let first = items.first {
                selectedItem = first
            }
        }
    }
}

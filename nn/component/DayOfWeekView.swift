//
//  DayOfWeekView.swift
//  nn
//
//  Created by JUNGGWAN KIM on 7/23/25.
//

import SwiftUI

struct DayOfWeekView: View {
    let titles = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            ForEach(titles, id: \.self) { t in
                Text(t)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.gray)
            }
        }.frame(height: 30)
    }
}

#Preview {
    DayOfWeekView()
}

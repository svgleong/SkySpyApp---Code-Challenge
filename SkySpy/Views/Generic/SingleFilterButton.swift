//
//  SingleFilterButton.swift
//  SkySpy
//
//  Created by SofiaLeong on 04/05/2025.
//

import SwiftUI

struct SingleFilterButton: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .foregroundStyle(isSelected ? .white : color)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(isSelected ? color : color.opacity(0.2))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color, lineWidth: isSelected ? 2 : 1)
                )
        }
    }
}

#Preview {
    SingleFilterButton(title: "Filter 1", isSelected: true, color: .pink) {
        print("Filtered")
    }
}

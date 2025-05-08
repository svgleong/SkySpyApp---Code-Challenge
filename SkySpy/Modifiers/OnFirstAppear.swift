//
//  OnFirstAppear.swift
//  SkySpy
//
//  Created by SofiaLeong on 02/05/2025.
//

import SwiftUI

struct OnFirstAppear: ViewModifier {

    let action: () -> Void

    @State private var hasAppeared = false

    func body(content: Content) -> some View {
        content.onAppear {
            guard !hasAppeared else { return }
            hasAppeared = true
            action()
        }
    }
}

extension View {
    public func onFirstAppear(_ action: @escaping () -> Void) -> some View {
        modifier(OnFirstAppear(action: action))
    }
}

#Preview {
    Text("Welcome to SkySpy")
        .onFirstAppear { print("Executed onFirstAppear action") }
}

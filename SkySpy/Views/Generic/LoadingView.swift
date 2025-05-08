//
//  LoadingView.swift
//  SkySpy
//
//  Created by SofiaLeong on 01/05/2025.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .controlSize(.large)
    }
}

#Preview {
    LoadingView()
}

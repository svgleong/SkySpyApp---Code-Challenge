//
//  CachedWarningView.swift
//  SkySpy
//
//  Created by SofiaLeong on 04/05/2025.
//

import SwiftUI

struct CachedWarningView: View {
    let retryAction: () -> Void
    
    var body: some View {
        VStack {
            HStack() {
                Image(systemName: "exclamationmark.triangle")
                Text("Connection failed. Showing latest saved update.")
            }
            .foregroundStyle(.white)
            
            Button(action: {
                retryAction()
            }) {
                Text("Retry")
                    .font(.headline)
                    .padding(4)
                    .background(Color.white)
                    .cornerRadius(8)
            }
            .foregroundStyle(.gray)
        }
    }
}

#Preview {
    CachedWarningView {
        print("Retry triggered")
    }
    .background(.blue)
}

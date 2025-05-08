//
//  FailureView.swift
//  SkySpy
//
//  Created by SofiaLeong on 03/05/2025.
//

import SwiftUI

struct FailureView: View {
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            
            Text("Failed to load data")
                .font(.headline)
            
            Text("Please check your internet connection and try again.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: {
                retryAction()
            }) {
                Text("Retry")
                    .font(.headline)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(8)
            }
        }
        .padding()
        .foregroundStyle(.white)
    }
}

#Preview {
    FailureView {
        print("Retry triggered")
    }
    .background(.blue)
}

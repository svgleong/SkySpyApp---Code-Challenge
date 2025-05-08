//
//  MapButtonView.swift
//  SkySpy
//
//  Created by SofiaLeong on 06/05/2025.
//

import SwiftUI

protocol MapButtonViewModelRepresentable: ObservableObject {
    var mapButtonTitle: String { get set }

    func mapButtonPressed()
}

struct MapButtonView: View {

    @ObservedObject var viewModel: FlightsInfoViewModel

    var body: some View {
        VStack {
            Button {
                viewModel.mapButtonPressed()
            } label: {
                HStack {
                    Image(systemName: "map")
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text(viewModel.mapButtonTitle)
                        .font(.headline)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    ZStack {
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .cornerRadius(25)
                        RoundedRectangle(
                            cornerRadius: 25,
                            style: .continuous
                        )
                        .stroke(Color.blue, lineWidth: 1)
                    }
                )
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            }
            .padding(.bottom, 20)
        }
    }
}

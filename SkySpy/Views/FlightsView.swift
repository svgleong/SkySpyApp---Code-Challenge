//
//  FlightsView.swift
//  SkySpy
//
//  Created by SofiaLeong on 02/05/2025.
//

import SwiftUI

struct FlightsView: View {
    @ObservedObject private var viewModel: FlightsViewModel
    
    init(viewModel: FlightsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .orange]), startPoint: .top, endPoint: .bottom)
                    .opacity(0.6)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    switch viewModel.state {
                    case .loading:
                        LoadingView()
                    case .success, .cachedFailure:
                        if viewModel.isCached {
                            CachedWarningView { viewModel.reloadAction() }
                        }
                        FlightsInfoView(viewModel: viewModel.flightsInfoViewModel)
                    case .failure:
                        FailureView { viewModel.reloadAction() }
                    }
                }
                .background(.clear)
                .padding(16)
            }
        }
        .onFirstAppear {
            Task {
                await viewModel.loadData()
            }
        }
    }
}

#Preview {
    var client: APIClient { APIClient(session: URLSession.shared) }
    var service: AviationStackService { AviationStackService(client: client) }
    var viewModel: FlightsViewModel { FlightsViewModel(airline: "TAP", dependencies: .init(service: service, saveFlights: FlightDataRepository())) }
    FlightsView(viewModel: viewModel)
}


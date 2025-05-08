//
//  SkySpyView.swift
//  SkySpy
//
//  Created by SofiaLeong on 30/04/2025.
//

import SwiftUI

struct SkySpyView: View {
    @ObservedObject private var viewModel: SkySpyViewModel
    
    init(viewModel: SkySpyViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .orange]), startPoint: .top, endPoint: .bottom)
                    .opacity(0.6)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    header

                    searchBar
                    
                    switch viewModel.state {
                    case .loading:
                        LoadingView()
                    case .success, .cachedFailure:
                        if viewModel.isCached {
                            CachedWarningView { viewModel.reloadAction() }
                        }
                        AirlinesView(viewModel: viewModel.airlinesViewModel)
                    case .failure:
                        FailureView { viewModel.reloadAction() }
                    }
                }
                .padding(16)
            }
        }
        .onFirstAppear {
            Task {
                await viewModel.loadData()
            }
        }
    }
    
    var header: some View {
        Group {
            Text("✈️ SkySpy")
                .font(.largeTitle)
            Text("Helping you spy your favorite airlines")
                .font(.title3)
        }
    }
    
    var searchBar: some View {
        HStack {
            TextField("Search for an airline", text: $viewModel.searchText)
                .foregroundStyle(.gray)
                .padding(10)
                .background(Color.white.opacity(0.8))
                .cornerRadius(30)
                .onSubmit {
                    viewModel.filterAirlines()
                }
            
            
            Button {
                viewModel.clearSearch()
            } label: {
                Image(systemName: "x.circle.fill")
            }
            .foregroundStyle(.white)

            Button {
                viewModel.reloadAction()
            } label: {
                Image(systemName: "arrow.counterclockwise.circle")
            }
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    var client: APIClient { APIClient(session: URLSession.shared) }
    var service: AviationStackService { AviationStackService(client: client) }
    var viewModel: SkySpyViewModel { SkySpyViewModel(service: service) }
    SkySpyView(viewModel: viewModel)
}

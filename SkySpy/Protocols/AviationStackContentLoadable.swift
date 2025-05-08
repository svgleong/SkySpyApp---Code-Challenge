//
//  AviationStackContentLoadable.swift
//  SkySpy
//
//  Created by SofiaLeong on 04/05/2025.
//

import Foundation

enum LoadableState {
    case loading
    case failure
    case success
    case cachedFailure
}

protocol AviationStackContentLoadable: ObservableObject {
    associatedtype DataType
    associatedtype APIModel
    
    var state: LoadableState { get set }
    var isCached: Bool { get set }

    func fetchData() async
    func loadCachedData() -> [DataType]
    func reloadAction()
    
    @MainActor func handleSuccess(model: APIModel)
    @MainActor func handleCachedFailure(model: [DataType])
    @MainActor func handleFailure()
}

extension AviationStackContentLoadable {
    @MainActor
    func loadData() async {
        state = .loading
        await fetchData()
    }
    
    @MainActor
    func handleCachedFailure(model: [DataType]) {
        state = .cachedFailure
        isCached = true
    }

    @MainActor
    func handleFailure() {
        state = .failure
    }

    func reloadAction() {
        Task {
            await fetchData()
        }
    }
}

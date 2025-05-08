//
//  SkySpyApp.swift
//  SkySpy
//
//  Created by SofiaLeong on 30/04/2025.
//

import SwiftUI

@main
struct SkySpyApp: App {
    
    let moc = DataController.shared.container.viewContext
    var client: APIClient { APIClient(session: URLSession.shared) }
    var service: AviationStackService { AviationStackService(client: client) }
    var viewModel: SkySpyViewModel { SkySpyViewModel(service: service) }
    
    var body: some Scene {
        WindowGroup {
            SkySpyView(viewModel: viewModel)
                .environment(\.managedObjectContext, moc)
        }
    }
}

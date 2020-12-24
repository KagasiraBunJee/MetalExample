//
//  ProjectExamplesApp.swift
//  Shared
//
//  Created by Sergii Polishchuk on 21.12.2020.
//

import SwiftUI

@main
struct ProjectExamplesApp: App {
//    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MetalView()
                .frame(width: 414, height: 718)
//            MainView()
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

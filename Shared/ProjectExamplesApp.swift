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
            MainView()
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

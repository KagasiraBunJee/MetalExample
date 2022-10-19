//
//  MainView.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 21.12.2020.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel = ListViewModel()
    @State private var pushedView: Int? = 0
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink("MetalDefault", destination: DefaultMetalPreview())
                GeometryReader { geometry in
                    VideoRenderView()
                        .frame(width: geometry.size.width, height: 200)
                }
                Button("Open app") {
                    UIApplication.shared.openURL(URL(string: "com.smartsuite://")!)
                }
            }
            .navigationTitle("Some Title")
        }
        .onAppear(perform: {
//            let appearance = UINavigationBarAppearance()
//            appearance.configureWithTransparentBackground()
//            appearance.backgroundImage = UIImage(named: "subheader")
//            appearance.backgroundImageContentMode = .scaleAspectFit
//            viewModel.fetchItems()

        })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

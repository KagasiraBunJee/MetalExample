//
//  DefaultMetalPreview.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 23.12.2020.
//

import SwiftUI

struct DefaultMetalPreview: View {
    var body: some View {
        GeometryReader { geometry in
            MetalView()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .navigationTitle("Default render")
        }
    }
}

struct DefaultMetalPreview_Previews: PreviewProvider {
    static var previews: some View {
        DefaultMetalPreview()
    }
}

//
//  DefaultMetalPreview.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 23.12.2020.
//

import SwiftUI

struct DefaultMetalPreview: View {
    
    var body: some View {
        MetalView()
            .navigationTitle("Default render")
    }
}

struct DefaultMetalPreview_Previews: PreviewProvider {
    static var previews: some View {
        DefaultMetalPreview()
    }
}

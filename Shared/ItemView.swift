//
//  ItemView.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 21.12.2020.
//

import SwiftUI

struct ItemView: View {
    
    var item: String
    
    var body: some View {
        Text(item)
            .navigationTitle(item)
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView(item: "test")
    }
}

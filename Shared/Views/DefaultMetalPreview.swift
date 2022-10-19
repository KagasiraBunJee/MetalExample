//
//  DefaultMetalPreview.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 23.12.2020.
//

import SwiftUI

struct DefaultMetalPreview: View {
    
    @State var renderer: Renderer? = nil
    @State var selectedNode: Node? = nil
    
    let screenWidth = UIScreen.main.bounds.width ?? 10
    let screenHeight = UIScreen.main.bounds.height ?? 10
    
    var body: some View {
        ZStack {
            MetalView(renderer: $renderer)
            VStack {
                HStack(alignment: .top) {
                    List(getNodes(from: renderer), id: \.self) { item in
                        Button(item, action: {
//                            selectedNode = item
//                            debugPrint(item.position, item.objectMatrix)
                        })
                    }
                    .frame(width: 100)
                    Spacer()
                    Menu("View mode") {
                        Button ("Normal") {
                            Engine.viewMode = .fill
                        }
                        
                        Button ("Wireframe") {
                            Engine.viewMode = .lines
                        }
                    }
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                    .offset(x: -10, y: 10)
                }
                Spacer()
            }
            if (selectedNode != nil) {
                GeometryReader { geo in
                    getInfo(node: selectedNode!, size: geo.size)
                }
            }
        }
        .navigationTitle("Default render")
    }
    
    func getNodes(from renderer: Renderer?) -> [String] {
        guard let scene = renderer?.scene.root else {
            return []
        }
        
        let arr = scene.children.compactMap { cycleNodes(node: $0)
        }.flatMap { $0 }
        
        return [scene.name] + arr
    }
    
    func cycleNodes(node: Node, level: Int = 1) -> [String] {
        let lines = Array(repeating: "-", count: level).joined()
        if (node.children.count > 0) {
            let result = node.children.map { cycleNodes(node: $0, level: level + 1) }
            return [String(format: "%@ %@", lines, node.name)] + result.flatMap { $0 }
        }
        return [String(format: "%@ %@", lines, node.name)]
    }
    
    func getInfo(node: Node, size: CGSize) -> some View {
       
        let xPos = (size.width / 2) * (CGFloat(node.position.x) + 1)
        let yPos = (size.height / 2) * (CGFloat(node.position.y) + 1)
        return Text(node.name)
            .position(x: xPos, y: yPos)
            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
    }
}

struct DefaultMetalPreview_Previews: PreviewProvider {
    static var previews: some View {
        DefaultMetalPreview()
    }
}

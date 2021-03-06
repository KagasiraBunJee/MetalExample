//
//  MetalView.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 21.12.2020.
//

import MetalKit
import SwiftUI
import AVFoundation

struct MetalView {
    
    class Coordinator: NSObject, VideoPlaybackDelegate {
        var parent: MetalView
        let renderer: Renderer
        
        init(parent: MetalView, scaleRatio: Float) {
            self.parent = parent
            self.renderer = Renderer(device: Engine.device, screenAspectRatio: scaleRatio)
            self.renderer.scene.camera.origin = [0, 0, 3]
            self.renderer.scene.root.addChild(node:
//                ControllableNode(renderer: renderer)
//                InstancedPawns(cubesWide: 10, cubesHigh: 10, cubesBack: 10)
                                                CustomMesh()
            )
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self, scaleRatio: 1)
    }
}

#if os(iOS)
extension MetalView: UIViewRepresentable {
    typealias UIViewType = MetalCustomView

    func makeUIView(context: Context) -> MetalCustomView {
        let view = MetalCustomView(frame: .zero, device: nil)
        view.delegate = context.coordinator.renderer
        context.coordinator.renderer.aspectRatio = Float(view.contentScaleFactor)
        return view
    }

    func updateUIView(_ uiView: MetalCustomView, context: Context) {}
}
#else
extension MetalView: NSViewRepresentable {
    typealias NSViewType = MetalCustomView
    
    func makeNSView(context: Context) -> MetalCustomView {
        let view = MetalCustomView(frame: .zero, device: nil)
        view.delegate = context.coordinator.renderer
        return view
    }
    
    func updateNSView(_ nsView: MetalCustomView, context: Context) {}
}
#endif

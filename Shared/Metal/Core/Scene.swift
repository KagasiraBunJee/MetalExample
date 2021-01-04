//
//  Scene.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 04.01.2021.
//

import MetalKit

class RendererScene: Renderable, Updatable {
    let root = Node()
    var camera = MainCamera(origin: [0, 0, 0],
                            look: [0, 0, -1],
                            up: [0, 1, 0],
                            fovYDegrees: 45,
                            aspectRatio: 1.0,
                            zNear: 0.001,
                            zFar: 1000.0)
    var sceneMatrix = matrix_identity_float4x4
    
    var clearColor: MTLClearColor = .from(.blue)
    
    func update(time: Float) {
        root.update(time: time)
    }
    
    func render(time: Float,
                renderer: Renderer,
                encoder: MTLRenderCommandEncoder,
                parentTransform: matrix_float4x4)
    {
        root.render(time: time, renderer: renderer, encoder: encoder, parentTransform: sceneMatrix)
    }
}

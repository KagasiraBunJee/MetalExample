//
//  Scene.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 04.01.2021.
//

import MetalKit

class RendererScene: Renderable, Updatable {
    let root = Node()
    var camera = MainCamera(origin: [0, 1, 3],
                            look: [0, 0, -1],
                            up: [0, 1, 0],
                            fovYDegrees: 60,
                            aspectRatio: 1.0,
                            zNear: 0.001,
                            zFar: 1000.0)
    var sceneMatrix = matrix_identity_float4x4
    var clearColor: MTLClearColor = .from(.blue)
    
    init() {
        root.name = "Root"
    }
    
    func update(time: Float) {
        root.update(time: time)
    }
    
    func render(time: Float,
                renderer: Renderer,
                encoder: MTLRenderCommandEncoder,
                parentTransform: matrix_float4x4)
    {
        let velocity: Float = 20
        Engine.GameTime.updateTime(deltaTime: time)
//        root.rotation *= simd_quatf(angle: Float(15).radians * time, axis: [0.5, 1, 0])
//        root.rotation *= simd_quatf(angle: Float(15).radians * time, axis: [Float(Engine.Input.mouseDeltaLocation.y) * time, Float(Engine.Input.mouseDeltaLocation.x) * time, 0])
//        root.rotation.x += Float(Engine.Input.mouseDeltaLocation.y) * time
//        root.rotation.y += Float(Engine.Input.mouseDeltaLocation.x) * time
        if Engine.Input.movementType == .rotate {
            camera.look.x += Float(Engine.Input.mouseDeltaLocation.x) * time
            camera.look.y += Float(Engine.Input.mouseDeltaLocation.y) * time
        } else {
            camera.origin.x -= Float(Engine.Input.mouseDeltaLocation.x) * time
            camera.origin.y += Float(Engine.Input.mouseDeltaLocation.y) * time
        }
        root.position.z = Engine.Input.zoomValue
        root.render(time: time, renderer: renderer, encoder: encoder, parentTransform: sceneMatrix)
    }
}

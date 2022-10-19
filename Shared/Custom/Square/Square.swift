//
//  Square.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 06.07.2021.
//

import Foundation
import MetalKit

class Square: Node {
    
    init() {
        super.init(object: SquareObject())
        name = "Square"
    }
    
    override func createRenderPipelineState() {
        guard object != nil else { return }
        let library = Engine.device?.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "waves_vertex_shader")
        let fragmentFunction = library?.makeFunction(name: "waves_fragment_shader")
        
        let renderPipelineStateDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineStateDescriptor.vertexFunction = vertexFunction
        renderPipelineStateDescriptor.fragmentFunction = fragmentFunction
        renderPipelineStateDescriptor.vertexDescriptor = object?.vertexDescriptor
        renderPipelineStateDescriptor.depthAttachmentPixelFormat = .depth32Float
        
        do {
            pipelineState = try Engine.device?.makeRenderPipelineState(descriptor: renderPipelineStateDescriptor)
            debugPrint("success pipelineState")
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
}

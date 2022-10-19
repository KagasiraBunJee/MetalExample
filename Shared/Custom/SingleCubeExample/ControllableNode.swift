//
//  ControllableNode.swift
//  ProjectExamples
//
//  Created by Sergei on 1/4/21.
//

import MetalKit
import simd
#if os(macOS)
import AppKit
#endif

class ControllableNode: Node {
    
    enum MoveDirection: UInt16 {
        case none = 0x0
        case up = 0x7E
        case down = 0x7D
        case left = 0x7B
        case right = 0x7C
    }
    
    private let renderer: Renderer
    private var vidTexSource: VideoTexture?
    
    var cubes: [CubeObject] = []
    
    var moveDir: MoveDirection = .none
    var rotate: Bool = false
    
    init(renderer: Renderer) {
        self.renderer = renderer
        super.init(object: CubeObject())
        generateCubes()
        vidTexSource = VideoTexture(videoUrl: Bundle.main.url(forResource: "videoplayback", withExtension: "mp4")!)
        vidTexSource?.play(repeat: true)
//        event = NSEvent.addLocalMonitorForEvents(matching: [.keyDown, .leftMouseDragged, .keyUp]) { [weak self] (event) -> NSEvent? in
//            if event.type == .keyDown || event.type == .keyUp {
//                if let dir = MoveDirection(rawValue: event.keyCode), event.type == .keyDown {
//                    self?.moveDir = dir
//                } else {
//                    self?.moveDir = .none
//                }
//            } else if event.type == .leftMouseDragged {
//                debugPrint(event)
//            }
//
//            return event
//        }
    }
    
    private func generateCubes() {
        let cubesLength = 12
        let cubesInColumns = 3
        for i in -6..<cubesLength/2 {
            let subNode = Node()
            subNode.position.x = Float(i % cubesInColumns) * (subNode.scale.x * 2)
            subNode.position.y = floor(Float(-i)/Float(cubesInColumns)) * (subNode.scale.y * 2)
            let cube = CubeObject()
            cubes.append(cube)
            subNode.object = cube
            addChild(node: subNode)
        }
    }
    
    override func render(time: Float,
                         renderer: Renderer,
                         encoder: MTLRenderCommandEncoder,
                         parentTransform: matrix_float4x4) {
        let velocity: Float = 3.0
        let changingValue = velocity*time
        switch moveDir {
        case .up:
            position.y += changingValue
        case .down:
            position.y -= changingValue
        case .left:
            position.x -= changingValue
        case .right:
            position.x += changingValue
        default: break
        }
        if let vidTexture = vidTexSource?.createTexture(hostTime: nil) {
            object?.material?.texture = vidTexture
        }
        super.render(time: time, renderer: renderer, encoder: encoder, parentTransform: parentTransform)
    }
}

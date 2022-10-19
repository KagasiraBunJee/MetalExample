//
//  MetalDefaultView.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 23.12.2020.
//

import MetalKit

class MetalCustomView: MTKView {
    
    private var nsEvents: Any?
    
    var vertexBuffer: MTLBuffer?
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame frameRect: CGRect, device: MTLDevice?) {
        super.init(frame: frameRect, device: device ?? MTLCreateSystemDefaultDevice())
        prepare()
    }
    
    private func prepare() {
        self.framebufferOnly = false
        self.device = Engine.device
        self.colorPixelFormat = .bgra8Unorm
        self.depthStencilPixelFormat = .depth32Float
        self.clearColor = .from(.orange)
        
        #if os(macOS)
        let mask: NSEvent.EventTypeMask = [
            .leftMouseDragged,
            .leftMouseDown,
            .scrollWheel,
            .leftMouseUp,
            .keyUp
        ]
        nsEvents = NSEvent.addLocalMonitorForEvents(matching: mask) { (event) -> NSEvent? in
            switch event.type {
            case .leftMouseUp:
                Engine.Input.mouseDeltaLocation = .zero
            case .leftMouseDragged:
                if event.modifierFlags.intersection(.deviceIndependentFlagsMask).contains(.shift) {
                    Engine.Input.movementType = .rotate
                } else {
                    Engine.Input.movementType = .translate
                }
                Engine.Input.mouseLocation = event.locationInWindow
                Engine.Input.mouseDeltaLocation = CGPoint(x: event.locationInWindow.x - Engine.Input.previousMouseLoc.x,
                                             y: event.locationInWindow.y - Engine.Input.previousMouseLoc.y)
            case .leftMouseDown:
                Engine.Input.previousMouseLoc = event.locationInWindow
            case .scrollWheel:
                if event.modifierFlags.intersection(.deviceIndependentFlagsMask).contains(.shift) {
                    Engine.Input.movementType = .rotate
                } else {
                    Engine.Input.movementType = .translate
                }
                Engine.Input.mouseDeltaLocation = CGPoint(x: event.scrollingDeltaX, y: event.scrollingDeltaY)
                debugPrint(event.scrollingDeltaX, event.scrollingDeltaY)
            case .keyUp:
                if event.modifierFlags.intersection(.deviceIndependentFlagsMask).contains(.shift) {
                    if event.keyCode == Keycode.equals {
                        Engine.Input.zoomValue += 0.1
                    } else if event.keyCode == Keycode.minus {
                        Engine.Input.zoomValue -= 0.1
                    }
                }
            default: break
            }
            return event
        }
        #else
        return
        #endif
    }
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if touches.count == 1 {
//            
//        }
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        
//    }
}

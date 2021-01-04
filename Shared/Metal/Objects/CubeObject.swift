//
//  CubeObject.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 24.12.2020.
//

import MetalKit
import VideoToolbox

class CubeObject: GameObject {
    
    static var sideColors: [simd_float4] = [
        // left
        simd_float4(.random, 1),
        
        // right
        simd_float4(.random, 1),
        
        // top
        simd_float4(.random, 1),
        
        // bottom
        simd_float4(.random, 1),
        
        // front
        simd_float4(.random, 1),
        
        // back
        simd_float4(.random, 1),
    ]
    
    static var cubeVertecies = [
        // Left
//        Vertex(position: simd_float3(-1, -1, -1), color: CubeObject.sideColors[0]),
//        Vertex(position: simd_float3(-1, -1, 1), color: CubeObject.sideColors[0]),
        Vertex(position: simd_float3(-1, -0.3, -1), color: CubeObject.sideColors[0]),
        Vertex(position: simd_float3(-1, -0.3, 1), color: CubeObject.sideColors[0]),
        Vertex(position: simd_float3(-1, 1, 1), color: CubeObject.sideColors[0]),
//        Vertex(position: simd_float3(-1, -1, -1), color: CubeObject.sideColors[0]),
        Vertex(position: simd_float3(-1, -0.3, -1), color: CubeObject.sideColors[0]),
        Vertex(position: simd_float3(-1, 1, 1), color: CubeObject.sideColors[0]),
        Vertex(position: simd_float3(-1, 1, -1), color: CubeObject.sideColors[0]),
        
        // Right
        Vertex(position: simd_float3(1, 1, 1), color: CubeObject.sideColors[1]),
//        Vertex(position: simd_float3(1, -1, -1), color: CubeObject.sideColors[1]),
        Vertex(position: simd_float3(1, -0.3, -1), color: CubeObject.sideColors[1]),
        Vertex(position: simd_float3(1, 1, -1), color: CubeObject.sideColors[1]),
//        Vertex(position: simd_float3(1, -1, -1), color: CubeObject.sideColors[1]),
        Vertex(position: simd_float3(1, -0.3, -1), color: CubeObject.sideColors[1]),
        Vertex(position: simd_float3(1, 1, 1), color: CubeObject.sideColors[1]),
//        Vertex(position: simd_float3(1, -1, 1), color: CubeObject.sideColors[1]),
        Vertex(position: simd_float3(1, -0.3, 1), color: CubeObject.sideColors[1]),
        
        // Top
        Vertex(position: simd_float3(1, 1, 1), color: CubeObject.sideColors[2]),
        Vertex(position: simd_float3(1, 1, -1), color: CubeObject.sideColors[2]),
        Vertex(position: simd_float3(-1, 1, -1), color: CubeObject.sideColors[2]),
        Vertex(position: simd_float3(1, 1, 1), color: CubeObject.sideColors[2]),
        Vertex(position: simd_float3(-1, 1, -1), color: CubeObject.sideColors[2]),
        Vertex(position: simd_float3(-1, 1, 1), color: CubeObject.sideColors[2]),
        
        // Bottom
        Vertex(position: simd_float3(1, -0.3, 1), color: CubeObject.sideColors[3]),
        Vertex(position: simd_float3(-1, -0.3, -1), color: CubeObject.sideColors[3]),
        Vertex(position: simd_float3(1, -0.3, -1), color: CubeObject.sideColors[3]),
        Vertex(position: simd_float3(1, -0.3, 1), color: CubeObject.sideColors[3]),
        Vertex(position: simd_float3(-1, -0.3, 1), color: CubeObject.sideColors[3]),
        Vertex(position: simd_float3(-1, -0.3, -1), color: CubeObject.sideColors[3]),
        
        // Back
        Vertex(position: simd_float3(1, 1, -1), color: CubeObject.sideColors[4]),
//        Vertex(position: simd_float3(-1, -1, -1), color: CubeObject.sideColors[4]),
        Vertex(position: simd_float3(-1, -0.3, -1), color: CubeObject.sideColors[4]),
        Vertex(position: simd_float3(-1, 1, -1), color: CubeObject.sideColors[4]),
        Vertex(position: simd_float3(1, 1, -1), color: CubeObject.sideColors[4]),
//        Vertex(position: simd_float3(1, -1, -1), color: CubeObject.sideColors[4]),
        Vertex(position: simd_float3(1, -0.3, -1), color: CubeObject.sideColors[4]),
//        Vertex(position: simd_float3(-1, -1, -1), color: CubeObject.sideColors[4]),
        Vertex(position: simd_float3(-1, -0.3, -1), color: CubeObject.sideColors[4]),
        
        // Front
        Vertex(position: simd_float3(1, 1, 1), color: CubeObject.sideColors[5], texCoord: simd_float2(0, 1)),
        Vertex(position: simd_float3(-1, 1, 1), color: CubeObject.sideColors[5], texCoord: simd_float2(1, 1)),
        Vertex(position: simd_float3(-1, -0.3, 1), color: CubeObject.sideColors[5], texCoord: simd_float2(1, 0)),
        
        Vertex(position: simd_float3(1, 1, 1), color: CubeObject.sideColors[5], texCoord: simd_float2(0, 1)),
        Vertex(position: simd_float3(-1, -0.3, 1), color: CubeObject.sideColors[5], texCoord: simd_float2(1, 0)),
        Vertex(position: simd_float3(1, -0.3, 1), color: CubeObject.sideColors[5], texCoord: simd_float2(0, 0)),
//        Vertex(position: simd_float3(-1, 1, 1), color: CubeObject.sideColors[5], texCoord: simd_float2(1, 1)), // Top Left
//        Vertex(position: simd_float3(-1, -0.3, 1), color: CubeObject.sideColors[5], texCoord: simd_float2(0, 0)), // Bottom Left
////        Vertex(position: simd_float3(-1, -1, 1), color: CubeObject.sideColors[5]),
////        Vertex(position: simd_float3(1, -1, 1), color: CubeObject.sideColors[5]),
//        Vertex(position: simd_float3(1, -0.3, 1), color: CubeObject.sideColors[5], texCoord: simd_float2(0, 1)),
//        Vertex(position: simd_float3(1, 1, 1), color: CubeObject.sideColors[5], texCoord: simd_float2(1, 0)),
//        Vertex(position: simd_float3(-1, 1, 1), color: CubeObject.sideColors[5], texCoord: simd_float2(0, 0)),
//        Vertex(position: simd_float3(1, -0.3, 1), color: CubeObject.sideColors[5], texCoord: simd_float2(0, 1)),
//        Vertex(position: simd_float3(1, -1, 1), color: CubeObject.sideColors[5]),
    ]
    
    var texture: MTLTexture?
    var texBuffer: MTLBuffer?
    var buffOut: CMSampleBuffer?
    
    init(vertexBuffer: MTLBuffer? = nil) {
        super.init(vertices: CubeObject.cubeVertecies, vertexBuffer: vertexBuffer)
        scale = .one
//        position.x = 0
        position.z = -50
        
//        let textDescriptor = MTLTextureDescriptor()
//        textDescriptor.pixelFormat = .bgra8Unorm
//        textDescriptor.width = 200
//        textDescriptor.height = 100

//        texture = Engine.device?.makeTexture(descriptor: textDescriptor)
    }
    
    func prepareTexBuffer() {
//        texBuffer = Engine.device?.makeBuffer(length: 0, options: .storageModeShared)
    }
    
    let semaphr = DispatchSemaphore(value: 1)
    func writePixelBuffer (buffer: CMSampleBuffer) {
//        if let path = Bundle.main.path(forResource: "replace", ofType: "png") {
//            let fileUrl = URL(fileURLWithPath: path)
//            texture = try? MTKTextureLoader(device: Engine.device!).newTexture(URL: fileUrl, options: [MTKTextureLoader.Option.origin: MTKTextureLoader.Origin.bottomLeft])
//        }
        
        if let pixBuffer = CMSampleBufferGetImageBuffer(buffer) {
            var cgImage: CGImage?
            VTCreateCGImageFromCVPixelBuffer(pixBuffer, options: nil, imageOut: &cgImage)
            if let cgFrame = cgImage {
                do {
                    texture = try MTKTextureLoader(device: Engine.device!).newTexture(cgImage: cgFrame, options: [MTKTextureLoader.Option.origin: MTKTextureLoader.Origin.bottomLeft])
                } catch let error {
                    debugPrint(error)
                }
            }
        }
//        if let texture = texture {
//            
//            
//            CMSampleBufferCreateCopy(allocator: kCFAllocatorDefault, sampleBuffer: buffer, sampleBufferOut: &buffOut)
//            guard let buffOutC = buffOut else { return }
//            var pixBuffer = CMSampleBufferGetImageBuffer(buffOutC)
//            
//            guard pixBuffer != nil else { return }
//            semaphr.wait()
//            let width = 200
//            let height = 100
//            let region = MTLRegion(origin: .init(x: 0, y: 0, z: 0), size: .init(width: width, height: height, depth: 1))
//            texture.replace(region: region, mipmapLevel: 0, withBytes: &pixBuffer, bytesPerRow: 4 * 200)
//            semaphr.signal()
            
//        }
    }
    
//    override func encode(_ encoder: MTLRenderCommandEncoder) {
//        encoder.setFragmentTexture(texture, index: 0)
//        super.encode(encoder)
//        semaphr.signal()
//    }
    
//    override func update(deltaTime: Float) {
//        super.update(deltaTime: deltaTime)
//    }
}

extension CubeObject: MetalSizable {}

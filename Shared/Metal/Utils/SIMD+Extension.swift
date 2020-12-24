//
//  SIMD3+Protocol.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 23.12.2020.
//

import MetalKit

extension simd_float3: MetalSizable {
    static var random: Self {
        let r = Float(arc4random_uniform(256)) / 255.0;
        let g = Float(arc4random_uniform(256)) / 255.0;
        let b = Float(arc4random_uniform(256)) / 255.0;
        return simd_float3(r, g, b);
    }
    
    static var xAxis: simd_float3 {
        return simd_float3(1, 0, 0)
    }
    
    static var yAxis: simd_float3 {
        return simd_float3(0, 1, 0)
    }
    
    static var zAxis: simd_float3 {
        return simd_float3(0, 0, 1)
    }
}
extension simd_float4: MetalSizable {}

#if os(iOS)
extension MTLClearColor {
    static func from(_ uiColor: UIColor) -> MTLClearColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return MTLClearColor(red: Double(red), green: Double(green), blue: Double(blue), alpha: Double(alpha))
    }
}
#else
extension MTLClearColor {
    static func from(_ nsColor: NSColor) -> MTLClearColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        nsColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return MTLClearColor(red: Double(red), green: Double(green), blue: Double(blue), alpha: Double(alpha))
    }
}
#endif

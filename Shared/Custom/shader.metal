//
//  FirstShader.metal
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 22.12.2020.
//

#include <metal_stdlib>
using namespace metal;

struct Uniforms {
  float time;
  int2 resolution;
  float4x4 view;
  float4x4 inverseView;
  float4x4 viewProjection;
};

struct VertexIn {
    float3 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
    float2 texCoords [[ attribute(2) ]];
    int haveTexture [[ attribute(3) ]];
};

struct RasterizerData {
    float4 position [[ position ]];
    float4 color;
    float2 texCoords;
    int haveTexture;
    float time;
};

vertex RasterizerData first_vertex_shader(const device Uniforms& uniforms [[ buffer(0) ]],
                                          const VertexIn vertexIn [[ stage_in ]],
                                          const device float4x4& objectCoord [[ buffer(1) ]]) {
    RasterizerData rd;
    rd.position = uniforms.viewProjection * objectCoord * float4(vertexIn.position, 1);
    rd.color = vertexIn.color;
    rd.texCoords = vertexIn.texCoords;
    rd.haveTexture = vertexIn.haveTexture;
    rd.time = uniforms.time;
    return rd;
}

fragment half4 first_fragment_shader(RasterizerData rd [[ stage_in ]]) {
    float2 texCoords = rd.texCoords;
    
    float4 color = rd.color;
//    return half4(color.r, color.g, color.b, color.a);
    float x = sin((texCoords.x + rd.time) * 20);
//    float x = sin(texCoords.x);
    float y = 0;
    float z = 0;
    float4 newColor = float4(x, y, z, 1);
    return half4(newColor.r, newColor.g, newColor.b, newColor.a);
    // Sample the texture to obtain a color
//    if (rd.haveTexture == 0) {
//        return float4(rd.color);
//    }
//    const half4 colorSample = colorTexture.sample(sampler2D, rd.texCoords);
    // return the color of the texture
//    return float4(colorSample);
}

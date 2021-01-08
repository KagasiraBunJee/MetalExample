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
    float3 normal [[ attribute(1) ]];
    float4 color [[ attribute(2) ]];
    float2 texCoords [[ attribute(3) ]];
};

struct RasterizerData {
    float4 position [[ position ]];
    float4 color;
    float2 texCoords;
    float time;
};

struct Material {
    float4 color;
    bool shouldUseMatColor;
    bool shouldUseTex;
};

vertex RasterizerData first_vertex_shader(const device Uniforms& uniforms [[ buffer(0) ]],
                                          const VertexIn vertexIn [[ stage_in ]],
                                          const device float4x4& objectCoord [[ buffer(1) ]]) {
    RasterizerData rd;
    rd.position = uniforms.viewProjection * objectCoord * float4(vertexIn.position, 1);
    rd.color = vertexIn.color;
    rd.texCoords = vertexIn.texCoords;
    rd.time = uniforms.time;
    return rd;
}

vertex RasterizerData instanced_vertex_shader(const device Uniforms& uniforms [[ buffer(0) ]],
                                          const VertexIn vertexIn [[ stage_in ]],
                                          const device float4x4 *objectCoord [[ buffer(1) ]],
                                          uint instanceId [[ instance_id ]]) {
    RasterizerData rd;
    rd.position = uniforms.viewProjection * objectCoord[instanceId] * float4(vertexIn.position, 1);
    rd.color = vertexIn.color;
    rd.texCoords = vertexIn.texCoords;
    rd.time = uniforms.time;
    return rd;
}

fragment half4 first_fragment_shader(RasterizerData rd [[ stage_in ]],
                                     constant Material &material [[ buffer(1) ]],
                                     sampler sampler2d [[ sampler(0) ]],
                                     texture2d<float, access::sample> texture [[ texture(0) ]]) {
    if (material.shouldUseTex && rd.texCoords.x != 0 && rd.texCoords.y != 0) {
        float4 texColor = texture.sample(sampler2d, rd.texCoords).rgba;
        return half4(texColor.r, texColor.g, texColor.b, texColor.a);
    }
    float4 color = material.color;
    return half4(color.r, color.g, color.b, color.a);
//    float2 texCoords = rd.texCoords;
//
//    float4 color = rd.color;
//    float x = sin((texCoords.x + rd.time) * 20);
//    float y = 0;
//    float z = 0;
//    float4 newColor = float4(x, y, z, 1);
//    return half4(newColor.r, newColor.g, newColor.b, newColor.a);
}

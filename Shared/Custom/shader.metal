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
  float2 resolution;
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

vertex RasterizerData waves_vertex_shader(const device Uniforms& uniforms [[ buffer(0) ]],
                                          const VertexIn vertexIn [[ stage_in ]],
                                          const device float4x4& objectCoord [[ buffer(1) ]]) {
    
    
    
    RasterizerData rd;
    rd.position = uniforms.viewProjection * objectCoord * float4(vertexIn.position, 1);
    rd.color = rd.color;
    rd.texCoords = uniforms.resolution;
    rd.time = uniforms.time;
    return rd;
}

float2 arrangeCoords(float2 p, float2 resoluiton) {
    float2 q = p.xy/resoluiton.xy;
    float2 r = -1.0+2.0*q;
    r.x *= resoluiton.x/resoluiton.y;
    return r;
}

fragment half4 waves_fragment_shader(RasterizerData rd [[ stage_in ]],
                                     sampler sampler2d [[ sampler(0) ]],
                                     texture2d<float, access::sample> texture [[ texture(0) ]]) {
    
    float speed = 0.1;
    float scale = 0.002;
    float2 newXY = arrangeCoords(rd.position.xy, rd.texCoords.xy);
    float2 p = rd.position.xy * scale;
//    p.x *= rd.time;
//    p.y *= rd.time;
    for(int i=1; i<10; i++){
        p.x+=0.3/float(i)*sin(float(i)*3.*p.y+rd.time*speed);
        p.y+=0.3/float(i)*cos(float(i)*3.*p.x+rd.time*speed);
    }
    float r=cos(p.x+p.y+1.)*.5+0.5;
    float g=sin(p.x+p.y+1.)*.5+.5;
    float b=(sin(p.x+p.y)+cos(p.x+p.y))*.3+.5;
    return half4(1,1,1, 1);
}

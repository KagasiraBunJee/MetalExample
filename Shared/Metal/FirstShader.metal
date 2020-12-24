//
//  FirstShader.metal
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 22.12.2020.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float3 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
};

struct RasterizerData {
    float4 position [[ position ]];
    float4 color;
};

struct MeshCoords {
    float4x4 coords;
};

vertex RasterizerData first_vertex_shader(const VertexIn vertexIn [[ stage_in ]],
                                          const device float4x4& objectCoord [[ buffer(1) ]],
                                          constant float4x4 &projection [[ buffer(2) ]]) {
//                                          constant MeshCoords &objectCoord [[ buffer(1) ]]) {
    RasterizerData rd;
    rd.position = projection * objectCoord * float4(vertexIn.position, 1);
    rd.color = vertexIn.color;
    return rd;
}

fragment half4 first_fragment_shader(RasterizerData rd [[ stage_in ]]) {
    return half4(rd.color.r, rd.color.g, rd.color.b, rd.color.a);
}

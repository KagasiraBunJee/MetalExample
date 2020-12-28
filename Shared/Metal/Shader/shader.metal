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
    float2 texCoords [[ attribute(2) ]];
    int haveTexture [[ attribute(3) ]];
};

struct RasterizerData {
    float4 position [[ position ]];
    float4 color;
    float2 texCoords;
    int haveTexture;
};

vertex RasterizerData first_vertex_shader(const VertexIn vertexIn [[ stage_in ]],
                                          const device float4x4& objectCoord [[ buffer(1) ]],
                                          constant float4x4 &projection [[ buffer(2) ]]) {
//                                          constant MeshCoords &objectCoord [[ buffer(1) ]]) {
    RasterizerData rd;
    rd.position = projection * objectCoord * float4(vertexIn.position, 1);
    rd.color = vertexIn.color;
    rd.texCoords = vertexIn.texCoords;
    rd.haveTexture = vertexIn.haveTexture;
    return rd;
}

fragment float4 first_fragment_shader(RasterizerData rd [[ stage_in ]],
                                     texture2d<half> colorTexture [[ texture(0) ]],
                                      sampler           sampler2D [[ sampler(0) ]]) {
    // Sample the texture to obtain a color
    const half4 colorSample = colorTexture.sample(sampler2D, rd.texCoords);
    if (!rd.haveTexture) {
        return float4(rd.color);
    }

    // return the color of the texture
    return float4(colorSample);
}
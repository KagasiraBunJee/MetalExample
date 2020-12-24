//
//  kernels.metal
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 24.12.2020.
//

#include <metal_stdlib>
using namespace metal;

struct Particle {
    float4 color;
    float2 position;
    float angle;
};

kernel void clear_pass_func(texture2d<half, access::write> tex [[ texture(0) ]],
                            uint2 id [[ thread_position_in_grid ]]) {
    tex.write(half4(1, 0, 0, 1), id);
}

kernel void draw_dots(device Particle *particles [[ buffer(0) ]],
                      texture2d<half, access::write> tex [[ texture(0) ]],
                      constant float &deltaTime [[ buffer(1) ]],
                      constant float4x4 &mtx [[ buffer(2) ]],
                      uint id [[ thread_position_in_grid ]]) {
    Particle particle = particles[id];
    
    float angle = particle.angle + deltaTime/1000;
    
    float x = fast::cos(4.0f * angle) * fast::sin(angle);
    float y = fast::cos(4.0f * angle) * fast::cos(angle);
    
//    float4 pos = mtx * float4(x, y, 0, 1);
    half4 color = half4(particle.color.r, particle.color.g, particle.color.b, 1);
    uint2 texPos = uint2((x * 414 + 414), (y * 414 + 414));
//    uint2 texPos = uint2((pos.x * 414 + 414), (pos.y * 414 + 414));
//    uint2 texPos = uint2(pos.x, pos.y);
    tex.write(color, texPos);
    tex.write(color, texPos + uint2(1, 0));
    tex.write(color, texPos + uint2(0, 1));
    tex.write(color, texPos - uint2(1, 0));
    tex.write(color, texPos - uint2(0, 1));
}

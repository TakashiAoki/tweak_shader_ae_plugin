#pragma stage(compute)

#pragma input(image, name="input_image")
layout(set = 0, binding = 0) uniform texture2D input_image;

#pragma target(name="output_image", screen)
layout(set = 0, binding = 1, rgba16ui) uniform writeonly image2D output_image;

layout(local_size_x = 16, local_size_y = 16) in;
void main() {
    ivec2 pixel_coords = ivec2(gl_GlobalInvocationID.xy);
    // StarField v0.1.4: clamp to 0..1 first. AE's 16bpc white is 32768; values above
    // 1.0 used to pass through up to 65535 and showed as wrapped colors, and negative
    // values made uvec4() undefined.
    vec4 input_value = clamp(texelFetch(input_image, pixel_coords, 0), 0.0, 1.0);
    // drop MSB. for adobe reasons
    uvec4 out_color = uvec4(input_value * 32767.0);

    imageStore(output_image, pixel_coords, out_color);
}

#version 330 core

in float fragNear;
in float fragFar;
in vec3 nearPoint;
in vec3 farPoint;
in mat4 fragView;
in mat4 fragProj;
in float fragSmallIncrement;
in float fragBigIncrement;

out vec4 outColor;


vec4 grid(vec3 fragPos3D, float scale, bool drawAxis) {
    vec2 coord = fragPos3D.xy * scale;
    vec2 derivative = fwidth(coord);
    vec2 grid = abs(fract(coord - 0.5) - 0.5) / derivative;
    float line = min(grid.x, grid.y);
    float minimumz = min(derivative.y, 1);
    float minimumx = min(derivative.x, 1);
    vec4 color = vec4(0.2, 0.2, 0.2, 1.0 - min(line, 1.0));
	float axisThreshold = ((1.0f/fragSmallIncrement)/10.0f);
    // y axis
    if(fragPos3D.x > -axisThreshold * minimumx && fragPos3D.x < axisThreshold * minimumx)
        color.g = 1.0;
    // x axis
    if(fragPos3D.y > -axisThreshold * minimumz && fragPos3D.y < axisThreshold * minimumz)
        color.r = 1.0;
    return color;
}
float computeDepth(vec3 pos) {
    vec4 clip_space_pos = fragProj * fragView * vec4(pos.xyz, 1.0);
    return  0.5f * ((clip_space_pos.z / clip_space_pos.w)+1.0); // Return depth between 0 and 1
}

float computeLinearDepth(vec3 pos) {
    float depth = computeDepth(pos);
    float clip_space_depth = depth * 2.0 - 1.0; // put back between -1 and 1
	// get linear value between 0.01 and 100
    float linearDepth = (2.0 * fragNear * fragFar) / (fragFar + fragNear - clip_space_depth * (fragFar - fragNear));
    return linearDepth / fragFar; // normalize
}

void main() {
    float t = -nearPoint.z / (farPoint.z - nearPoint.z);
    vec3 fragPos3D = nearPoint + t * (farPoint - nearPoint);

    gl_FragDepth = computeDepth(fragPos3D);

    float linearDepth = computeLinearDepth(fragPos3D);
    float fading = max(0, (0.9 - linearDepth));

	// adding multiple resolution for the grid
    outColor = (grid(fragPos3D,fragBigIncrement , true) + grid(fragPos3D,fragSmallIncrement , true))* float(t > 0);
	outColor.a *= fading;
}
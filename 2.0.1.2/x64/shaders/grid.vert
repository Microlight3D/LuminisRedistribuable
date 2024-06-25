#version 330 core

layout(location = 0) in vec3 position;

out float fragNear;
out float fragFar;
out vec3 nearPoint;
out vec3 farPoint;
out mat4 fragView;
out mat4 fragProj;
out float fragSmallIncrement;
out float fragBigIncrement;

uniform mat4 V;
uniform mat4 P;
uniform float FAR; // Camera far
uniform float NEAR; // Camera near
uniform float smallIncrement; // Grid small increment
uniform float bigIncrement; // Grid big increment

vec3 UnprojectPoint(float x, float y, float z, mat4 view, mat4 projection) {
    mat4 viewInv = inverse(view);
    mat4 projInv = inverse(projection);
    vec4 unprojectedPoint =  viewInv * projInv * vec4(x, y, z, 1.0);
    return unprojectedPoint.xyz / unprojectedPoint.w;
}

void main(){
	nearPoint = UnprojectPoint(position.x, position.y, 0.0, V, P).xyz; // unprojecting on the near plane
	farPoint = UnprojectPoint(position.x, position.y, 1.0, V, P).xyz; // unprojecting on the far plane
	fragView = V;
	fragProj = P;
	fragFar = FAR;
	fragNear = NEAR;
	fragSmallIncrement = smallIncrement;
	fragBigIncrement = bigIncrement;
	gl_Position = vec4(position, 1.0); // using directly the clipped coordinates
}
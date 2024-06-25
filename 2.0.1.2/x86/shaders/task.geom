#version 330 core

layout(lines) in;
layout(triangle_strip, max_vertices = 32) out;

out vec3 fragment_normal;
out vec3 fragment_position;

uniform mat4 MVP;
uniform mat4 M;
//uniform vec2 size;

const vec2 size = vec2(0.2,1.4);

vec3 createPerp(vec3 p1, vec3 p2) {
    vec3 invec = normalize(p2 - p1);
    vec3 ret = cross( invec, vec3(0.0, 0.0, 1.0) );
    if ( length(ret) == 0.0 ) {
        ret = cross(invec, vec3(0.0, 1.0, 0.0) );
    }
    return ret;
}


void main() {

    vec3 axis = gl_in[1].gl_Position.xyz - gl_in[0].gl_Position.xyz;

    vec3 perpx = normalize(createPerp(gl_in[1].gl_Position.xyz, gl_in[0].gl_Position.xyz));
    vec3 perpy = cross(normalize(axis), perpx);

    float r1 = size.x/2.0;
    float r2 = size.y/2.0;

    int segs = 6;
    for(int i=0; i<segs; i++) {
        float a = i/float(segs-1) * 2.0 * 3.14159;
        float ca = r1*cos(a); 
        float sa = r2*sin(a);
        vec3 normal = vec3( ca*perpx.x + sa*perpy.x, ca*perpx.y + sa*perpy.y, ca*perpx.z + sa*perpy.z );

        vec3 p1 = gl_in[0].gl_Position.xyz + normal;
        vec3 p2 = gl_in[1].gl_Position.xyz + normal;

        gl_Position = MVP * vec4(p1, 1.0);
	    fragment_position = vec3(M * gl_Position);
	    fragment_normal = normalize(normal);
        EmitVertex();

        gl_Position = MVP * vec4(p2, 1.0);
	    fragment_position = vec3(M * gl_Position);
	    fragment_normal = normalize(normal);
        EmitVertex();
    }
    EndPrimitive();
}
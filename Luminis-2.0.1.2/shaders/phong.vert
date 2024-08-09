#version 330 core

layout(location = 0) in vec3 vertex_position;
layout(location = 1) in vec3 vertex_normal;

out VS_OUT {
    vec3 normal;
} vs_out;

void main(){
	gl_Position = vec4(vertex_position,1);
	vs_out.normal = vertex_normal;
}
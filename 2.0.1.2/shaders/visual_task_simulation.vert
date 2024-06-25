#version 330 core

layout(location = 0) in vec3 vertex_position;
layout(location = 1) in vec3 vertex_normal;

uniform mat4 MVP;
uniform mat4 M;

out vec3 fragment_normal;
out vec3 fragment_position;
flat out int fragment_id;

void main(){
	gl_Position = MVP * vec4(vertex_position,1);
	fragment_position = vec3(M * gl_Position);
	fragment_normal = mat3(transpose(inverse(M))) *  vertex_normal;
	fragment_id = gl_VertexID;
}
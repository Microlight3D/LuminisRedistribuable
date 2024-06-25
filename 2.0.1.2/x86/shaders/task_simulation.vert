#version 330 core

layout(location = 0) in vec3 vertex_position;
layout(location = 1) in vec3 vertex_normal;

uniform mat4 MVP;

flat out int fragment_id;

void main(){
	fragment_id = gl_VertexID;
	gl_Position = MVP * vec4(vertex_position,1);
}
#version 330 core

layout(location = 0) in vec3 vertex_position;
layout(location = 1) in vec3 vertex_normal;

uniform mat4 M;
uniform mat4 O;

void main(){
	gl_Position = O * M * vec4(vertex_position,1);
}
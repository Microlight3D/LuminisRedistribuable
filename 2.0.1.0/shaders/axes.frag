#version 330 core

out vec4 color;

uniform vec4 albedo;

void main(){
	color = albedo;
}
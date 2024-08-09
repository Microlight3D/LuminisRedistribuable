#version 330 core

flat in int fragment_id;

out vec4 color;

uniform vec4 albedo;
uniform int min_id;
uniform int max_id;

void main(){
	if(fragment_id < min_id || fragment_id > max_id){
		discard;
	}
	color = albedo;
}
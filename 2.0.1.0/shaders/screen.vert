#version 330 core

layout(location = 0) in vec3 vertex_position;

out vec2 frag_text_coords;

void main() {
    gl_Position = vec4(vertex_position.x, vertex_position.y, 0.0, 1.0); 
    frag_text_coords = vec2(vertex_position.x > 0.0 ? 1.0 : 0.0,vertex_position.y > 0.0 ? 1.0 : 0.0);
}
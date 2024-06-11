#version 330 core
layout(triangles) in;
layout(triangle_strip, max_vertices = 4) out;

in VS_OUT {
    vec3 normal;
} gs_in[];

out vec3 dist;
out vec3 fragment_normal;
out vec3 fragment_position;

const float MAGNITUDE = 1.0;

uniform mat4 MVP;
uniform mat4 M;

void main() {
	vec4 p0_3d = gl_in[0].gl_Position;
	vec4 p1_3d = gl_in[1].gl_Position;
	vec4 p2_3d = gl_in[2].gl_Position;
	
	// Compute the vertex position in the usual fashion. 
	p0_3d = MVP * p0_3d;  
	// 2D position
	vec2 p0 = p0_3d.xy / p0_3d.w; 
	
	// Compute the vertex position in the usual fashion. 
	p1_3d = MVP * p1_3d;  
	// 2D position
	vec2 p1 = p1_3d.xy / p1_3d.w; 
	
	// Compute the vertex position in the usual fashion. 
	p2_3d = MVP * p2_3d;  
	// 2D position
	vec2 p2 = p2_3d.xy / p2_3d.w; 
	
	//--------------------------------
	// Project p1 and p2 and compute the vectors v1 = p1-p0
	// and v2 = p2-p0                                  
	vec2 v10 = p1 - p0;   
	vec2 v20 = p2 - p0;   
	
	// Compute 2D area of triangle.
	float area0 = abs(v10.x*v20.y - v10.y*v20.x);
	
	// Compute distance from vertex to line in 2D coords
	float h0 = area0/length(v10-v20); 
	
	dist = vec3(h0, 0.0, 0.0);
	
	// Quick fix to defy perspective correction
	dist *= p0_3d.w;
	
	gl_Position = p0_3d;
	fragment_position = vec3(M * gl_Position);
	fragment_normal = mat3(transpose(inverse(M))) *  gs_in[0].normal; // TODO pass transpose inverse as uniform
	EmitVertex();
	
	//--------------------------------
	// Project p0 and p2 and compute the vectors v01 = p0-p1
	// and v21 = p2-p1                                  
	vec2 v01 = p0 - p1;   
	vec2 v21 = p2 - p1;   
	
	// Compute 2D area of triangle.
	float area1 = abs(v01.x*v21.y - v01.y*v21.x);
 
	// Compute distance from vertex to line in 2D coords
	float h1 = area1/length(v01-v21); 
	
	dist = vec3(0.0, h1, 0.0);
	
	// Quick fix to defy perspective correction
	dist *= p1_3d.w;

	gl_Position = p1_3d;
	fragment_position = vec3(M * gl_Position);
	fragment_normal = mat3(transpose(inverse(M))) *  gs_in[1].normal; // TODO pass transpose inverse as uniform
	EmitVertex();

	//--------------------------------
	// Project p0 and p1 and compute the vectors v02 = p0-p2
	// and v12 = p1-p2                                  
	vec2 v02 = p0 - p2;   
	vec2 v12 = p1 - p2;   

	// Compute 2D area of triangle.
	float area2 = abs(v02.x*v12.y - v02.y*v12.x);

	// Compute distance from vertex to line in 2D coords
	float h2 = area2/length(v02-v12); 

	dist = vec3(0.0, 0.0, h2);

	// Quick fix to defy perspective correction
	dist *= p2_3d.w;

	gl_Position = p2_3d;
	fragment_position = vec3(M * gl_Position);
	fragment_normal = mat3(transpose(inverse(M))) *  gs_in[2].normal; // TODO pass transpose inverse as uniform
	EmitVertex();
	
	//--------------------------------
	EndPrimitive();
}
#version 330 core

in vec3 dist;
in vec3 fragment_normal;
in vec3 fragment_position;

out vec4 color;

struct OmniLight {    
    vec3 position;
    float constant;
    float linear;
    float quadratic;
	vec3 ambient;
    vec3 color;
};

struct DirectionalLight{
    vec3 direction;
	vec3 ambient;
    vec3 color;
};

struct Material {
    vec4 albedo;
    float specular;
    float metallic;
}; 

#define NB_OMNI_LIGHTS 5
#define NB_DIR_LIGHTS 5
uniform Material material;
uniform mat4 INV_V;
uniform mat4 M;
uniform OmniLight OMNI_LIGHTS[NB_OMNI_LIGHTS];
uniform DirectionalLight DIR_LIGHTS[NB_DIR_LIGHTS];
uniform int OMNI_COUNT;
uniform int DIR_COUNT;
uniform bool faceOrientationDisplay;
uniform bool wireframeDisplay;

const vec3 frontface_albedo = vec3(0.24f, 0.24f, 0.93f);
const vec3 backface_albedo = vec3(93.0f, 0.24f, 0.24f);


vec3 CalcPointLight(OmniLight light, vec3 normal, vec3 fragPos, vec3 viewDir) {
	vec3 albedo = material.albedo.rgb;
	if(faceOrientationDisplay){
		albedo = gl_FrontFacing ? frontface_albedo : backface_albedo;
	}
	vec3 lightDir = normalize(light.position - fragPos);
	// diffuse shading
	float diff = max(dot(normal, lightDir), 0.0);
	// specular shading
	vec3 reflectDir = reflect(-lightDir, normal);
	float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.metallic);
	// attenuation
	float distance    = length(light.position - fragPos);
	float attenuation = 1.0 / (light.constant + light.linear * distance + 
				light.quadratic * (distance * distance));
	// combine results
	vec3 ambient  = light.ambient * albedo;
	vec3 diffuse  = light.color * diff * albedo;
	vec3 specular = light.color * spec * material.specular;
	ambient  *= attenuation;
	diffuse  *= attenuation;
	specular *= attenuation;
	return (ambient + diffuse + specular);
}


vec3 CalcDirLight(DirectionalLight light, vec3 normal, vec3 viewDir) {
	vec3 albedo = material.albedo.rgb;
	if(faceOrientationDisplay){
		albedo = gl_FrontFacing ? frontface_albedo : backface_albedo;
	}
    vec3 lightDir = normalize(-light.direction);
    // diffuse shading
    float diff = max(dot(normal, lightDir), 0.0);
    // specular shading
    vec3 reflectDir = reflect(-lightDir, normal);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.metallic);
    // combine results
    vec3 ambient  = light.ambient  * albedo;
    vec3 diffuse  = light.color  * diff * albedo;
    vec3 specular = light.color * spec * material.specular;
    return (ambient + diffuse + specular);
}

void main() {
	if(!faceOrientationDisplay && !gl_FrontFacing){
		discard;
	}

	vec3 normal = normalize(fragment_normal);
	vec3 camera_direction = normalize(INV_V[3].xyz - fragment_position);
	
	color.rgb = vec3(0);

	for(int i = 0; i < OMNI_COUNT; i++){
		color.rgb += CalcPointLight(OMNI_LIGHTS[i], normal, fragment_position,camera_direction);
	}
	
	for(int i = 0; i < DIR_COUNT; i++){
		color.rgb += CalcDirLight(DIR_LIGHTS[i], normal,camera_direction);
	}
	
	color.a = material.albedo.a;

	if(wireframeDisplay) {
		// Compute the shortest distance to the edge
		float d = min(dist[0], min(dist[1], dist[2]));

		// Compute line intensity and then fragment color
		float I = (d > 0.05 ? 0 : 1);
		color.rgb =  mix(color.rgb,vec3(0,0,0),I);
	}
}
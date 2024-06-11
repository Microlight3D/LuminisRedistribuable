#version 330 core
  
in vec2 frag_text_coords;

out vec4 color;

uniform int outline_px_width;
uniform vec3 selection_color;
uniform vec3 focused_color;

uniform sampler2D texture0;
uniform sampler2D texture1;

void main() {
    // Render main scene to screen
    color.rgb = texture(texture0, frag_text_coords).rgb;
    color.a = 1.0f;

    vec3 silhouetteColor = texture(texture1, frag_text_coords).rgb;

    // if the pixel isn't full reg/green (we are on the silhouette)
    if (length(silhouetteColor.rg) < 1.0f) {
        vec2 size = 1.0f / textureSize(texture1, 0);

        for (int i = -outline_px_width; i <= +outline_px_width; i++) {
            for (int j = -outline_px_width; j <= +outline_px_width; j++) {
                if (i == 0 && j == 0) {
                    continue;
                }

                vec2 offset = vec2(i, j) * size;
                vec3 silhouetteOffsetColor = texture(texture1, frag_text_coords+offset).rgb;
                // and if one of the pixel-neighbor is different (we are on a border)
                if (abs(length(silhouetteColor.rg) - length(silhouetteOffsetColor.rg)) >= (1.0f/600.0f)){
                    if(silhouetteColor.b > 0.5f){
                        color.rgb = focused_color;
                    } else {
                        color.rgb = selection_color;
                    }
                    return;
                }
            }
        }
    }
}
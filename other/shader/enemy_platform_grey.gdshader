shader_type canvas_item;
uniform sampler2D normal_map;

uniform bool fade = false;
uniform float colorIncrease;

void fragment(){
	// Converts the texture data into a unit vector, with each channel in the [-1, 1] range

//NORMAL = 2.0 * texture(normal_map, UV).rgb - 1.0;

vec4 c = texture(TEXTURE,UV);
float add = colorIncrease+1.0;

if (fade){
	
	COLOR.rgb = vec3(c.r*add,c.g*add,c.b*add)
}


}
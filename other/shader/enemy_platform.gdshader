shader_type canvas_item;
render_mode blend_mix;

uniform sampler2D normal_map;
uniform sampler2D distortMapX;
uniform sampler2D distortMapY;

uniform float addBrightness: hint_range(0.0, 10.0) = 0.0;
uniform float brightnessThres: hint_range(0.0, 1.0) = 0.165;
uniform float transparencyG: hint_range(0.0, 1.0) = 0;
uniform bool afterGlow = false;
uniform float transparency: hint_range(0.0, 1.0) = 1;
uniform float distortion: hint_range(0.0, 1.0) = 0;

void fragment(){
// Converts the texture data into a unit vector, with each channel in the [-1, 1] range

//NORMAL = 2.0 * texture(normal_map, UV).rgb - 1.0;

vec2 distortedUV;
distortedUV.x = UV.x + texture(distortMapX,UV).r - (0.5*distortion) - (texture(distortMapX,UV).r)*(1.0-distortion);
distortedUV.y = UV.y + texture(distortMapY,UV).r - (0.5*distortion) - (texture(distortMapY,UV).r)*(1.0-distortion);

vec4 c = texture(TEXTURE,distortedUV);

//float b = addBrightness*((c.r+c.g+c.b)/3.0);
float b = addBrightness;


if (afterGlow){
	if (((c.r+c.g+c.b)/3.0) >= brightnessThres){
		COLOR = vec4(c.r + c.r*b, c.g + c.g*b, c.b + c.b*b,c.a*(1.0-transparencyG));
	}
	else{
		COLOR = vec4(c.r, c.g, c.b, c.a*(1.0 - transparency));
	}
}
else{
	COLOR = vec4(c.r,c.g,c.b,c.a*(1.0 - transparency));
}
}
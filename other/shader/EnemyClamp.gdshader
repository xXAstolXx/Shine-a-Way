shader_type canvas_item;
render_mode blend_mix;

uniform sampler2D normal_map;
uniform sampler2D distortMapX;
uniform sampler2D distortMapY;

uniform float addBrightness: hint_range(0.0, 10.0) = 0.0;
uniform float brightnessThres: hint_range(0.0, 1.0) = 0.165;
uniform float transparency: hint_range(0.0, 1.0) = 1;
uniform float distortion: hint_range(0.0, 1.0) = 0;

void fragment(){

	//NORMAL = 2.0 * texture(normal_map, UV).rgb - 1.0;
	vec3 randomNoise = vec3(texture(distortMapX, UV).r , texture(distortMapY, UV).g, 1.0);

	vec2 distortedUV = UV + (randomNoise.rg - 0.5)*distortion;
	
	vec4 c = texture(TEXTURE,distortedUV);

	float brightness = dot(c.rgb, vec3(0.299 + 0.587 + 0.114));

	float b = addBrightness*brightness;
	c.rgb *= 1.0 + b;

	COLOR = vec4(c.r,c.g,c.b,c.a*(1.0-transparency));
}
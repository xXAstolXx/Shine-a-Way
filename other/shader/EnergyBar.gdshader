shader_type canvas_item;
render_mode blend_mix;

uniform float addBrightness: hint_range(0.0, 3.0) = 0.0;
uniform sampler2D colorGradient: hint_albedo;
uniform sampler2D emptyColor: hint_albedo;
uniform float startUV = 0.4;
uniform float endUV = 0.8;
uniform float topUV = 0.4;
uniform float botUV = 0.6;
uniform float energy: hint_range(0.0, 100.0, 1.0);
uniform float maxEnergy = 100.0;

void fragment() {
	float range = endUV - startUV;
	float x = UV.x - startUV;
	float value = energy/maxEnergy;
	float perc = x/range;
	
	float rangeY = botUV - topUV;
	float y = UV.y - topUV;
	float percY = abs(y-(range/2.0));
	float bAdd = ((range/2.0) - percY)*(1.0/(range/2.0));
	
	vec4 c = texture(TEXTURE,UV);
	
	vec4 f = texture(colorGradient,vec2(x/range,0.5));
	float b = addBrightness*((f.r+f.g+f.b)/3.0);
	//f.rgb = vec3(b*f.r,b*f.g,b*f.b);
	f.rgb = vec3(f.r+b*f.r*bAdd,f.g+b*f.g*bAdd,f.b+b*f.b*bAdd);
	
	if (c.a == 1.0){
		if (perc <= value){
			COLOR = f
		}
		else{
			COLOR = texture(emptyColor,vec2(x/range,0.5))
		}
	}
	else{
		COLOR = vec4(0.0,0.0,0.0,0.0)
	}
}
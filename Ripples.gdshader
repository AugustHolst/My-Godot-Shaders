shader_type spatial;

uniform vec2 res;
uniform sampler2D currBuffer;
uniform sampler2D prevBuffer;
uniform float damping;

float sumVec4(vec4 vec) {
	return vec.x + vec.y + vec.z + vec.w;
}

void fragment() {
	vec2 pix = 1.0/res;
	
	float prev = texture(prevBuffer, UV).x;
	
	vec4 udlr = vec4(
		texture(currBuffer, UV + vec2(0.0, pix.y)).x,
		texture(currBuffer, UV - vec2(0.0, pix.y)).x,
		texture(currBuffer, UV + vec2(pix.x, 0.0)).x,
		texture(currBuffer, UV - vec2(pix.x, 0.0)).x
	);
	
	float next = (sumVec4(udlr) / 2.0) - prev;
	next = next * damping;
	
	ALBEDO = vec3(next, next/2.0 + 0.1, 1.0);
	ROUGHNESS = 0.01;
}
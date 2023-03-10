shader_type spatial;

uniform int amount = 10;
uniform float seedx = 0.11; uniform float seedy = 0.21;
uniform float dropRadius = 0.5;
uniform float intensity = 0.5;

float circle(vec2 position, float radius, float feather)
{
	return smoothstep(radius, radius + feather, dot(position, position) * 4.0);
}

void fragment() {
	/*
	vec2 pos = UV - 0.1;
	vec2 pos2 = UV - 0.4;
	
	float timer = mod(TIME * 0.5, 0.2);
	float timer2 = mod(TIME * 0.5, 0.2);
	
	float timer11 = mod(TIME * 0.5, 0.4);
	float timer12 = mod(TIME * 0.5, 0.4);
	
	float damping = 0.2 - timer;
	float damping2 = 0.4 - timer11;
	vec3 circles = 
		( damping *  vec3(1.0 - circle(pos, timer, 0.005)) ) * vec3(circle(pos, timer2, 0.005)) +
		( damping2 * vec3(1.0 - circle(pos2, timer11, 0.005)) ) * vec3(circle(pos2, timer12, 0.005));
	
	ALBEDO = circles;
	*/
	vec3 circles = vec3(0.0);
	for(int i; i < amount; i++) {
		float rnd = mod(float(i) * seedx + 1.0, 1.0);
		float rnd2 = mod(float(i) * seedy + 1.0, 1.0);
		vec2 pos = UV - vec2(rnd, rnd2);
		float timer = mod(TIME * 0.5, dropRadius);
		float damping = dropRadius - timer;
		circles += ( damping * vec3(1.0 - circle(pos, timer, 0.005)) ) * vec3(circle(pos, timer, 0.005));
	}
	//ALBEDO = vec3(1.0) * damping;
	ALBEDO = circles;
	ROUGHNESS = 0.01;
}
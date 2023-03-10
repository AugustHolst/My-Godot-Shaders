shader_type spatial;

render_mode specular_toon;
//Wave vector consists of (direction.x, direction.y, steepness, wavelength)
uniform vec4 WaveA;
uniform vec4 WaveB;
uniform vec4 WaveC;

varying vec3 normal;

mat3 gerstnerWave(vec4 wave, vec3 p, vec3 tangent, vec3 binormal) {
	vec2  d = normalize(wave.xy);
	float steepness = wave.z;
    float wavelength = wave.w;
    float k = 2.0 * PI / wavelength;
	float c = sqrt(9.8 / k);
	
	float f = k * (dot(d, p.xz) - c * TIME);
	float a = steepness / k;

	tangent += vec3(
		-d.x * d.x * (steepness * sin(f)),
		d.x * (steepness * cos(f)),
		-d.x * d.y * (steepness * sin(f))
	);
	binormal += vec3(
		-d.x * d.y * (steepness * sin(f)),
		d.y * (steepness * cos(f)),
		-d.y * d.y * (steepness * sin(f))
	);
	
	return mat3(vec3(
		d.x * (a * cos(f)),
		a * sin(f),
		d.y * (a * cos(f))
	), tangent, binormal);
}

void vertex() {
	vec3 gridPoint = VERTEX.xyz;
	vec3 tangent = vec3(1.0, 0.0, 0.0);
	vec3 binormal = vec3(0.0, 0.0, 1.0);
	
	mat3 p = mat3(gridPoint, tangent, binormal);
	p += gerstnerWave(WaveA, gridPoint, tangent, binormal);
	p += gerstnerWave(WaveB, gridPoint, p[1], p[2]);
	p += gerstnerWave(WaveC, gridPoint, p[1], p[2]);
	normal = normalize(cross(p[2], p[1]));
	VERTEX.xyz = p[0];
}

void fragment() {
	float fresnel = sqrt(1.0 - dot(NORMAL, VIEW));
	NORMAL = normal;
	RIM = 0.2;
	METALLIC = 0.0;
	ROUGHNESS = 0.01 * (1.0 - fresnel);
	ALBEDO = vec3(0.1, 0.3, 0.5) - 0.2;
	ALPHA = 0.95;
}

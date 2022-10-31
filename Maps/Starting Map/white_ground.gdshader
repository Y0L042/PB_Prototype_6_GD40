shader_type canvas_item;

uniform vec3 colour = vec3(0.5, 0.7, 0.5);

varying vec2 world_position;
varying vec2 world_pos;






void vertex() {
	world_position = VERTEX;
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}


float rand(vec2 coord){
	return fract(sin(dot(coord, vec2(56, 78)) * 100.0) * 100.0);
}

float noise(vec2 coord){
	vec2 i = floor(coord);
	 vec2 f = fract(coord);
	
	float a = rand(i);
	float b = rand(i + vec2(1.0, 0.0));
	float c = rand(i + vec2(0.0, 1.0));
	float d = rand(i + vec2(1.0, 1.0));
	
	float value = mix(a, b, f.x) + (c - a) * f.y * (1.0 - f.x) + (d - b) * f.x * f.y;
	return value;
}

void fragment(){  
	vec2 map_uv = world_position / 128.0;
	COLOR = vec4(colour, noise(world_pos*20.0));
}



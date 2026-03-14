shader_type canvas_item;

uniform vec2 pivot = vec2(0,0);
uniform float speed : hint_range(0.5, 5.0) = 3.0;
uniform float bounce_amount : hint_range(0.0, 30.0) = 15.0;
uniform float squash_amount : hint_range(0.0, 0.3) = 0.15;
uniform float move_tick : hint_range(-1.0,1.0) = 0;

uniform vec4 clr : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform int type : hint_enum("Disable", "Round", "Square") = 2;
uniform float thickness = 1.0;

const vec2[8] DIRECTIONS = {
	vec2(1.0, 0.0),
	vec2(0.0, 1.0),
	vec2(-1.0, 0.0),
	vec2(0.0, -1.0),
	vec2(1.0, 1.0),
	vec2(-1.0, 1.0),
	vec2(-1.0, -1.0),
	vec2(1.0, -1.0)
};

float gtz(float input) { return max(0, sign(input)); }

float check(sampler2D tex, vec2 from, vec2 size) {
	float result = 0.0;
	for (int i = 0; i < 4 * type; i++) {
		result += texture(tex, from + DIRECTIONS[i] * size * thickness).a;
	}
	return gtz(result);
}

void vertex() {
	float time_phase = TIME * speed + VERTEX.x * 0.5;
	
	float squash_factor = abs(sin(time_phase * 2.0));
	
	float scale_y = 1.0 - squash_factor * squash_amount * (move_tick * 1.0);
	float scale_x = 1.0 + squash_factor * squash_amount * move_tick * 0.8 - squash_factor * squash_amount * move_tick;
	
	VERTEX.x *= scale_x;
	VERTEX.y *= scale_y;
	
	float bounce_offset = abs(cos(time_phase * 2.0)) * bounce_amount-3.0;
	VERTEX.y -= bounce_offset * move_tick; 
	
	float drag = sin(time_phase);
	VERTEX.x -= move_tick * drag * 0.1;
	
	vec2 vertex_offset = VERTEX.xy - pivot;
	float angle = sin(TIME*speed*2.0)*0.1 * move_tick;
	float c = cos(angle);
	float s = sin(angle);
	mat2 rot_matrix = mat2(vec2(c,-s),vec2(s,c));
	vertex_offset = rot_matrix * vertex_offset;
	VERTEX.xy = vertex_offset + pivot;
	}

void fragment() {
	COLOR = mix( COLOR, clr, check(TEXTURE, UV, TEXTURE_PIXEL_SIZE) * (1.0 - gtz(COLOR.a)) );
}


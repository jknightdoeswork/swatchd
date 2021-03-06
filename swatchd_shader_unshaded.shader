shader_type spatial;
render_mode depth_draw_opaque, unshaded;
uniform sampler2D texture_albedo:hint_albedo;
uniform int color_index;

void fragment() {
	vec4 albedo_tex = texelFetch(texture_albedo, ivec2(color_index, 0), 0);
	ALBEDO = albedo_tex.rgb;
}
shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_lambert,specular_disabled;
uniform sampler2D texture_albedo:hint_albedo;
uniform int color_index;

void fragment() {
	vec4 albedo_tex = texelFetch(texture_albedo, ivec2(color_index, 0), 0);
	ALBEDO = albedo_tex.rgb;
	METALLIC = 0.0;
	ROUGHNESS = 1.0;
	SPECULAR = 0.0;	
}
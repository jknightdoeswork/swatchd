tool
extends Resource
class_name Swatchd

export(Array, Color) var colors = [] setget set_colors
export(Dictionary) var named_colors:Dictionary setget set_named_colors
export(Resource) var override_swatch:Resource setget set_override_swatch
export(Texture) var texture

func set_override_swatch(o:Resource):
	if override_swatch != null:
		override_swatch.disconnect("changed", self, "on_override_swatch_changed")
	
	if o != null:
		# Check if the nested resource has the same script
		if o.get_script() == get_script():
			override_swatch = o
			override_swatch.connect("changed", self, "on_override_swatch_changed")
	else:
		override_swatch = null
	
	on_override_swatch_changed()

func on_override_swatch_changed():
	clear_texture_cache()
	emit_signal("changed")

func set_colors(colors_) -> void:
	colors = colors_
	clear_texture_cache()
	emit_signal("changed")

func set_named_colors(c) -> void:
	named_colors = c
	clear_texture_cache()
	emit_signal("changed")

func has_named_color(color_name:String) -> bool:
	return named_colors.has(color_name)

func get_named_color(color_name:String) -> Color:
	if override_swatch != null and override_swatch.has_named_color(color_name):
		return override_swatch.get_named_color(color_name)
	return named_colors.get(color_name, Color.white)

func clear_texture_cache():
	texture = null

func cached_texture():
	if !texture:
		texture = generate_texture()
	return texture

func get_texture_index_for_name(name:String) -> int:
	var sorted_keys:Array = named_colors.keys()
	sorted_keys.sort()
	var index_in_dictionary = sorted_keys.find(name)
	
	if (index_in_dictionary < 0):
		printerr("[Swatchd] get_texture_index_for_name couldn't find key: " + name)
		return -1
	
	return colors.size() + index_in_dictionary

func generate_texture() -> Texture:
	# print ("[Swatchd] generate_texture")
	# Create texture for swatch
	var num_colors = colors.size() + named_colors.size()
	var image:Image = Image.new()
	image.create(num_colors, 1, false, Image.FORMAT_RGBA8)
	image.lock()
	var iterator := 0
	
	# Add colors from color array
	for c in colors:
		image.set_pixel(iterator, 0, c)
		iterator += 1
	
	# Add colors from named_colors dictionary
	var sorted_keys = named_colors.keys()
	sorted_keys.sort()
	for k in sorted_keys:
		var named_color = get_named_color(k)
		assert(named_color is Color)
		image.set_pixel(iterator, 0, named_color)
		iterator += 1
	
	image.unlock()
	
	var tex = ImageTexture.new()
	tex.create_from_image(image)
	tex.flags = 0
	return tex

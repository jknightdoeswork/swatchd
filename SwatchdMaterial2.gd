tool
extends ShaderMaterial
class_name SwatchdMaterial2

export(Resource) var swatch setget set_swatch
export(String) var shader_key setget set_shader_key
export(int) var color_index setget set_color_index
export(String) var color_name setget set_color_name

export(bool) var override := false setget set_override
export(Color) var override_color := Color.white setget set_override_color

func set_shader_key(s:String) -> void:
	shader_key = s
	apply_color_index()
	
func apply_color(color:Color) -> void:
	set_shader_param(shader_key, color)

func apply_color_index() -> void:
	if override:
		apply_color(override_color)
	elif swatch:
		if color_name != null && !color_name.empty():
			if swatch.named_colors.has(color_name):
				var color = swatch.named_colors.get(color_name)
				assert(color is Color)
				apply_color(color)
				return
			else:
				print ("[SwatchdApplier] color name not found: " + str(color_name))

		if color_index >= 0 && color_index < swatch.colors.size():
			var color = swatch.colors[color_index]
			apply_color(color)
		else:
			print ("[SwatchdApplier] apply_color " + str(color_index) + " is out of range [0, " + str(swatch.colors.size() - 1) + "]")
	
func on_swatch_changed() -> void:
	print ("SwatchdApplier on_swatch_changed")
	apply_color_index()

func set_color_index(color_index_) -> void:
	color_index = color_index_
	apply_color_index()

func set_color_name(color_name_) -> void:
	color_name = color_name_
	apply_color_index()

func _ready() -> void:
	apply_color_index()
			
func _exit_tree() -> void:
	# Disconnect swatch's signal
	if swatch:
		if swatch.is_connected("changed", self, "on_swatch_changed"):
			swatch.disconnect("changed", self, "on_swatch_changed")

func set_swatch(new_swatch) -> void:
	# Disconnect old swatch's signal
	if swatch:
		if swatch.is_connected("changed", self, "on_swatch_changed"):
			swatch.disconnect("changed", self, "on_swatch_changed")
	
	# Connect new swatch's signal
	if (new_swatch is Swatchd):
		swatch = new_swatch
		if not swatch.is_connected("changed", self, "on_swatch_changed"):
			var e = swatch.connect("changed", self, "on_swatch_changed")
			assert(e == 0)
	elif new_swatch == null:
		swatch = new_swatch
	else:
		print ("[SwatchdApplier] set_swatch resource is not a swatch.")
		print (new_swatch)

func get_swatch() -> Resource:
	return swatch

func set_override(o:bool) -> void:
	override = o
	apply_color_index()

func set_override_color(c:Color) -> void:
	override_color = c
	apply_color_index()
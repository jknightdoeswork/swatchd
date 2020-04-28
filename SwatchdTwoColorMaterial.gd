tool
extends ShaderMaterial
class_name SwatchdTwoColorMaterial

export(Resource) var swatch setget set_swatch
export(int) var color_index setget set_color_index
export(String) var color_name setget set_color_name

export(int) var color_index2 setget set_color_index2
export(String) var color_name2 setget set_color_name2

func set_swatch_index(i:int, j:int) -> void:
	# print ("[SwatchdMaterial] set_swatch_index " + str(i))
	self.set_shader_param("color_index", i)
	self.set_shader_param("color_index2", j)
	
func apply_texture_index() -> void:
	# print ("[SwatchdMaterial] apply_texture_index")
	if swatch:
		if color_name != null && !color_name.empty():
			if swatch.named_colors.has(color_name):
				var texture_index = swatch.get_texture_index_for_name(color_name)
				var texture_index2 = swatch.get_texture_index_for_name(color_name2)
				set_swatch_index(texture_index, texture_index2)
			else:
				print ("[SwatchdMaterial] color name not found: " + str(color_name))
		elif color_index >= 0 && color_index < swatch.colors.size() and color_index2 >= 0 && color_index2 < swatch.colors.size():
			set_swatch_index(color_index, color_index2)
			#self.get_parent().material_override.albedo_color = color
		else:
			pass
			#print ("[SwatchdMaterial] apply_color " + str(color_index) + " is out of range [0, " + str(swatch.colors.size() - 1) + "]")
	
func on_swatch_changed() -> void:
	# print ("[SwatchdMaterial] on_swatch_changed resource_name " + self.resource_path)
	self.set_shader_param("texture_albedo", swatch.cached_texture())
	apply_texture_index()
	
func set_swatch(new_swatch) -> void:
	# print ("[SwatchdMaterial] set_swatch.")
	# Disconnect old swatch's signal
	if swatch:
		if swatch.is_connected("changed", self, "on_swatch_changed"):
			swatch.disconnect("changed", self, "on_swatch_changed")
	
	# Connect new swatch's signal
	if (new_swatch is Swatchd):
		swatch = new_swatch
		self.set_shader_param("texture_albedo", swatch.cached_texture())
		if not swatch.is_connected("changed", self, "on_swatch_changed"):
			var e = swatch.connect("changed", self, "on_swatch_changed")
			assert(e == 0)
	elif new_swatch == null:
		swatch = new_swatch
	else:
		print ("[SwatchdApplier] set_swatch resource is not a swatch.")
		print (new_swatch)

func set_color_index(color_index_) -> void:
	# print ("[SwatchdMaterial] set_color_index.")
	color_index = color_index_
	if color_name.length() > 0 and color_name2.length() > 0:
		apply_texture_index()

func set_color_name(color_name_:String) -> void:
	# print ("[SwatchdMaterial] set_color_name.")
	color_name = color_name_
	if color_name.length() > 0 and color_name2.length() > 0:
		apply_texture_index()

func set_color_index2(color_index_) -> void:
	# print ("[SwatchdMaterial] set_color_index.")
	color_index2 = color_index_
	if color_name.length() > 0 and color_name2.length() > 0:
		apply_texture_index()

func set_color_name2(color_name_) -> void:
	# print ("[SwatchdMaterial] set_color_name.")
	color_name2 = color_name_
	if color_name.length() > 0 and color_name2.length() > 0:
		apply_texture_index()
	
func _ready() -> void:
	# print ("[SwatchdMaterial] ready")
	apply_texture_index()
			
func _exit_tree() -> void:
	# print ("[SwatchdMaterial] _exit_tree")
	# Disconnect swatch's signal
	if swatch:
		if swatch.is_connected("changed", self, "on_swatch_changed"):
			swatch.disconnect("changed", self, "on_swatch_changed")

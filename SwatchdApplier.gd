tool
extends Node

class_name SwatchdApplier

export(Resource) var swatch setget set_swatch, get_swatch
export(int) var color_index setget set_color_index
export(String) var color_name setget set_color_name
export(NodePath) var target_node

export(bool) var override := false setget set_override
export(Color) var override_color := Color.white setget set_override_color

func apply_texture_index(texture_index:int) -> void:
	pass
	
func apply_color(_color:Color) -> void:
	pass

func apply_color_index() -> void:
	if !is_inside_tree():
		return
	if override:
		apply_color(override_color)
	elif swatch:
		if color_name != null && !color_name.empty():
			if swatch.named_colors.has(color_name):
				var color = swatch.named_colors.get(color_name)
				assert(color is Color)
				apply_color(color)
				var texture_index = swatch.get_texture_index_for_name(color_name)
				apply_texture_index(texture_index)
				return
			else:
				print ("[SwatchdApplier] color name not found: " + str(color_name))

		if color_index >= 0 && color_index < swatch.colors.size():
			var color = swatch.colors[color_index]
			apply_color(color)
			apply_texture_index(color_index)
			#self.get_parent().material_override.albedo_color = color
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

func get_target() -> Node:
	if target_node:
		var target = get_node(target_node)
		if target:
			return target
		else:
			print ("[SwatchdApplier] target_node not found.")
			print (name)
			yield(get_tree(), "idle_frame")
			print (get_parent())
			return null
	else:
		return get_parent()


func set_override(o:bool) -> void:
	override = o
	apply_color_index()

func set_override_color(c:Color) -> void:
	override_color = c
	apply_color_index()

# TODO
# Figure out how to disconnect signals when the script is removed from the node!
#func set_script(s) -> void:
#	print ("set script!")
#	.set_script(s)
	
#func _notification(what: int) -> void:
#	print ("notification: " + str(what))

#func _enter_tree() -> void:
#	print ("[SwatchdApplier] enter scene")
#	get_script().connect("script_changed",self,"on_script_changed")
	
#func on_script_changed() -> void:
#	print ("Swatch applier")

#func _set(property: String, value) -> bool:
#	print ("set prop " + property)
	#return ._set(property, value)
#	return true
	

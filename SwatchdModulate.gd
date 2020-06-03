tool
extends SwatchdApplier
class_name SwatchdModulate

export var apply_to_children = false

func apply_color(_color:Color) -> void:
	var t := get_target() as Control
	assert(t != null)
	
	if apply_to_children:
		t.modulate = _color
	else:
		t.self_modulate = _color
	

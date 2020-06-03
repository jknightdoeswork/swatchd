tool
extends SwatchdApplier
class_name SwatchdLight

func apply_color(_color:Color) -> void:
	var t = get_target()
	assert(t is Light)
	t.light_color = _color

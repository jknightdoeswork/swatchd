tool
extends SwatchdApplier
class_name SwatchdColorRect

func apply_color(color:Color) -> void:
	var t = get_target()
	assert(t is ColorRect)
	t.color = color
	

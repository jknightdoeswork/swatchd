tool
extends SwatchdApplier
class_name SwatchdFogColor

export(Environment) var env:Environment

func apply_color(_color:Color) -> void:
	if env:
		env.fog_color = _color

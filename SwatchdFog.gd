tool
extends SwatchdApplier
class_name SwatchdFog

export(Environment) var env:Environment

func apply_color(_color:Color) -> void:
	if env:
		env.set_fog_color(_color)
	

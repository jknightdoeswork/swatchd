tool
extends SwatchdApplier
class_name SwatchdClearColor

export(Environment) var env

func apply_color(_color:Color) -> void:
	if env:
		env.set_bg_color(_color)
	
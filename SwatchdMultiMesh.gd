tool
extends SwatchdApplier

class_name SwatchdMultiMesh

func apply_color(c:Color) -> void:
	var target = get_target()
	if target:
		#assert(target is MultiMeshNode)
		target.set_color(c)
		#var material = target.get_surface_material(0)
		#material.albedo_color = color
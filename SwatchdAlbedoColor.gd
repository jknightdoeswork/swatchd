tool
extends SwatchdApplier
class_name SwatchdAlbedoColor
func apply_color(color:Color) -> void:
	var target = get_target()
	if target:
		assert(target is MeshInstance)
		var material = target.get_surface_material(0)
		material.albedo_color = color
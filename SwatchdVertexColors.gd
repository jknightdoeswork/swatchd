tool
extends SwatchdApplier
class_name SwatchdVertexColors

func apply_color(color:Color) -> void:
	# print ("[SwatchdVertexColors] apply_color " + str(color))
	var parent = get_target()
	if parent:
		assert(parent is MeshInstance)
		if parent.mesh:
			var array_mesh:ArrayMesh = null
			
			if Engine.is_editor_hint():
				parent.mesh = parent.mesh.duplicate()
			
			if parent.mesh is PrimitiveMesh:
				print ("[SwatchdVertexColors] parent mesh is PrimitiveMesh, converting to array mesh")
				array_mesh = ArrayMesh.new()
				var surface_arrays = parent.mesh.surface_get_arrays(0)
				array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_arrays)
			elif parent.mesh is ArrayMesh:
				array_mesh = parent.mesh

			
			
			var mesh_data_tool = MeshDataTool.new()
			mesh_data_tool.create_from_surface(array_mesh, 0)
			for i in range(mesh_data_tool.get_vertex_count()):
				mesh_data_tool.set_vertex_color(i, color)
			array_mesh.surface_remove(0)
			mesh_data_tool.commit_to_surface(array_mesh)
			parent.mesh = array_mesh

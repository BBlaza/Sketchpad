class_name PaintBucket
extends Tool

@export var title: String = "Paint Bucket"
@export var tolerance: float
@export var color: Color


func _init() -> void:
	name = "Paint Bucket"


func on_pointer_down(_position: Vector2, _canvas: Canvas) -> void:
	var project: Project = _canvas._project
	var current_page: Page = project.frames[project._current_frame]
	var layer: Image = current_page.layers[project._current_layer + 1]

	var directions = [Vector2i.DOWN, Vector2i.UP, Vector2i.LEFT, Vector2i.RIGHT]

	var start_pos = Vector2i(_position)
	var initial_color: Color = layer.get_pixelv(start_pos)
	var initial_vector: Vector3 = Vector3(initial_color.r, initial_color.g, initial_color.b)

	if initial_color == color:
		return

	var visited: Dictionary = {}
	var pixels: Array[Vector2i] = [start_pos]
	while !pixels.is_empty():
		var pixel = pixels.pop_back()
		layer.set_pixelv(pixel, color)
		for d in directions:
			var new_pixel = pixel + d

			if new_pixel.x < 0 or new_pixel.x >= project.width:
				continue
			elif new_pixel.y < 0 or new_pixel.y >= project.height:
				continue
			elif visited.has(new_pixel):
				continue

			var new_color: Color = layer.get_pixelv(new_pixel)
			if (
				initial_vector.distance_to(Vector3(new_color.r, new_color.g, new_color.b))
				<= tolerance * sqrt(3)
			):
				pixels.append(new_pixel)
				visited[new_pixel] = true
	current_page.set_layer(project._current_layer + 1, layer)

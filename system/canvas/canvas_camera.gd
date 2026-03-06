extends Camera2D

@export var max_zoom: float = 30.0
@export var min_zoom: float = 0.1

@export var zoom_speed: float = 1.1
@export var drag_speed: float = 1.0

var movable: bool = false

var is_dragging: bool = false

func _input(event: InputEvent) -> void:
	if movable:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_MIDDLE:
				is_dragging = event.pressed
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				_zoom(1.0 / zoom_speed)
			elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
				_zoom(zoom_speed)
		elif event is InputEventMouseMotion:
			if is_dragging:
				var drag_diff = (event.relative / zoom) * drag_speed
				position -= drag_diff

## Zooms the camera by a specified [param factor].
func _zoom(factor: float):
	zoom *= factor
	zoom.x = clamp(zoom.x, min_zoom, max_zoom)
	zoom.y = clamp(zoom.y, min_zoom, max_zoom)

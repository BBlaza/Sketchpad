class_name Brush
extends Tool

@export var title: String = "Brush"
@export var stamp: Texture2D = PlaceholderTexture2D.new()
@export var width: float = 1.0

var _line: Line2D
var color: Color

func _init() -> void:
	name = "Brush"

func on_pointer_down(_position: Vector2, _canvas: Canvas) -> void:
	_line = Line2D.new()
	_line.width = width
	_line.default_color = color
	_canvas.dynamic_node.add_child(_line)

func on_pointer_move(_position: Vector2, _canvas: Canvas) -> void:
	if _line and _canvas._project:
		_line.add_point(_position)

func on_pointer_up(_position: Vector2, _canvas: Canvas) -> void:
	_canvas.bake_page()

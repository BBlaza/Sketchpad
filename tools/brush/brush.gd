class_name Brush
extends Tool

@export var title: String = "Brush"
@export var stamp: Texture2D = PlaceholderTexture2D.new()
@export var width: float = 1.0

var _line: Line2D
var lineWidth: float
var color: Color
var texture: Texture2D

func _init() -> void:
	name = "Brush"

func on_pointer_down(_position: Vector2, _canvas: Canvas) -> void:
	_line = Line2D.new()
	_line.texture_mode = Line2D.LINE_TEXTURE_TILE
	_line.width = lineWidth
	_line.default_color = color
	_line.texture = texture
	_canvas.dynamic_node.add_child(_line)

func on_pointer_move(_position: Vector2, _canvas: Canvas) -> void:
	if _line and _canvas._project:
		_line.add_point(_position)

func on_pointer_up(_position: Vector2, _canvas: Canvas) -> void:
	_canvas.bake_page()

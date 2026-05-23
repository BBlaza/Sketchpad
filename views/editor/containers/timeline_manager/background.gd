class_name CheckerBackground
extends Control

@export var square_size: int = 3
@export var color_a: Color = Color(0.75, 0.75, 0.75, 1.0)
@export var color_b: Color = Color(0.95, 0.95, 0.95, 1.0)


func _draw() -> void:
	var cols := ceili(size.x / square_size)
	var rows := ceili(size.y / square_size)

	for y in range(rows):
		for x in range(cols):
			var use_a := (x + y) % 2 == 0
			var color := color_a if use_a else color_b

			draw_rect(
				Rect2(Vector2(x * square_size, y * square_size), Vector2(square_size, square_size)),
				color
			)

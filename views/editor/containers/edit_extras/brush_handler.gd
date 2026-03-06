extends PanelContainer

@export var thick_sldr: Slider
@export var hard_sldr: Slider
@export var color_picker: ColorPickerButton
@export var brush_list: ItemList

var brushes = [
	load("res://tools/brush/big_circle/big_circle.tres"),
	load("res://tools/brush/big_semi_square/big_semi_square.tres"),
	load("res://tools/brush/big_square/big_square.tres")
]

var brush_width = 2.5
var brush_hardness = 1.0
var brush_color = Color.BLACK

@onready var root: Node = get_tree().current_scene


func _ready() -> void:
	brush_list.item_selected.connect(_on_brush_selected)
	thick_sldr.value_changed.connect(_on_thickness_changed)
	hard_sldr.value_changed.connect(_on_hardness_changed)
	color_picker.color_changed.connect(_on_color_changed)

	brush_list.select(0)
	_on_brush_selected(0)
	thick_sldr.value = brush_width
	hard_sldr.value = brush_hardness


func _on_thickness_changed(value: float) -> void:
	brush_width = value
	root.current_tool.width = brush_width


func _on_hardness_changed(value: float) -> void:
	brush_hardness = value
	root.current_tool.hardness = brush_hardness


func _on_color_changed(color: Color) -> void:
	brush_color = color
	root.current_tool.color = brush_color


func _on_brush_selected(index: int) -> void:
	root.current_tool = brushes[index]
	root.current_tool.hardness = brush_hardness
	root.current_tool.width = brush_width
	root.current_tool.color = brush_color

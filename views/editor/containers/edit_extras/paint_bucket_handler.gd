extends PanelContainer

@export var tolerance_sldr: Slider
@export var tolerance_label: Label
@export var color_picker: ColorPickerButton
@export var tool: Tool

var tolerance: float
var fill_color: Color

@onready var root: Node = get_tree().current_scene


func _ready() -> void:
	color_picker.color_changed.connect(_on_color_changed)
	tolerance_sldr.value_changed.connect(_on_tolerance_changed)

	tolerance_sldr.value = tolerance


func _on_tolerance_changed(value: float) -> void:
	tolerance = value
	tolerance_label.text = "%d%%" % (value * 100)
	root.current_tool.tolerance = tolerance


func _on_color_changed(color: Color) -> void:
	fill_color = color
	root.current_tool.color = fill_color

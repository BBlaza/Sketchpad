extends PanelContainer

@onready var thick_sldr = $VBoxContainer/HBoxContainer/BrushSetting/TkSldrContainer/ThicknessSlider
@onready var hard_sldr = $VBoxContainer/HBoxContainer/BrushSetting/HdSldrContainer/HardnessSlider
@onready var color_picker = $VBoxContainer/HBoxContainer/ColorHeader/ColorPickerButton
@onready var brush_list = $VBoxContainer/BrushesHeader/BrushList
@onready var root: Node = get_tree().current_scene

const BRUSH_TEXTURES := [
	preload("res://tools/brush/big_circle/brush_template.png"),
	preload("res://tools/brush/big_semi_square/brush_template.png"),
	preload("res://tools/brush/big_square/brush_template.png"),
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	brush_list.item_selected.connect(_on_brush_selected)
	thick_sldr.value_changed.connect(_on_thickness_changed)
	color_picker.color_changed.connect(_on_color_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_thickness_changed(value: float) -> void:
	if root.brush:
		root.brush.lineWidth = thick_sldr.value
		
func _on_color_changed(color: Color) -> void:
	if root.brush:
		root.brush.color = color

func _on_brush_selected(index: int) -> void:
	var tex: Texture2D = BRUSH_TEXTURES[index]
	if tex == null:
		return
	root.brush.texture = tex

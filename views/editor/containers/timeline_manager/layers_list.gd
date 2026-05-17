class_name LayersList
extends VBoxContainer

var title: String = "Frame X"
var cell_min_size: Vector2 = Vector2(120, 40)

var title_label: Label
var grid: VBoxContainer

var selected_indices: Array[int] = []
var last_selected_index: int = -1

var normal_style: StyleBoxFlat
var selected_style: StyleBoxFlat
var current_style: StyleBoxFlat

var frame_index: int
var current_layer: int = -1

var displayed_page: Page

signal selection_changed(source: LayersList)
signal copy_layers(layers: Array[Image], names: Array[String])

func _ready() -> void:
	_create_styles()
	build_table()


func _create_styles() -> void:
	normal_style = StyleBoxFlat.new()
	normal_style.bg_color = Color(0.12, 0.12, 0.12, 1.0)
	normal_style.border_color = Color.BLUE
	normal_style.set_border_width_all(2)
	normal_style.set_content_margin_all(8)

	selected_style = StyleBoxFlat.new()
	selected_style.bg_color = Color(0.20, 0.35, 0.75, 1.0)
	selected_style.border_color = Color(0.70, 0.85, 1.0, 1.0)
	selected_style.set_border_width_all(4)
	selected_style.set_content_margin_all(8)
	
	current_style = StyleBoxFlat.new()
	current_style.bg_color = Color(0.069, 0.141, 0.336, 1.0)
	current_style.border_color = Color(0.311, 0.385, 0.457, 1.0)
	current_style.set_border_width_all(4)
	current_style.set_content_margin_all(8)


func build_table() -> void:
	for child in get_children():
		child.queue_free()

	selected_indices.clear()
	last_selected_index = -1

	title_label = Label.new()
	title_label.text = title
	title_label.add_theme_color_override("font_color", Color.BLACK)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size", 24)
	add_child(title_label)

	grid = VBoxContainer.new()
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(grid)


func set_data(pg: Page) -> void:
	displayed_page = pg
	for child in grid.get_children():
		child.queue_free()

	selected_indices.clear()
	last_selected_index = -1

	for i in range(displayed_page.layers.size()):
		var cell := create_cell(pg.names[i], pg.layers[i], i)
		grid.add_child(cell)

func create_cell(text: String, image: Image, index: int) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = cell_min_size

	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	panel.add_theme_stylebox_override("panel", normal_style)

	panel.set_meta("cell_index", index)

	var row := HBoxContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var texture := ImageTexture.create_from_image(image)

	var thumbnail_holder := Control.new()
	thumbnail_holder.custom_minimum_size = Vector2(40, 40)
	thumbnail_holder.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var checker := CheckerBackground.new()
	checker.set_anchors_preset(Control.PRESET_FULL_RECT)
	checker.mouse_filter = Control.MOUSE_FILTER_IGNORE
	thumbnail_holder.add_child(checker)

	var texture_rect := TextureRect.new()
	texture_rect.texture = texture
	texture_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	thumbnail_holder.add_child(texture_rect)

	var label := Label.new()
	if text.length() > 12:
		label.text = text.substr(0,12) + "..."
	else:
		label.text = text
	label.add_theme_font_size_override("font_size", 8)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE

	row.add_child(thumbnail_holder)
	row.add_child(label)

	panel.add_child(row)

	panel.gui_input.connect(_on_cell_gui_input.bind(panel))

	return panel


func _on_cell_gui_input(event: InputEvent, panel: PanelContainer) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var index: int = panel.get_meta("cell_index")

			var ctrl_or_command_pressed = event.ctrl_pressed or event.meta_pressed
			var shift_pressed = event.shift_pressed

			handle_cell_selection(index, ctrl_or_command_pressed, shift_pressed)


func handle_cell_selection(index: int, ctrl_or_command_pressed: bool, shift_pressed: bool) -> void:
	if shift_pressed and last_selected_index != -1:
		if not ctrl_or_command_pressed:
			selected_indices.clear()

		var start_index := mini(last_selected_index, index)
		var end_index := maxi(last_selected_index, index)

		for i in range(start_index, end_index + 1):
			if not selected_indices.has(i):
				selected_indices.append(i)

	elif ctrl_or_command_pressed:
		if selected_indices.has(index):
			selected_indices.erase(index)
		else:
			selected_indices.append(index)

		last_selected_index = index

	else:
		selected_indices.clear()
		selected_indices.append(index)
		current_layer = index
		last_selected_index = index

	update_cell_styles()
	selection_changed.emit(self)


func update_cell_styles() -> void:
	for child in grid.get_children():
		var panel := child as PanelContainer
		var index: int = panel.get_meta("cell_index")

		if selected_indices.has(index):
			panel.add_theme_stylebox_override("panel", selected_style)
		elif index == current_layer:
			panel.add_theme_stylebox_override("panel", current_style)
		else:
			panel.add_theme_stylebox_override("panel", normal_style)


func clear_selection() -> void:
	selected_indices.clear()
	last_selected_index = -1
	update_cell_styles()


func copy() -> void:
	if current_layer == -1:
		return
	var copies: Array[Image]
	var copied_names: Array[String]
	for i in range(displayed_page.layers.size()):
		if i in selected_indices:
			copies.append(displayed_page.layers[i].duplicate())
			copied_names.append(displayed_page.names[i])

	copy_layers.emit(copies, copied_names)


func paste(pasteboard: Array[Image], names: Array[String]) -> void:
	if current_layer == -1:
		return

	for i in pasteboard.size():
		displayed_page.insert_layer(current_layer + 1, pasteboard[i], names[i])


func cut() -> void:
	if current_layer == -1:
		return
	copy()
	for i in selected_indices:
		displayed_page.delete_layer(i)
